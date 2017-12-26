//
//  UIView+RFCorner.m
//  demo
//
//  Created by qianjie on 2017/12/25.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import "UIView+RFLayout.h"
#import "UIView+RFCorner.h"

@implementation UIView (RFCorner)

- (void)addCorner:(UIRectCorner)corner radius:(CGFloat)radius {

    CGFloat width = self.width;
    CGFloat height = self.height;
    if (width > 0 && height > 0) {
        CGRect rect = CGRectMake(0, 0, width, height);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = rect;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}

@end
