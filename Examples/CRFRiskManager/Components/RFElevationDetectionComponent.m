//
//  RFElevationDetectionComponent.m
//  demo
//
//  Created by qianjie on 2018/6/13.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "RFElevationDetectionComponent.h"
#import <CoreMotion/CoreMotion.h>

@interface RFElevationDetectionComponent ()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, copy) dispatch_queue_t cacheQueue;

@property (nonatomic, assign) double zTheta;
@property (nonatomic, assign) double xyTheta;

@property (nonatomic, strong) NSMutableArray <NSString *> *zThetaArray;

@end

@implementation RFElevationDetectionComponent

- (void)start:(NSTimeInterval)updateTimeInterval {
    if (self.motionManager.accelerometerAvailable) {
        self.motionManager.accelerometerUpdateInterval = (updateTimeInterval > 0 ? updateTimeInterval : 1.0);
        
        [self.motionManager startAccelerometerUpdatesToQueue:self.queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (error) {
                [self.motionManager stopAccelerometerUpdates];
                return;
            }
            self.zTheta = atan2(accelerometerData.acceleration.z, sqrtf(accelerometerData.acceleration.x * accelerometerData.acceleration.x+accelerometerData.acceleration.y * accelerometerData.acceleration.y)) / M_PI * (-90.0) * 2 - 90.0;
            self.xyTheta = atan2(accelerometerData.acceleration.x, accelerometerData.acceleration.y) / M_PI * 180.0;
            [self addCache:self.zTheta];
        }];
    }
}

- (void)stop {
    [self.motionManager stopAccelerometerUpdates];
}

#pragma mark - Cache

- (NSArray <NSString *> *)fetchCache {
    return [self.zThetaArray copy];
}

- (void)clearCache {
    dispatch_async(self.cacheQueue, ^{
        [self.zThetaArray removeAllObjects];
    });
}

- (void)addCache:(double)zTheta {
    dispatch_async(self.cacheQueue, ^{
        [self.zThetaArray addObject:[NSString stringWithFormat:@"%@", @(zTheta)]];
    });
}

#pragma mark - Getters

- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}


- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}
    
- (dispatch_queue_t)cacheQueue {
    if (!_cacheQueue) {
        _cacheQueue = dispatch_queue_create("risk.manage.crf", DISPATCH_QUEUE_SERIAL);
    }
    return _cacheQueue;
}

- (NSMutableArray<NSString *> *)zThetaArray {
    if (!_zThetaArray) {
        _zThetaArray = [[NSMutableArray alloc] init];
    }
    return _zThetaArray;
}

@end
