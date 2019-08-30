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
}

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

@implementation RFVoltagePackage

@end

@implementation RFCurrentPackage

@end


@implementation RFBatteryPowerPackage

@end
