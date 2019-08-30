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
typedef void(^RFBluetoothDataManagerBlock)(RFBluetoothDataManager *manager, __kindof RFBluetoothPackage * _Nullable package, NSError * _Nullable error);

@interface RFBluetoothDataManager : NSObject

@property (nonatomic, readonly, strong) RFBluetoothManager *bluetooth;

- (void)requestVoltageData:(RFBluetoothDataManagerBlock)completion;

- (void)requestCurrentData:(RFBluetoothDataManagerBlock)completion;

- (void)requestBatteryPowerData:(RFBluetoothDataManagerBlock)completion;

@end

NS_ASSUME_NONNULL_END
