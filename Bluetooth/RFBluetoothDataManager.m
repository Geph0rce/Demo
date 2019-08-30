//
//  RFBluetoothDataManager.m
//  demo
//
//  Created by qianjie on 2019/8/30.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothDataManager.h"

@interface RFBluetoothDataManager ()

@property (nonatomic, strong) CBCharacteristic *readCharacteristic;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;

@property (nonatomic, strong) RFBluetoothObserver *observer;

@property (nonatomic, strong) RFBluetoothPackage *package;

@property (nonatomic, copy) RFBluetoothDataManagerBlock didReceivePackage;


@end

@implementation RFBluetoothDataManager


#pragma mark - Request

- (void)requestVoltageData:(RFBluetoothDataManagerBlock)completion {
    self.didReceivePackage = completion;
    self.package = [[RFVoltagePackage alloc] init];
    NSString *cmd = @"EAD10104FF02F9F5";
    NSData *data = [self dataWithHexString:cmd];
    DLog(@"%@", data);
}

- (void)requestCurrentData:(RFBluetoothDataManagerBlock)completion {
    self.didReceivePackage = completion;
    self.package = [[RFCurrentPackage alloc] init];
    NSString *cmd = @"EAD10104FF03F8F5";
}

- (void)requestBatteryPowerData:(RFBluetoothDataManagerBlock)completion {
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
        _observer.connectStatusDidChange = ^(CBCentralManager * _Nonnull centralManager, CBPeripheral * _Nonnull peripheral, RFBluetoothConnectStatus status) {
            
        };
        
        _observer.didDiscoverCharacteristics = ^(CBPeripheral * _Nonnull peripheral, CBService * _Nonnull service, NSError * _Nonnull error) {
            
        };
        
        
        _observer.didWriteValue = ^(CBPeripheral * _Nonnull peripheral, CBCharacteristic * _Nonnull characteristic, NSError * _Nonnull error) {
            
        };
        
        _observer.didUpdateValue = ^(CBPeripheral * _Nonnull peripheral, CBCharacteristic * _Nonnull characteristic, NSError * _Nonnull error) {
            strongify(self);
            if (!self.package.valid) {
                [self.package appendData:characteristic.value];
            } else {
                !self.didReceivePackage ?: self.didReceivePackage(self, self.package, error);
                self.package = nil;
                self.didReceivePackage = nil;
            }
        };
    }
    return _observer;
}

@end
