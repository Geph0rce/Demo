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

@end

@implementation CRFTokenUtil

RFSingleton(CRFTokenUtil);

- (void)refreshToken:(RFNetworkCompleteBlock)complete {
    // request
    //        "clientInfo": {
    //            "androidID": "string",
    //            "appVersion": "string",
    //            "blackBox": "string",
    //            "clientId": "string",
    //            "deviceId": "string",
    //            "gps": "string",
    //            "idfa": "string",
    //            "imei": "string",
    //            "latitude": "string",
    //            "locationAddr": "string",
    //            "loginChannel": "string",
    //            "longitude": "string",
    //            "mac": "string",
    //            "model": "string",
    //            "os": "string",
    //            "vua": "string"
    //        },
    //        "refreshToken": "string"
    
    self.manager = [[RFNetworkManager alloc] init];
    [self.manager cancel:CRFNetworkingRefreshTokenURL];
    [self.manager post:CRFNetworkingRefreshTokenURL params:nil complete:^(id  _Nullable response, NSInteger statusCode, NSError * _Nullable error) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            self.model = [CRFTokenModel yy_modelWithDictionary:response];
        }
        if (complete) {
            complete(self.model, statusCode, error);
        }
    }];
}


@end
