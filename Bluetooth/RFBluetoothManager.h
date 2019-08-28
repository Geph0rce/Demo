//
//  RFBluetoothManager.h
//  demo
//
//  Created by Roger on 2019/8/20.
//  Copyright © 2019 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "RFBluetoothConfig.h"
#import "RFBluetoothObserver.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RFBluetoothDidDiscoverPeripheralBlock)(CBCentralManager *centralManager, CBPeripheral *peripheral, NSDictionary<NSString *,id> *advertisementData, NSNumber *RSSI);
typedef void(^RFBluetoothManagerResponseBlock)(CBPeripheral *peripheral, NSData * _Nullable data, NSError * _Nullable error);

typedef void(^RFBluetoothDidDiscoverCharacteristicBlock)();

@interface RFBluetoothManager : NSObject

@property (nonatomic, readonly, strong) CBCentralManager *centralManager;
@property (nonatomic, readonly, strong) NSMutableArray <CBPeripheral *> *peripherals;

@property (nonatomic, assign) RFBluetoothConfig *config;

+ (instancetype)sharedInstance;

- (void)addBluetoothObserver:(RFBluetoothObserver *)observer;

- (void)removeBluetoothObserver:(RFBluetoothObserver *)observer;

- (void)scanDidDiscoverPeripheral:(RFBluetoothDidDiscoverPeripheralBlock)block;

- (void)connect:(CBPeripheral *)peripheral;

- (void)write:(NSData *)data response:(RFBluetoothManagerResponseBlock)response;

@end

NS_ASSUME_NONNULL_END
