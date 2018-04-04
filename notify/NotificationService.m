//
//  NotificationService.m
//  notify
//
//  Created by qianjie on 2018/2/26.
//  Copyright © 2018年 Zen. All rights reserved.
//

#import "NotificationService.h"
#import <CoreLocation/CoreLocation.h>

@interface NotificationService () <CLLocationManagerDelegate>

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    [self.manager requestAlwaysAuthorization];
    [self.manager startUpdatingLocation];
}


- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
   // self.contentHandler(self.bestAttemptContent);
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSMutableString *coordinate = [NSMutableString string];
    for (CLLocation *location in locations) {
        [coordinate appendFormat:@"lng: %@ lat: %@", @(location.coordinate.longitude), @(location.coordinate.latitude)];
    }
    NSString *url = [NSString stringWithFormat:@"https://www.baidu.com/location/coordinate=%@", coordinate];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            
        }
    }];
    [task resume];
    self.bestAttemptContent.title = coordinate;
    self.contentHandler(self.bestAttemptContent);
}


#pragma mark - Getters

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.allowsBackgroundLocationUpdates = YES;
        _manager.pausesLocationUpdatesAutomatically = NO;
        _manager.distanceFilter = kCLDistanceFilterNone;
    }
    return _manager;
}

@end
