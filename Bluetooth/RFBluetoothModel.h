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

- (UInt8)int8AtIndex:(UInt8)index;

- (UInt16)int16AtIndex:(UInt8)index;

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
@end

@interface RFCurrentPackage : RFBluetoothPackage


// 产品ID
@property (nonatomic, assign) UInt8 id_;
// 充电
@property (nonatomic, assign) BOOL hasCharge;
// 放电
@property (nonatomic, assign) BOOL hasDischarge;
// 是否有MOS温度
@property (nonatomic, assign) BOOL hasMosTemperature;
// 是否 有环境温度
@property (nonatomic, assign) BOOL hasEnvironmentTemperature;
// 电流 (单位10mA)
@property (nonatomic, assign) UInt16 electricityCurrent;
// 电芯过压保护
@property (nonatomic, assign) BOOL hasCellsOvervoltageProtection;
// 总压过压保护
@property (nonatomic, assign) BOOL hasTotalVoltageProtection;
// 充满保护
@property (nonatomic, assign) BOOL hasFullProtection;
// 电芯欠压保护
@property (nonatomic, assign) BOOL hasCellsUndervoltageProtection;
// 总压欠压保护
@property (nonatomic, assign) BOOL hasTotalUndervoltageProtection;
// 充电温度保护
@property (nonatomic, assign) BOOL hasChargeTemperatureProtection;
// 放电电温度保护
@property (nonatomic, assign) BOOL hasDischargeTemperatureProtection;
// Mos过温保护
@property (nonatomic, assign) BOOL hasMosProtection;
// 高温保护
@property (nonatomic, assign) BOOL hasHighTemperatureProtection;
// 低温保护
@property (nonatomic, assign) BOOL hasLowTemperatureProtection;
// 放电短路保护
@property (nonatomic, assign) BOOL hasDischargeShortProtection;
// 放电过流保护
@property (nonatomic, assign) BOOL hasDischargeOvercurrentProtection;
// 充电过流保护
@property (nonatomic, assign) BOOL hasChargeOvercurrentProtection;
// 环境高温保护
@property (nonatomic, assign) BOOL hasEnvironmentHighTemperatureProtection;
// 环境低温保护
@property (nonatomic, assign) BOOL hasEnvironmentLowTemperatureProtection;
// 温度探头数
@property (nonatomic, assign) NSInteger N;
// 电芯温度数
@property (nonatomic, assign) NSInteger X;
// 电芯温度列表
@property (nonatomic, strong) NSArray <NSNumber *> *temperatureList;
// MOS 温度
@property (nonatomic, assign) NSInteger mosTemperature;
// 环境温度
@property (nonatomic, assign) NSInteger environmentTemperature;
// 软件版本
@property (nonatomic, assign) NSInteger softVersion;
// 放电MOS开关
@property (nonatomic, assign) BOOL dischargeMosOpen;
// 充电mos开关
@property (nonatomic, assign) BOOL chargeMosOpen;
// 温度采集失效
@property (nonatomic, assign) BOOL terperatureGatherLose;
// 电压采集失效
@property (nonatomic, assign) BOOL voltageGatherLose;
// 放电MOS失效
@property (nonatomic, assign) BOOL dischargeMosLose;
// 充电MOS失效
@property (nonatomic, assign) BOOL chargeMosLose;

@end


@interface RFBatteryPowerPackage : RFBluetoothPackage

@property (nonatomic, assign) UInt8 id_;
@property (nonatomic, assign) UInt8 soc;
@property (nonatomic, assign) UInt16 recycleCount;
@property (nonatomic, assign) UInt32 designCapacity;
@property (nonatomic, assign) UInt32 fullCapacity;
@property (nonatomic, assign) UInt32 leftCapacity;
@property (nonatomic, assign) UInt16 dischargeLeftTime;
@property (nonatomic, assign) UInt16 rechargeLeftTime;
@property (nonatomic, assign) UInt16 chargeInterval;
@property (nonatomic, assign) UInt16 chargeIntervalMax;
@property (nonatomic, assign) UInt16 totalVoltage;
@property (nonatomic, assign) UInt16 maxVoltage;
@property (nonatomic, assign) UInt16 minVoltage;

@end

@interface RFBluetoothModel : NSObject

@end

NS_ASSUME_NONNULL_END
