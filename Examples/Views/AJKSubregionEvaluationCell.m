//
//  AJKSubregionEvaluationCell.m
//  demo
//
//  Created by qianjie on 2018/1/22.
//  Copyright © 2018年 Zen. All rights reserved.
//

#import "AJKSubregionEvaluationCell.h"

@interface AJKSubregionEvaluationCell ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *seperatorLineView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation AJKSubregionEvaluationCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    
        [self.contentView addSubview:self.titleView];
        [self.titleView addSubview:self.titleLabel];
        [self.titleView addSubview:self.arrowImageView];
        [self.titleView addSubview:self.seperatorLineView];
        [self.contentView addSubview:self.contentLabel];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 3.0;
        self.contentView.layer.masksToBounds = YES;
        self.layer.shadowColor = [UIColor ajkLineColor].CGColor;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.layer.shadowRadius = 3.0;
        
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.contentView);
            make_height_equalTo(56.0);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make_left_equalTo(15.0);
            make_centerY_equalTo(self.titleView);
        }];
        
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make_right_equalTo(-15.0);
            make_centerY_equalTo(self.titleView);
        }];
        
        [self.seperatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make_left_equalTo(15.0);
            make_right_equalTo(-15.0);
            make_height_equalTo(ONE_PIXEL);
            make_bottom_equalTo(self.titleView);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make_top_equalTo(self.titleView.mas_bottom).offset(15.0);
            make_left_equalTo(15.0);
            make_bottom_equalTo(-15.0);
            make_right_equalTo(-15.0);
        }];
    }
    return self;
}

- (void)reloadData:(NSString *)content {
    self.contentLabel.text = content;
}

#pragma mark - Getters

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 3.0;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.layer.shadowColor = [UIColor ajkBlackColor].CGColor;
        _shadowView.layer.shadowOpacity = 1.0;
        _shadowView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        _shadowView.layer.shadowRadius = 3.0;
    }
    return _shadowView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont ajkH3Font];
        _titleLabel.textColor = [UIColor ajkBlackColor];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    }
    return _arrowImageView;
}

- (UIView *)seperatorLineView {
    if (!_seperatorLineView) {
        _seperatorLineView = [[UIView alloc] init];
        _seperatorLineView.backgroundColor = [UIColor ajkLineNavColor];
    }
    return _seperatorLineView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont ajkH3Font];
        _contentLabel.textColor = [UIColor ajkDarkGrayColor];
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.numberOfLines = 4;
    }
    return _contentLabel;
}

@end
