//
//  RIFScreenShotActionView.m
//  demo
//
//  Created by qianjie on 2017/12/29.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import "UIView+RFCorner.h"
#import "UIView+RFLayout.h"
#import "RIFScreenShotActionView.h"

static NSTimeInterval const kRIFAutoDismissTimeInterval = 5.0;

@interface RIFScreenShotActionView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionViewController;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *shareImageButton;

@end

@implementation RIFScreenShotActionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoDismissTimeInterval = kRIFAutoDismissTimeInterval;
        [self addCorner:UIRectCornerAllCorners radius:3.0];
        self.backgroundColor = kRGBA(0, 0, 0, 0.8);
        [self addSubview:self.previewImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.dismissButton];
        [self addSubview:self.shareImageButton];
        
        [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.0);
            make.top.mas_equalTo(12.0);
            make.width.mas_equalTo(32.0);
            make.height.mas_equalTo(32.0);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.previewImageView.mas_right).offset(10.0);
            make.top.mas_equalTo(self.previewImageView.mas_top);
        }];
        
        [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12.0);
            make.right.mas_equalTo(-12.0);
        }];
        
        [self.shareImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16.0);
            make.top.mas_equalTo(self.previewImageView.mas_bottom).offset(8.0);
            make.width.mas_equalTo((SCREEN_WIDTH - 32.0 - 12.0)/2);
            make.height.mas_equalTo(44.0);
        }];
    }
    return self;
}

#pragma mark - Actions

- (void)shareImageAction {
    if (self.handleActions) {
        self.handleActions(RIFScreenShotActionTypeShareScreenShot, self.previewImage);
    }
}

- (void)showInView:(UIView *)view {
    [self showInView:view animated:YES];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    if (!self.superview) {
        [view addSubview:self];
    }
    if (animated) {
        self.bottom = 0;
        self.alpha = 0.6;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.top = self.animateToTop;
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self dismissAfter:self.autoDismissTimeInterval];
        }];
    } else {
        self.top = self.animateToTop;
        self.alpha = 1.0;
    }
}

- (void)dismissAfter:(NSTimeInterval)timeInterval {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)dismiss {
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.bottom = 0.0;
            self.alpha = 0.6;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (self.handleDismiss) {
                self.handleDismiss();
            }
        }];
    } else {
        [self removeFromSuperview];
        if (self.handleDismiss) {
            self.handleDismiss();
        }
    }
}



#pragma mark - Getters and Setters

- (UIImageView *)previewImageView {
    if (!_previewImageView) {
        _previewImageView = [[UIImageView alloc] init];
        _previewImageView.width = 32.0;
        _previewImageView.height = 32.0;
        [_previewImageView addCorner:UIRectCornerAllCorners radius:2.0];
    }
    return _previewImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"截图分享";
    }
    return _titleLabel;
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (UIButton *)shareImageButton {
    if (!_shareImageButton) {
        _shareImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareImageButton.backgroundColor = kRGB(232, 74, 1);
        _shareImageButton.width = (SCREEN_WIDTH - 32.0 - 12.0)/2;
        _shareImageButton.height = 44.0;
        [_shareImageButton addCorner:UIRectCornerAllCorners radius:2.0];
        _shareImageButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_shareImageButton setTitle:@"分享图片" forState:UIControlStateNormal];
        [_shareImageButton addTarget:self action:@selector(shareImageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareImageButton;
}

- (void)setPreviewImage:(UIImage *)previewImage {
    self.previewImageView.image = previewImage;
    _previewImage = previewImage;
}

@end
