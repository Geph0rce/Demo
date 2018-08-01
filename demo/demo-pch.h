//
//  demo-pch.h
//  demo
//
//  Created by qianjie on 2017/11/30.
//  Copyright © 2017年 Zen. All rights reserved.
//

#ifndef demo_pch_h
#define demo_pch_h

#ifdef __OBJC__

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import <RFFoundation/RFFoundation.h>
#import <YYModel/YYModel.h>
#import "RFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+RFCorner.h"
#import "UIView+RFLayout.h"
#import "UIView+Yoga.h"
#import "UIFont+RT.h"
#import "UIColor+RT.h"
#import "AIFMasonryMacro.h"
#import <RFTypeface/RFTypeface.h>
#import "RFBaseViewController.h"

#pragma mark - defines

#define kRGBA(r, g, b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kRGB(r, g, b) kRGBA(r, g, b, 1.0)

#endif

#endif /* demo_pch_h */
