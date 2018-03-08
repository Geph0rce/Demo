//
//  AJKPeopleTagCell.m
//  demo
//
//  Created by qianjie on 2018/1/22.
//  Copyright © 2018年 Zen. All rights reserved.
//

#import "AJKPeopleTagCell.h"

@interface AJKPeopleTagCell ()

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation AJKPeopleTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.circleView];
        [self.contentView addSubview:self.tagLabel];
        
        [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make_edges_equalTo(self.contentView);
        }];
        
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make_center_equalTo(self.contentView);
            make_width_equalTo(38.0);
            make_height_equalTo(32.0);
        }];
    }
    return self;
}

- (void)reloadData:(NSString *)tag {
    self.tagLabel.text = tag;
}

#pragma mark - Getters

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] init];
        _circleView.backgroundColor = [UIColor ajkBackgroundPageColor];
        _circleView.layer.cornerRadius = 55.0/2;
        _circleView.layer.masksToBounds = YES;
    }
    return _circleView;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont ajkH5Font];
        _tagLabel.textColor = [UIColor ajkBlackColor];
        _tagLabel.numberOfLines = 2;
        _tagLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _tagLabel.preferredMaxLayoutWidth = 38.0;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

@end
