//
//  RFTokenUtil.h
//  demo
//
//  Created by qianjie on 2017/12/27.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFTokenModel.h"

@interface RFTokenUtil : NSObject

@property (nonatomic, strong) RFTokenModel *model;

+ (instancetype)sharedInstance;

/**
 refresh token

 @param complete, handle token in the block
 */
- (void)refreshToken:(RFNetworkCompleteBlock)complete;

@end
