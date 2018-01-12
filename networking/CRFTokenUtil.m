//
//  CRFTokenUtil.m
//  demo
//
//  Created by qianjie on 2017/12/27.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import "RFNetworking.h"
#import "CRFTokenUtil.h"

static NSString *const CRFNetworkingRefreshTokenURL = @"http://www.crf.com";

@interface CRFTokenUtil ()

@property (nonatomic, strong) RFNetworkManager *manager;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *operations;
@end

@implementation CRFTokenUtil

RFSingleton(CRFTokenUtil);


- (void)refreshToken:(RFNetworkCompleteBlock)complete {
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
    [self.manager cancel:CRFNetworkingRefreshTokenURL];
    [self.manager post:CRFNetworkingRefreshTokenURL params:refreshParams complete:^(id  _Nullable response, NSInteger statusCode, NSError * _Nullable error) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            self.model = [CRFTokenModel yy_modelWithDictionary:response];
        }
        
        for (RFNetworkCompleteBlock operation in self.operations) {
            operation(self.model, statusCode, error);
        }
        [self.operations removeAllObjects];
        self.isLoading = NO;
    }];
}

#pragma mark - Getters

- (NSMutableArray *)operations {
    if (!_operations) {
        _operations = [[NSMutableArray alloc] init];
    }
    return _operations;
}

@end
