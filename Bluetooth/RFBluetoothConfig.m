//
//  RFBluetoothConfig.m
//  demo
//
//  Created by qianjie on 2019/8/27.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothConfig.h"

@implementation RFBluetoothConfig

+ (RFBluetoothConfig *)defaultConfig {
    RFBluetoothConfig *config = [[RFBluetoothConfig alloc] init];
    config.serviceUUID = @"FF00";
    config.readCharacteristicUUID = @"FF01"; //@"49535343-1E4D-4BD9-BA61-23C647249616";
    config.writeCharacteristicUUID = @"FF02"; //@"49535343-8841-43F4-A8D4-ECBE34729BB3";
    return config;
}

@end
