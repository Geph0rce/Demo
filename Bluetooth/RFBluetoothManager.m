//
//  RFBluetoothManager.m
//  demo
//
//  Created by Roger on 2019/8/20.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothManager.h"

@interface RFBluetoothManager () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, readwrite, strong) CBCentralManager *centralManager;

@property (nonatomic, copy) dispatch_queue_t blueQueue;
@property (nonatomic, assign) CBManagerState state;

@property (nonatomic, strong) NSMutableArray <RFBluetoothObserver *> *bluetoothObservers;

@end

@implementation RFBluetoothManager

+ (void)load {
    [RFBluetoothManager sharedInstance];
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

- (void)scan:(NSArray<CBUUID *> *)serviceUUIDs options:(NSDictionary *)options {
    [self.centralManager scanForPeripheralsWithServices:serviceUUIDs options:options];
}

- (void)connect:(CBPeripheral *)peripheral {
    [self disconnect];
    peripheral.delegate = self;
    [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)disconnect {
    if (self.peripheral) {
        [self.centralManager cancelPeripheralConnection:self.peripheral];
        self.peripheral = nil;
    }
}

- (void)write:(NSData *)data charateristic:(CBCharacteristic *)characteristic {
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

- (void)reset {
    self.peripheral = nil;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    self.state = central.state;
    [self.bluetoothObservers enumerateObjectsUsingBlock:^(RFBluetoothObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !obj.stateDidChange ?: obj.stateDidChange(central);
    }];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    [self.bluetoothObservers enumerateObjectsUsingBlock:^(RFBluetoothObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !obj.didDiscoverPeripheral ?: obj.didDiscoverPeripheral(central, peripheral, advertisementData, RSSI);
    }];
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
    [self.bluetoothObservers enumerateObjectsUsingBlock:^(RFBluetoothObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !obj.didDiscoverCharacteristics ?: obj.didDiscoverCharacteristics(peripheral, service, error);
    }];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    [self.bluetoothObservers enumerateObjectsUsingBlock:^(RFBluetoothObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !obj.didWriteValue ?: obj.didWriteValue(peripheral, characteristic, error);
    }];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    [self.bluetoothObservers enumerateObjectsUsingBlock:^(RFBluetoothObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !obj.didUpdateValue ?: obj.didUpdateValue(peripheral, characteristic, error);
    }];
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

- (NSMutableArray<RFBluetoothObserver *> *)bluetoothObservers {
    if (!_bluetoothObservers) {
        _bluetoothObservers = [[NSMutableArray alloc] init];
    }
    return _bluetoothObservers;
}

@end
