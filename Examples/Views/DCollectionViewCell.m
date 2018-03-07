//
//  DCollectionViewCell.m
//  demo
//
//  Created by Roger on 07/03/2018.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "DCollectionViewCell.h"

@implementation DCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Getters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.preferredMaxLayoutWidth = 290.0;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end
