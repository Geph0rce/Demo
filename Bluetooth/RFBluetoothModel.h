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

- (void)parserData;

- (Byte)byteAtIndex:(UInt8)index;

- (NSUInteger)integerAtIndex:(UInt8)index;

@end

@interface RFCellVoltage : NSObject

@property (nonatomic, assign) NSInteger voltage;

@end

@interface RFVoltagePackage : RFBluetoothPackage

// 电池(电芯)串数
@property (nonatomic, assign) UInt8 cellCount;

// 温度探头数
@property (nonatomic, assign) UInt8 temperatureDetectorCount;

// 所有电芯(电压)
@property (nonatomic, strong) NSArray <RFCellVoltage *> *cells;

@property (nonatomic, assign) NSUInteger maxVoltage;
@property (nonatomic, assign) NSUInteger minVoltage;
@property (nonatomic, assign) NSUInteger averageVoltage;
@property (nonatomic, assign) NSUInteger totalVoltage;
@property (nonatomic, assign) NSUInteger differenceVoltage;

@end

@interface RFCurrentPackage : RFBluetoothPackage

@end


@interface RFBatteryPowerPackage : RFBluetoothPackage

@end

@interface RFBluetoothModel : NSObject

@end

NS_ASSUME_NONNULL_END
