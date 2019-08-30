//
//  RFBluetoothModel.h
//  demo
//
//  Created by qianjie on 2019/8/30.
//  Copyright © 2019 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 数据包起始
typedef struct {
    UInt8 begin;
    UInt8 id_;
    UInt8 address;
    UInt8 length;
} RFBluetoothPackageBegin;

// 数据包结束
typedef struct {
    UInt8 end;
} RFBluetoothPackageEnd;


@interface RFBluetoothPackage : NSObject

@property (nonatomic, readonly, strong) NSData *rawData;
@property (nonatomic, readonly, strong) NSData *data;

@property (nonatomic, readonly, assign) BOOL valid;

- (void)appendData:(NSData *)data;

@end

@interface RFVoltagePackage : RFBluetoothPackage

@end

@interface RFCurrentPackage : RFBluetoothPackage

@end


@interface RFBatteryPowerPackage : RFBluetoothPackage

@end

@interface RFBluetoothModel : NSObject

@end

NS_ASSUME_NONNULL_END
