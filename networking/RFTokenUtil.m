//
//  RFTokenUtil.m
//  demo
//
//  Created by qianjie on 2017/12/27.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import "RFNetworking.h"
#import "RFTokenUtil.h"

static NSString *const RFNetworkingRefreshTokenURL = @"http://www.crf.com";
static NSTimeInterval const RFNetworkingRefreshTokenDuration = 120.0;

@interface RFTokenUtil ()

@property (nonatomic, strong) RFNetworkManager *manager;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *operations;
@property (nonatomic, assign) NSTimeInterval timestamp;

@end

@implementation RFTokenUtil

RFSingleton(RFTokenUtil);


- (void)refreshToken:(RFNetworkCompleteBlock)complete {
    
    if (![self needToRefreshToken]) {
        if (complete) {
            complete(self.model, 200, nil);
        }
        return;
    }
    if (complete) {
        [self.operations addObject:complete];
    }
    if (self.isLoading) {
        return;
    }
    
    NSMutableDictionary *refreshParams = [[NSMutableDictionary alloc] init];
//    UserInfo *userInfo = [SettingData getCurrentAccountInfo];
//    ClientInfo *clientInfo = [SettingData getClientInfo];
//    NSDictionary *params = @{
//                             @"account" : NilSafe(userInfo.phone),
//                             @"refreshToken" : NilSafe(userInfo.refreshToken),
//                             @"accessToken" : NilSafe(userInfo.accessToken)
//                            };
//    
//    NSDictionary *clientInfo = @{
//                                 @"appVersion" : NilSafe(clientInfo.versionCode),
//                                 @"deviceId" : NilSafe(clientInfo.imei),
//                                 @"latitude" : [NSString stringWithFormat:@"%f",clientInfo.location.latitude],
//                                 @"longitude" : [NSString stringWithFormat:@"%f",clientInfo.location.longitude],
//                                 @"loginChannel" : @"crfapp",
//                                 @"vua" : @"user-agent",
//                                 @"mac" : NilSafe(clientInfo.mac),
//                                 @"model" : NilSafe(clientInfo.device),
//                                 @"androidID" : @"",
//                                 @"idfa" : NilSafe(clientInfo.idfa),
//                                 @"imei" : NilSafe(clientInfo.imei),
//                                 @"os" : NilSafe(clientInfo.os),
//                                 @"clientId" : NilSafe(clientInfo.clientId)
//                                 };
//    
//    [refreshParams addEntriesFromDictionary:params];
//    [refreshParams addEntriesFromDictionary:@{ @"clientInfo" : clientInfo}];
    self.isLoading = YES;
    
    self.manager = [[RFNetworkManager alloc] init];
    [self.manager cancel:RFNetworkingRefreshTokenURL];
    [self.manager post:RFNetworkingRefreshTokenURL params:refreshParams complete:^(id  _Nullable response, NSInteger statusCode, NSError * _Nullable error) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            self.model = [RFTokenModel yy_modelWithDictionary:response];
        }
        
        for (RFNetworkCompleteBlock operation in self.operations) {
            operation(self.model, statusCode, error);
        }
        [self.operations removeAllObjects];
        self.timestamp = [[NSDate date] timeIntervalSince1970];
        self.isLoading = NO;
    }];
}

- (BOOL)needToRefreshToken {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    if (timeInterval - self.timestamp > RFNetworkingRefreshTokenDuration) {
        return YES;
    }
    return NO;
}

#pragma mark - Getters

- (NSMutableArray *)operations {
    if (!_operations) {
        _operations = [[NSMutableArray alloc] init];
    }
    return _operations;
}


@end
