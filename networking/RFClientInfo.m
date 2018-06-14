//
//  RFClientInfo.m
//  demo
//
//  Created by qianjie on 2017/12/27.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CoreLocation/CoreLocation.h>
#import <AdSupport/AdSupport.h>
#import "RFClientInfo.h"
#import "RFNetworkingMacros.h"

static NSString *const kRFClientInfoPersistenceKey = @"RFClientInfoPersistenceKey";

@implementation RFClientInfo

RFSingleton(RFClientInfo);

- (instancetype)init {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *clientInfoDict = [ud objectForKey:kRFClientInfoPersistenceKey];
    if (clientInfoDict) {
        self = [RFClientInfo yy_modelWithDictionary:clientInfoDict];
    } else {
        self = [super init];
        [self initClientInfo];
    }
    return self;
}

- (void)initClientInfo {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    UIDevice *device = [UIDevice currentDevice];
    self.appVersion = infoDictionary[@"CFBundleVersion"];
    self.idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    self.imei = device.identifierForVendor.UUIDString;
    self.model = device.model;
    self.os = device.systemVersion;
}

#pragma mark - utils

- (NSString *)ipAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}



@end
