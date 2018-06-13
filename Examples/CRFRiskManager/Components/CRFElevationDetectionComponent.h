//
//  CRFElevationDetectionComponent.h
//  demo
//
//  Created by qianjie on 2018/6/13.
//  Copyright © 2018 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFElevationDetectionComponent : NSObject


/**
 开始记录倾角数据

 @param updateTimeInterval 多久更新一次倾角
 */
- (void)start:(NSTimeInterval)updateTimeInterval;


/**
 停止记录倾角数据
 */
- (void)stop;


/**
 获取缓存的倾角数据

 @return 倾角数组
 */
- (NSArray <NSString *> *)fetchCache;


/**
 清除缓存的倾角数据
 */
- (void)clearCache;

@end
