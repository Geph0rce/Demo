//
//  RFTokenModel.h
//  demo
//
//  Created by qianjie on 2017/12/27.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RFTokenModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *ctUserId;
@property (nonatomic, copy) NSString *kissoId;
@property (nonatomic, copy) NSString *pageTag;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;

@end
NS_ASSUME_NONNULL_END

