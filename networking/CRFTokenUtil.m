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

@end

@implementation CRFTokenUtil

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
    
    // response
    //    {
    //        "accessToken": "string",
    //        "ctUserId": "string",
    //        "kissoId": "string",
    //        "pageTag": "string",
    //        "refreshToken": "string",
    //        "status": 0,
    //        "type": 0
    //    }
    RFNetworkManager *manager = [[RFNetworkManager alloc] init];
    [manager cancel:CRFNetworkingRefreshTokenURL];
    [manager post:CRFNetworkingRefreshTokenURL params:nil complete:^(id  _Nullable response, NSInteger statusCode, NSError * _Nullable error) {
        //TODO: handle token response, refresh local token
        if (complete) {
            complete(response, statusCode, error);
        }
    }];
}


@end
