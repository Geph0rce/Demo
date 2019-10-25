//
//  RFBluetoothModel.m
//  demo
//
//  Created by qianjie on 2019/8/30.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothModel.h"

static UInt8 const kRFBluetoothPackageBegin = 0xEA;
static UInt8 const kRFBluetoothPackageId = 0xD1;
static UInt8 const kRFBluetoothPackageAddress = 0x01;
static UInt8 const kRFBluetoothPackageEnd = 0xF5;

@interface RFBluetoothPackage ()

@property (nonatomic, readwrite, strong) NSData *rawData;
@property (nonatomic, assign) RFBluetoothPackageBegin begin;
@property (nonatomic, assign) RFBluetoothPackageEnd end;

@end

@implementation RFBluetoothPackage

- (void)appendData:(NSData *)data {
    NSMutableData *md = [[NSMutableData alloc] init];
    
    RFBluetoothPackageBegin begin;
    if (self.rawData.length >= 8 && !self.valid) {
        [md appendData:self.rawData];
        [md appendData:data];
    } else if (data.length >= sizeof(begin)){
        [data getBytes:&begin range:NSMakeRange(0, sizeof(begin))];
        if (begin.begin == kRFBluetoothPackageBegin &&
            begin.id_ == kRFBluetoothPackageId &&
            begin.address == kRFBluetoothPackageAddress) {
            [md appendData:data];
        }
    }
    self.rawData = md.copy;
    
    DLog(@"rawData: %@", self.rawData);
}

- (void)parserData {
    
}


- (Byte)int8AtIndex:(UInt8)index {
    Byte byte = 0;
    if (self.rawData.length > index) {
        [self.rawData getBytes:&byte range:NSMakeRange(index, 1)];
    }
    return byte;
}

- (UInt16)int16AtIndex:(UInt8)index {
    UInt16 integer = 0;
    if (self.rawData.length > (index + 1)) {
        Byte bytes[2] = {0};
        [self.rawData getBytes:&bytes range:NSMakeRange(index, 2)];
        integer = bytes[0] << 8 | bytes[1];
    }
    return integer;
}

#pragma mark - Getters

- (RFBluetoothPackageBegin)begin {
    if (self.rawData.length >= 8) {
        [self.rawData getBytes:&_begin range:NSMakeRange(0, sizeof(_begin))];
    }
    return _begin;
}

- (RFBluetoothPackageEnd)end {
    RFBluetoothPackageBegin begin = self.begin;
    if (self.rawData.length >= 8 && begin.length > 0) {
        NSInteger loction = (sizeof(begin) + begin.length - 1);
        if (self.rawData.length > loction) {
            [self.rawData getBytes:&_end range:NSMakeRange(loction, 1)];
        }
    }
    return _end;
}

- (BOOL)valid {
    RFBluetoothPackageBegin begin = self.begin;
    RFBluetoothPackageEnd end = self.end;
    BOOL beginValid = NO;
    if (begin.begin == kRFBluetoothPackageBegin &&
        begin.id_ == kRFBluetoothPackageId &&
        begin.address == kRFBluetoothPackageAddress) {
        beginValid = YES;
    }
    
    BOOL endValid = (end.end == kRFBluetoothPackageEnd);
    return beginValid && endValid;
}

@end


@implementation RFBluetoothModel

@end

@implementation RFCellVoltage

@end

@implementation RFVoltagePackage

- (void)parserData {
    if (!self.valid) {
        return;
    }
   
    self.cellCount = [self int8AtIndex:6];
    self.temperatureDetectorCount = [self int8AtIndex:7];
    
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (UInt8 i = 0; i < self.cellCount; i++) {
        UInt8 index = 9 + 2 * i;
        RFCellVoltage *cell = [[RFCellVoltage alloc] init];
        cell.voltage = [self int16AtIndex:index];
        [cells addObject:cell];
    }
    
    self.cells = cells.copy;
    DLog(@"cells: %@", @(cells.count));
}

#pragma mark - Getters

- (NSUInteger)maxVoltage {
    if (_maxVoltage == 0) {
       NSArray <RFCellVoltage *> *cells = [self.cells sortedArrayUsingComparator:^NSComparisonResult(RFCellVoltage *  _Nonnull obj1, RFCellVoltage *  _Nonnull obj2) {
           return obj1.voltage > obj2.voltage ? NSOrderedAscending : NSOrderedDescending;
        }];
        
        if (cells.count) {
            _maxVoltage = cells[0].voltage;
        }
    }
    return _maxVoltage;
}

- (NSUInteger)minVoltage {
    if (_minVoltage == 0) {
        NSArray <RFCellVoltage *> *cells = [self.cells sortedArrayUsingComparator:^NSComparisonResult(RFCellVoltage *  _Nonnull obj1, RFCellVoltage *  _Nonnull obj2) {
            return obj1.voltage < obj2.voltage ? NSOrderedAscending : NSOrderedDescending;
        }];
        
        if (cells.count) {
            _minVoltage = cells[0].voltage;
        }
    }
    return _minVoltage;
}

- (NSUInteger)averageVoltage {
    if (_averageVoltage == 0 && self.cellCount > 0) {
        _averageVoltage = roundf(self.totalVoltage * 1.0 / self.cellCount);
    }
    return _averageVoltage;
}

- (NSUInteger)totalVoltage {
    if (_totalVoltage == 0) {
        __block NSUInteger total = 0;
        [self.cells enumerateObjectsUsingBlock:^(RFCellVoltage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            total += obj.voltage;
        }];
        _totalVoltage = total;
    }
    return _totalVoltage;
}

- (NSUInteger)differenceVoltage {
    return (self.maxVoltage - self.minVoltage);
}

@end

// 电流 - 状态
typedef NS_OPTIONS(UInt8, RFBluetoothCurrentStatus) {
    RFBluetoothCurrentStatusDischarge = 1 << 0,
    RFBluetoothCurrentStatusCharge = 1 << 1,
    RFBluetoothCurrentStatusMosTemperature = 1 << 4,
    RFBluetoothCurrentStatusEnvironmentTemperature = 1 << 5
};

// 电流状态 - 过压状态
typedef NS_OPTIONS(UInt8, RFBluetoothOvervoltageStatus) {
    RFBluetoothOvervoltageStatusCell = 1 << 0,
    RFBluetoothOvervoltageStatusTotal = 1 << 1,
    RFBluetoothOvervoltageStatusFull = 1 << 4
};

// 电流状态 - 过放状态欠压保护
typedef NS_OPTIONS(UInt8, RFBluetoothUndervoltageStatus) {
    RFBluetoothUndervoltageStatusCell = 1 << 0,
    RFBluetoothUndervoltageStatusTotal = 1 << 1
};

// 电流状态 - 温度保护状态
typedef NS_OPTIONS(UInt8, RFBluetoothTemperatureStatus) {
    RFBluetoothTemperatureStatusCharge = 1 << 0,
    RFBluetoothTemperatureStatusDischarge = 1 << 1,
    RFBluetoothTemperatureStatusMos = 1 << 2,
    RFBluetoothTemperatureStatusHigh = 1 << 4,
    RFBluetoothTemperatureStatusLow = 1 << 5
};

// 电流状态 - 保护状态
typedef NS_OPTIONS(UInt8, RFBluetoothProtectionStatus) {
    RFBluetoothProtectionStatusDichargeShort = 1 << 0,
    RFBluetoothProtectionStatusOverDischarge = 1 << 1,
    RFBluetoothProtectionStatusOverCharge = 1 << 2,
    RFBluetoothProtectionStatusHighTemperature = 1 << 4,
    RFBluetoothProtectionStatusLowTemperature = 1 << 5
};

// 电流状态 - Mos状态
typedef NS_OPTIONS(UInt8, RFBluetoothMosStatus) {
    RFBluetoothMosStatusDischarge = 1 << 0,
    RFBluetoothMosStatusCharge = 1 << 1
};

// 电流状态 - 失效状态
typedef NS_OPTIONS(UInt8, RFBluetoothInvalidStatus) {
    RFBluetoothInvalidStatusTemperature = 1 << 0,
    RFBluetoothInvalidStatusVoltage = 1 << 1,
    RFBluetoothInvalidStatusDischargeMos = 1 << 2,
    RFBluetoothInvalidStatusChargeMos = 1 << 3
};



@implementation RFCurrentPackage

- (void)parserData {
    if (!self.valid) {
        return;
    }
    
    self.id_ = [self int8AtIndex:1];
    RFBluetoothCurrentStatus currentStatus = [self int8AtIndex:6];
    self.hasDischarge = (currentStatus & RFBluetoothCurrentStatusDischarge);
    self.hasCharge = (currentStatus & RFBluetoothCurrentStatusCharge);
    self.hasMosTemperature = (currentStatus & RFBluetoothCurrentStatusMosTemperature);
    self.hasEnvironmentTemperature = (currentStatus & RFBluetoothCurrentStatusEnvironmentTemperature);
    self.electricityCurrent = [self int16AtIndex:7];
    
    RFBluetoothOvervoltageStatus overvoltageStatus = [self int8AtIndex:9];
    self.hasCellsOvervoltageProtection = (overvoltageStatus & RFBluetoothOvervoltageStatusCell);
    self.hasTotalVoltageProtection = (overvoltageStatus & RFBluetoothOvervoltageStatusTotal);
    self.hasFullProtection = (overvoltageStatus & RFBluetoothOvervoltageStatusFull);
    
    RFBluetoothUndervoltageStatus undervoltageStatus = [self int8AtIndex:10];
    self.hasCellsUndervoltageProtection = (undervoltageStatus & RFBluetoothUndervoltageStatusCell);
    self.hasTotalUndervoltageProtection = (undervoltageStatus & RFBluetoothUndervoltageStatusTotal);
    
    RFBluetoothTemperatureStatus temperatureStatus = [self int8AtIndex:11];
    self.hasChargeTemperatureProtection = (temperatureStatus & RFBluetoothTemperatureStatusCharge);
    self.hasDischargeTemperatureProtection = (temperatureStatus & RFBluetoothTemperatureStatusDischarge);
    self.hasMosProtection = (temperatureStatus & RFBluetoothTemperatureStatusMos);
    self.hasHighTemperatureProtection = (temperatureStatus & RFBluetoothTemperatureStatusHigh);
    self.hasLowTemperatureProtection = (temperatureStatus & RFBluetoothTemperatureStatusLow);
    
    RFBluetoothProtectionStatus protectionStatus = [self int8AtIndex:12];
    self.hasDischargeShortProtection = (protectionStatus & RFBluetoothProtectionStatusDichargeShort);
    self.hasDischargeOvercurrentProtection = (protectionStatus & RFBluetoothProtectionStatusOverDischarge);
    self.hasChargeOvercurrentProtection = (protectionStatus & RFBluetoothProtectionStatusOverCharge);
    self.hasHighTemperatureProtection = (protectionStatus & RFBluetoothProtectionStatusHighTemperature);
    self.hasLowTemperatureProtection = (protectionStatus & RFBluetoothProtectionStatusLowTemperature);

    self.N = [self int8AtIndex:13];
    self.X = self.N - self.hasMosTemperature - self.hasEnvironmentTemperature;
    
    NSMutableArray *temperatureList = [NSMutableArray array];
    for (int i = 0; i < self.X; i++) {
        UInt8 temperature = [self int8AtIndex:14 + i];
        [temperatureList addObject:@(temperature - 40)];
    }
    self.temperatureList = temperatureList;
    
    if (self.hasMosTemperature) {
        UInt8 temperature = [self int8AtIndex:14 + self.X];
        self.mosTemperature = temperature - 40;
    }
    
    if (self.hasEnvironmentTemperature) {
        UInt8 temperature = [self int8AtIndex:14 + self.X + 1];
        self.environmentTemperature = temperature - 40;
    }
    
    self.softVersion = [self int8AtIndex:(20 + self.N - 1)];
    
    RFBluetoothMosStatus mosStatus = [self int8AtIndex:(21 + self.N - 1)];
    self.dischargeMosOpen = (mosStatus & RFBluetoothMosStatusDischarge);
    self.chargeMosOpen = (mosStatus & RFBluetoothMosStatusCharge);
    
    RFBluetoothInvalidStatus invalidStatus = [self int8AtIndex:(22 + self.N - 1)];
    self.terperatureGatherLose = (invalidStatus & RFBluetoothInvalidStatusTemperature);
    self.voltageGatherLose = (invalidStatus & RFBluetoothInvalidStatusVoltage);
    self.dischargeMosLose = (invalidStatus & RFBluetoothInvalidStatusDischargeMos);
    self.chargeMosLose = (invalidStatus & RFBluetoothInvalidStatusChargeMos);
}

@end


@implementation RFBatteryPowerPackage

- (void)parserData {
    if (!self.valid) {
        return;
    }
    
    self.id_ = [self int8AtIndex:1];
    self.soc = [self int8AtIndex:7];
    self.recycleCount = [self int16AtIndex:9];
    
    self.designCapacity = [self capacity:12];
    self.fullCapacity = [self capacity:18];
    self.leftCapacity = [self capacity:24];
    
    self.dischargeLeftTime = [self int16AtIndex:30];
    self.rechargeLeftTime = [self int16AtIndex:33];
    self.chargeInterval = [self int16AtIndex:36];
    self.chargeIntervalMax = [self int16AtIndex:38];
    self.totalVoltage = [self int16AtIndex:47];
    self.maxVoltage = [self int16AtIndex:49];
    self.minVoltage = [self int16AtIndex:51];
}

#pragma mark - Utils

- (UInt32)capacity:(UInt8)index {
    UInt32 capacity = 0;
    if (self.rawData.length > (index + 4)) {
        Byte bytes[5] = {0};
        [self.rawData getBytes:&bytes range:NSMakeRange(index, 5)];
        capacity = bytes[0] << 24 | bytes[1] << 16 | bytes[3] << 8 | bytes[4];
    }
    return capacity;
}

@end
