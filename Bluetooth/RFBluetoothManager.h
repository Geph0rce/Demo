//
//  RFBluetoothManager.h
//  demo
//
//  Created by Roger on 2019/8/20.
//  Copyright © 2019 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "RFBluetoothObserver.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const RFBluetoothManagerBluetoothStateDidChange;


@interface RFBluetoothManager : NSObject

@property (nonatomic, readonly, strong) CBCentralManager *centralManager;
@property (nonatomic, readonly, strong) NSMutableArray <CBPeripheral *> *peripherals;

+ (instancetype)sharedInstance;

//- (void)scanDidDiscoverPeripheral:(RFBluetoothDidDiscoverPeripheralBlock)block;

- (void)connect:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END
