//
//  RIFScreenShotActionView.h
//  demo
//
//  Created by qianjie on 2017/12/29.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, RIFScreenShotActionType) {
    RIFScreenShotActionTypeClose = 0,
    RIFScreenShotActionTypeShareScreenShot,
    RIFScreenShotActionTypeSharePage
};

typedef void (^RFScreenShotActionsBlock)(RIFScreenShotActionType actionType, UIImage * _Nullable image);
typedef void (^RIFScreenShotActionDismissBlock)(void);

@interface RIFScreenShotActionView : UIView

@property (nonatomic, assign) CGFloat animateToTop;
@property (nonatomic, strong) UIImageView *previewImageView;
@property (nullable, nonatomic, strong) UIImage *previewImage;
@property (nullable, nonatomic, copy) RFScreenShotActionsBlock handleActions;
@property (nullable, nonatomic, copy) RIFScreenShotActionDismissBlock handleDismiss;
@property (nonatomic, assign) NSTimeInterval autoDismissTimeInterval;

- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view animated:(BOOL)animated;

- (void)dismiss;
- (void)dismiss:(BOOL)animated;

@end
NS_ASSUME_NONNULL_END
