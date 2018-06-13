//
//  CRFRiskManager.m
//  demo
//
//  Created by qianjie on 2018/6/13.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "RFNetworking.h"
#import "CRFElevationDetectionComponent.h"
#import "CRFRiskManager.h"

static NSTimeInterval const kCRFElevationDetectionTimeInterval = 1.0;
static NSTimeInterval const kCRFRiskManagerUploadTimeInterval = 15.0;

@interface CRFRiskManager ()

@property (nonatomic, strong) CRFElevationDetectionComponent *elevationComponent;
@property (nonatomic, strong) NSTimer *uploadTimer;
@property (nonatomic, strong) RFNetworkManager *networkManager;

@end

@implementation CRFRiskManager

RFSingleton(CRFRiskManager)

+ (void)load {
    [CRFRiskManager sharedInstance];
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
        [self.elevationComponent start:kCRFElevationDetectionTimeInterval];
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
    __weak CRFRiskManager *weakSelf = self;
    self.uploadTimer = [NSTimer scheduledTimerWithTimeInterval:kCRFRiskManagerUploadTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
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
    [self.elevationComponent start:kCRFElevationDetectionTimeInterval];
    [self startTimer];
}

#pragma mark - Getters

- (CRFElevationDetectionComponent *)elevationComponent {
    if (!_elevationComponent) {
        _elevationComponent = [[CRFElevationDetectionComponent alloc] init];
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
