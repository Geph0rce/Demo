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
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict {
    
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

@end
