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

@interface RFBluetoothManager : NSObject

@property (nonatomic, readonly, strong) CBCentralManager *centralManager;

// connected peripheral
@property (nonatomic, strong, nullable) CBPeripheral *peripheral;

+ (instancetype)sharedInstance;

- (void)addBluetoothObserver:(RFBluetoothObserver *)observer;

- (void)removeBluetoothObserver:(RFBluetoothObserver *)observer;

- (void)scan:(NSArray <CBUUID *> * _Nullable)serviceUUIDs options:(NSDictionary * _Nullable)options ;

- (void)connect:(CBPeripheral *)peripheral;

- (void)disconnect;

- (void)write:(NSData *)data charateristic:(CBCharacteristic *)characteristic;

@end

NS_ASSUME_NONNULL_END
