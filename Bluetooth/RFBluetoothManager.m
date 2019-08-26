//
//  RFBluetoothManager.m
//  demo
//
//  Created by Roger on 2019/8/20.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothManager.h"

NSString *const RFBluetoothManagerBluetoothStateDidChange = @"RFBluetoothManagerBluetoothStateDidChange";

@interface RFBluetoothManager () <CBCentralManagerDelegate>

@property (nonatomic, readwrite, strong) CBCentralManager *centralManager;
@property (nonatomic, readwrite, strong) NSMutableArray <CBPeripheral *> *peripherals;

@property (nonatomic, copy) dispatch_queue_t blueQueue;
@property (nonatomic, assign) CBManagerState state;

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

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    self.state = central.state;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (![self.peripherals containsObject:peripheral] && peripheral.services.count) {
        [self.peripherals addObject:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict {
    
}


#pragma mark - CBPeripheralDelegate

//- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
//    [peripheral discoverServices:nil];
//}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
//    if (!error) {
//        for (CBService *service in peripheral.services) {
//            NSLog(@"serviceUUID:%@", service.UUID.UUIDString);
//            if ([service.UUID.UUIDString isEqualToString:ST_SERVICE_UUID]) {
//                [service.peripheral discoverCharacteristics:nil forService:service];
//            }
//        }
//    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
//        if ([characteristic.UUID.UUIDString isEqualToString:ST_CHARACTERISTIC_UUID_READ]) {
//            self.read = characteristic;
//            [self.peripheral setNotifyValue:YES forCharacteristic:self.read];
//        } else if ([characteristic.UUID.UUIDString isEqualToString:ST_CHARACTERISTIC_UUID_WRITE]) {
//            self.write = characteristic;
//        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"===写入错误：%@",error);
    }else{
        NSLog(@"===写入成功");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *value = characteristic.value;
    NSLog(@"蓝牙回复：%@",value);
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

@end
