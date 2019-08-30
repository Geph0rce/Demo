//
//  RFBluetoothDataManager.m
//  demo
//
//  Created by qianjie on 2019/8/30.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothDataManager.h"
#import "RFBluetoothConfig.h"

@interface RFBluetoothDataManager ()

@property (nonatomic, strong) CBCharacteristic *readCharacteristic;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;

@property (nonatomic, strong) RFBluetoothObserver *observer;

@property (nonatomic, strong) RFBluetoothPackage *package;

@property (nonatomic, copy) RFBluetoothDataManagerConnectBlock didConnectPeripheral;
@property (nonatomic, copy) RFBluetoothDataManagerPackageBlock didReceivePackage;
@property (nonatomic, copy) RFBluetoothDidDiscoverPeripheralBlock didDiscoverPeripheral;

@end

@implementation RFBluetoothDataManager

- (void)dealloc {
    [self.bluetooth removeBluetoothObserver:self.observer];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.bluetooth addBluetoothObserver:self.observer];
    }
    return self;
}

#pragma mark - Bluetooth

- (void)scanDidDiscoverPeripheral:(RFBluetoothDidDiscoverPeripheralBlock)didDiscoverPeripheral {
    self.didDiscoverPeripheral = didDiscoverPeripheral;
    RFBluetoothConfig *config = [RFBluetoothConfig defaultConfig];
    CBUUID *uuid = [CBUUID UUIDWithString:config.serviceUUID];
    [self.bluetooth scan:@[ uuid ] options:nil];
}

- (void)connect:(CBPeripheral *)peripheral completion:(nonnull RFBluetoothDataManagerConnectBlock)completion {
    self.didConnectPeripheral = completion;
    [self.bluetooth connect:peripheral];
}

- (void)disconnect {
    [self.bluetooth disconnect];
}


#pragma mark - Request

- (void)requestVoltageData:(RFBluetoothDataManagerPackageBlock)completion {
    self.didReceivePackage = completion;
    self.package = [[RFVoltagePackage alloc] init];
    NSString *cmd = @"EAD10104FF02F9F5";
    NSData *data = [self dataWithHexString:cmd];
    DLog(@"%@", data);
    if (self.bluetooth.peripheral && self.writeCharacteristic) {
        [self.bluetooth write:data charateristic:self.writeCharacteristic];
    } else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{ @"msg" : @"bluetooth error" }];
        !completion ?: completion(self, nil, error);
    }
}

- (void)requestCurrentData:(RFBluetoothDataManagerPackageBlock)completion {
    self.didReceivePackage = completion;
    self.package = [[RFCurrentPackage alloc] init];
    NSString *cmd = @"EAD10104FF03F8F5";
}

- (void)requestBatteryPowerData:(RFBluetoothDataManagerPackageBlock)completion {
    self.didReceivePackage = completion;
    self.package = [[RFBatteryPowerPackage alloc] init];
    NSString *cmd = @"EAD10104FF04FFF5";
}

#pragma mark - Utils

- (NSData *)dataWithHexString:(NSString *)hexString {
    NSMutableData *data = [[NSMutableData alloc] init];
    if (hexString.length > 0 && hexString.length % 2 == 0) {
        NSUInteger offset = 0;
        while (offset < hexString.length) {
            unsigned int number = 0;
            NSString *string = [hexString substringWithRange:NSMakeRange(offset, 2)];
            NSScanner *scaner = [NSScanner scannerWithString:string];
            [scaner scanHexInt:&number];
            [data appendBytes:&number length:1];
            offset += 2;
        }
    }
    return data;
}

#pragma mark - Getters

- (RFBluetoothManager *)bluetooth {
    return [RFBluetoothManager sharedInstance];
}

- (RFBluetoothObserver *)observer {
    if (!_observer) {
        _observer = [[RFBluetoothObserver alloc] init];
        weakify(self);
        _observer.stateDidChange = ^(CBCentralManager * _Nonnull centralManager) {
            
        };
        _observer.connectStatusDidChange = ^(CBCentralManager * _Nonnull centralManager, CBPeripheral * _Nonnull peripheral, RFBluetoothConnectStatus status) {
            strongify(self);
            self.readCharacteristic = nil;
            self.writeCharacteristic = nil;
        };
        
        _observer.didDiscoverPeripheral = ^(CBCentralManager * _Nonnull centralManager, CBPeripheral * _Nonnull peripheral, NSDictionary<NSString *,id> * _Nonnull advertisementData, NSNumber * _Nonnull RSSI) {
            strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                !self.didDiscoverPeripheral ?: self.didDiscoverPeripheral(centralManager, peripheral, advertisementData, RSSI);
            });
        };
        
        _observer.didDiscoverCharacteristics = ^(CBPeripheral * _Nonnull peripheral, CBService * _Nonnull service, NSError * _Nonnull error) {
            strongify(self);
            RFBluetoothConfig *config = [RFBluetoothConfig defaultConfig];
            if (![service.UUID.UUIDString isEqualToString:config.serviceUUID]) {
                return;
            }
            
            self.readCharacteristic = nil;
            self.writeCharacteristic = nil;
            [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.UUID.UUIDString isEqualToString:config.readCharacteristicUUID]) {
                    self.readCharacteristic = obj;
                    [peripheral setNotifyValue:YES forCharacteristic:obj];
                } else if ([obj.UUID.UUIDString isEqualToString:config.writeCharacteristicUUID]) {
                    self.writeCharacteristic = obj;
                }
            }];
            
            BOOL success = self.readCharacteristic && self.writeCharacteristic;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !self.didConnectPeripheral ?: self.didConnectPeripheral(self, success);
            });
        };
        
        
        _observer.didWriteValue = ^(CBPeripheral * _Nonnull peripheral, CBCharacteristic * _Nonnull characteristic, NSError * _Nonnull error) {
            
        };
        
        _observer.didUpdateValue = ^(CBPeripheral * _Nonnull peripheral, CBCharacteristic * _Nonnull characteristic, NSError * _Nonnull error) {
            strongify(self);
            [self.package appendData:characteristic.value];
            
            if (self.package.valid) {
                !self.didReceivePackage ?: self.didReceivePackage(self, self.package, error);
                self.package = nil;
                self.didReceivePackage = nil;
            }
        };
    }
    return _observer;
}

@end
