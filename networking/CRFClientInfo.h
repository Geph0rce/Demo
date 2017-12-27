//
//  CRFClientInfo.h
//  demo
//
//  Created by qianjie on 2017/12/27.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import <YYModel/YYModel.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface CRFClientInfo : NSObject <YYModel>

@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *blackBox;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *gps;
@property (nonatomic, copy) NSString *idfa;
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *locationAddr;
@property (nonatomic, copy) NSString *loginChannel;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *os;
@property (nonatomic, copy) NSString *vua;

@end
NS_ASSUME_NONNULL_END
