//
//  RFRiskManager.m
//  demo
//
//  Created by qianjie on 2018/6/13.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "RFNetworking.h"
#import "RFElevationDetectionComponent.h"
#import "RFRiskManager.h"

static NSTimeInterval const kRFElevationDetectionTimeInterval = 1.0;
static NSTimeInterval const kRFRiskManagerUploadTimeInterval = 15.0;

@interface RFRiskManager ()

@property (nonatomic, strong) RFElevationDetectionComponent *elevationComponent;
@property (nonatomic, strong) NSTimer *uploadTimer;
@property (nonatomic, strong) RFNetworkManager *networkManager;

@end

@implementation RFRiskManager

RFSingleton(RFRiskManager)

+ (void)load {
    [RFRiskManager sharedInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [self.elevationComponent start:kRFElevationDetectionTimeInterval];
        [self startTimer];
    }
    return self;
}


#pragma mark - Upload Stuff

- (void)upload {
    NSArray *cache = [self.elevationComponent fetchCache];
    if (cache.count > 0) {
        NSDictionary *params = @{ @"params" : cache };
        [self.networkManager post:@"http://www.baidu.com" params:params complete:^(__kindof NSObject * _Nullable response, NSInteger statusCode, NSError * _Nullable error) {
        }];
        [self.elevationComponent clearCache];
    }
}

#pragma mark - Timer

- (void)startTimer {
    [self stopTimerIfNeeded];
    __weak RFRiskManager *weakSelf = self;
    self.uploadTimer = [NSTimer scheduledTimerWithTimeInterval:kRFRiskManagerUploadTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf upload];
    }];
}

- (void)stopTimerIfNeeded {
    if (self.uploadTimer) {
        [self.uploadTimer invalidate];
        self.uploadTimer = nil;
    }
}

#pragma mark - Notifications

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self.elevationComponent stop];
    [self stopTimerIfNeeded];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    [self.elevationComponent start:kRFElevationDetectionTimeInterval];
    [self startTimer];
}

#pragma mark - Getters

- (RFElevationDetectionComponent *)elevationComponent {
    if (!_elevationComponent) {
        _elevationComponent = [[RFElevationDetectionComponent alloc] init];
    }
    return _elevationComponent;
}

- (RFNetworkManager *)networkManager {
    if (!_networkManager) {
        _networkManager = [[RFNetworkManager alloc] init];
    }
    return _networkManager;
}

@end
