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

// 电压 - 状态
typedef NS_OPTIONS(UInt8, RFBluetoothVoltageStatus) {
    RFBluetoothVoltageStatusDischarge = 1 << 0,
    RFBluetoothVoltageStatusCharge = 1 << 1,
    RFBluetoothVoltageStatusMosTemperature = 1 << 4,
    RFBluetoothVoltageStatusEnvironmentTemperature = 1 << 5
};

// 电压 - 过压状态
typedef NS_OPTIONS(UInt8, RFBluetoothOvervoltageStatus) {
    RFBluetoothOvervoltageStatusCell = 1 << 0,
    RFBluetoothOvervoltageStatusTotal = 1 << 1,
    RFBluetoothOvervoltageStatusFull = 1 << 4
};



@interface RFBluetoothPackage ()

@property (nonatomic, readwrite, strong) NSData *rawData;
@property (nonatomic, assign) RFBluetoothPackageBegin begin;
@property (nonatomic, assign) RFBluetoothPackageEnd end;

@end

@implementation RFBluetoothPackage

- (void)appendData:(NSData *)data {
    NSMutableData *md = [[NSMutableData alloc] init];
    if (!(data.length == 8)) {
        return;
    }
    
    if (self.rawData.length >= 8 && !self.valid) {
        [md appendData:self.rawData];
        [md appendData:data];
    } else {
        RFBluetoothPackageBegin begin;
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


- (Byte)byteAtIndex:(UInt8)index {
    Byte byte = 0;
    if (self.rawData.length > index) {
        [self.rawData getBytes:&byte range:NSMakeRange(index, 1)];
    }
    return byte;
}

- (NSUInteger)integerAtIndex:(UInt8)index {
    NSUInteger integer = 0;
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
   
    self.cellCount = [self byteAtIndex:6];
    self.temperatureDetectorCount = [self byteAtIndex:7];
    
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (UInt8 i = 0; i < self.cellCount; i++) {
        UInt8 index = 9 + 2 * i;
        RFCellVoltage *cell = [[RFCellVoltage alloc] init];
        cell.voltage = [self integerAtIndex:index];
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

@implementation RFCurrentPackage

@end


@implementation RFBatteryPowerPackage

- (void)parserData {
    if (!self.valid) {
        return;
    }
    
    self.id_ = [self byteAtIndex:1];
    self.soc = [self byteAtIndex:7];
    self.recycleCount = [self integerAtIndex:9];
    
    self.designCapacity = [self capacity:12];
    self.fullCapacity = [self capacity:18];
    self.leftCapacity = [self capacity:24];
    
    self.dischargeLeftTime = [self integerAtIndex:30];
    self.rechargeLeftTime = [self integerAtIndex:33];
    self.chargeInterval = [self integerAtIndex:36];
    self.chargeIntervalMax = [self integerAtIndex:38];
    self.totalVoltage = [self integerAtIndex:47];
    self.maxVoltage = [self integerAtIndex:49];
    self.minVoltage = [self integerAtIndex:51];
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
