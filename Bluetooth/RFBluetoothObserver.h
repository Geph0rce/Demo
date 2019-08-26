//
//  RFBluetoothObserver.h
//  demo
//
//  Created by qianjie on 2019/8/26.
//  Copyright © 2019 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RFBluetoothConnectStatus) {
    RFBluetoothConnectStatusUnknow = 0,
    RFBluetoothConnectStatusConnect = 1,
    RFBluetoothConnectStatusFaildToConnect = 2,
    RFBluetoothConnectStatusDisconnect = 3
};

typedef void(^RFBluetoothStateDidChangeBlock)(CBCentralManager *centralManager);
typedef void(^RFBluetoothDidDiscoverPeripheralBlock)(CBCentralManager *centralManager, CBPeripheral *peripheral, NSDictionary<NSString *,id> *advertisementData, NSNumber *RSSI);
typedef void(^RFBluetoothConnectPeripheralBlock)(CBCentralManager *centralManager, CBPeripheral *peripheral, RFBluetoothConnectStatus status);

@interface RFBluetoothObserver : NSObject

@property (nonatomic, copy) RFBluetoothStateDidChangeBlock stateDidChange;


@end

NS_ASSUME_NONNULL_END
