//
//  RFBluetoothDataManager.h
//  demo
//
//  Created by qianjie on 2019/8/30.
//  Copyright © 2019 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFBluetoothManager.h"
#import "RFBluetoothModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RFBluetoothDataManager;
typedef void(^RFBluetoothDataManagerPackageBlock)(RFBluetoothDataManager *manager, __kindof RFBluetoothPackage * _Nullable package, NSError * _Nullable error);
typedef void(^RFBluetoothDataManagerConnectBlock)(RFBluetoothDataManager *manager, BOOL success);

@interface RFBluetoothDataManager : NSObject

@property (nonatomic, readonly, strong) RFBluetoothManager *bluetooth;

- (void)scanDidDiscoverPeripheral:(RFBluetoothDidDiscoverPeripheralBlock)didDiscoverPeripheral;

- (void)connect:(CBPeripheral *)peripheral completion:(RFBluetoothDataManagerConnectBlock)completion;

- (void)disconnect;

- (void)requestVoltageData:(RFBluetoothDataManagerPackageBlock)completion;

- (void)requestCurrentData:(RFBluetoothDataManagerPackageBlock)completion;

- (void)requestBatteryPowerData:(RFBluetoothDataManagerPackageBlock)completion;

@end

NS_ASSUME_NONNULL_END
