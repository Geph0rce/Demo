//
//  RFBluetoothPeripheralRow.h
//  demo
//
//  Created by qianjie on 2019/8/28.
//  Copyright © 2019 Zen. All rights reserved.
//

#import <RFCommonUI/RFCommonUI.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface RFBluetoothPeripheralRow : RFTableRow

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
