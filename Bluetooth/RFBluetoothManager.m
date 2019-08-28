//
//  RFBluetoothManager.m
//  demo
//
//  Created by Roger on 2019/8/20.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothManager.h"

@interface RFBluetoothManager () <CBCentralManagerDelegate>

@property (nonatomic, readwrite, strong) CBCentralManager *centralManager;
@property (nonatomic, readwrite, strong) NSMutableArray <CBPeripheral *> *peripherals;

@property (nonatomic, copy) dispatch_queue_t blueQueue;
@property (nonatomic, assign) CBManagerState state;

@property (nonatomic, assign) CBPeripheral *peripheral;

@property (nonatomic, strong) CBCharacteristic *readCharacteristic;
@property (nonatomic, strong) CBCharacteristic *writeCharateristic;

@property (nonatomic, strong) NSMutableArray <RFBluetoothObserver *> *bluetoothObservers;

@property (nonatomic, copy) RFBluetoothManagerResponseBlock responseBlock;
@property (nonatomic, copy) RFBluetoothDidDiscoverPeripheralBlock didDiscoverPeripheral;

@end

@implementation RFBluetoothManager

+ (void)load {
    RFBluetoothManager *manager = [RFBluetoothManager sharedInstance];
    manager.config = [RFBluetoothManager defaultConfig];
}

+ (instancetype)sharedInstance {
    static RFBluetoothManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self centralManager];
        self.state = CBManagerStateUnknown;
    }
    return self;
}


#pragma mark - Public API

- (void)addBluetoothObserver:(RFBluetoothObserver *)observer {
    if ([observer isKindOfClass:[RFBluetoothObserver class]]) {
        [self.bluetoothObservers addObject:observer];
    }
}

- (void)removeBluetoothObserver:(RFBluetoothObserver *)observer {
    if (observer) {
        [self.bluetoothObservers removeObject:observer];
    }
}

- (void)scanDidDiscoverPeripheral:(RFBluetoothDidDiscoverPeripheralBlock)block {
    self.didDiscoverPeripheral = block;
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)connect:(CBPeripheral *)peripheral {
    [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)write:(NSData *)data response:(RFBluetoothManagerResponseBlock)response {
    self.responseBlock = response;
    if (self.writeCharateristic) {
        [self.peripheral writeValue:data forCharacteristic:self.writeCharateristic type:CBCharacteristicWriteWithResponse];
    } else {
        NSError *error = [NSError errorWithDomain:NSItemProviderErrorDomain code:-1 userInfo:@{ @"msg" : @"can not find write characteristic" }];
        !self.responseBlock ?: self.responseBlock(self.peripheral, nil, error);
    }
}

- (void)reset {
    self.peripheral = nil;
    self.writeCharateristic = nil;
    self.readCharacteristic = nil;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    self.state = central.state;
    [self.bluetoothObservers enumerateObjectsUsingBlock:^(RFBluetoothObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !obj.stateDidChange ?: obj.stateDidChange(central);
    }];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (![self.peripherals containsObject:peripheral] && peripheral.services.count) {
        [self.peripherals addObject:peripheral];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.didDiscoverPeripheral ?: self.didDiscoverPeripheral(central, peripheral, advertisementData, RSSI);
    });
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    self.peripheral = peripheral;
    [self.peripheral discoverServices:nil];
    [self.bluetoothObservers enumerateObjectsUsingBlock:^(RFBluetoothObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !obj.connectStatusDidChange ?: obj.connectStatusDidChange(central, peripheral, RFBluetoothConnectStatusConnect);
    }];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self reset];
    [self.bluetoothObservers enumerateObjectsUsingBlock:^(RFBluetoothObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !obj.connectStatusDidChange ?: obj.connectStatusDidChange(central, peripheral, RFBluetoothConnectStatusFaildToConnect);
    }];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self reset];
    [self.bluetoothObservers enumerateObjectsUsingBlock:^(RFBluetoothObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !obj.connectStatusDidChange ?: obj.connectStatusDidChange(central, peripheral, RFBluetoothConnectStatusDisconnect);
    }];
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict {
    
}


#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (!error) {
        [peripheral.services enumerateObjectsUsingBlock:^(CBService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [peripheral discoverCharacteristics:nil forService:obj];
        }];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID.UUIDString isEqualToString:self.config.readCharacteristicUUID]) {
            self.readCharacteristic = characteristic;
        } else if ([characteristic.UUID.UUIDString isEqualToString:self.config.writeCharacteristicUUID]) {
            self.writeCharateristic = characteristic;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        !self.responseBlock ?: self.responseBlock(peripheral, nil, error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([characteristic.UUID.UUIDString isEqualToString:self.config.readCharacteristicUUID]) {
        NSData *value = characteristic.value;
        !self.responseBlock ?: self.responseBlock(peripheral, value, nil);
    }
}

#pragma mark - Getters

- (CBCentralManager *)centralManager {
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:self.blueQueue];
    }
    return _centralManager;
}

- (dispatch_queue_t)blueQueue {
    if (!_blueQueue) {
        _blueQueue = dispatch_queue_create("com.roger.bluetooth", DISPATCH_QUEUE_SERIAL);
    }
    return _blueQueue;
}

- (NSMutableArray<CBPeripheral *> *)peripherals {
    if (!_peripherals) {
        _peripherals = [[NSMutableArray alloc] init];
    }
    return _peripherals;
}

+ (RFBluetoothConfig *)defaultConfig {
    RFBluetoothConfig *config = [[RFBluetoothConfig alloc] init];
    config.readCharacteristicUUID = @"49535343-1E4D-4BD9-BA61-23C647249616";
    config.writeCharacteristicUUID = @"49535343-8841-43F4-A8D4-ECBE34729BB3";
    return config;
}


- (NSMutableArray<RFBluetoothObserver *> *)bluetoothObservers {
    if (!_bluetoothObservers) {
        _bluetoothObservers = [[NSMutableArray alloc] init];
    }
    return _bluetoothObservers;
}

@end
