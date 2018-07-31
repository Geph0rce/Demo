//
//  RFPhotoCollectionViewCell.m
//  demo
//
//  Created by qianjie on 2018/7/31.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "RFPhotoCollectionViewCell.h"

@implementation RFPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self.contentView);
            make_right_equalTo(self.contentView);
        }];
    }
    return self;
}


#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UIScrollView *)zoomScrollView {
    if (!_zoomScrollView) {
        _zoomScrollView = [[UIScrollView alloc] init];
        _zoomScrollView.maximumZoomScale = 2.0;
    }
    return _zoomScrollView;
}

@end
