//
//  RFBluetoothPeripheralRow.m
//  demo
//
//  Created by qianjie on 2019/8/28.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothPeripheralRow.h"

@interface RFBluetoothPeripheralRowCell : RFTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation RFBluetoothPeripheralRowCell

- (void)cellDidCreate {
    [super cellDidCreate];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor ajkWhiteColor];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make_left_equalTo(20.0);
        make_right_equalTo(-20.0);
        make_centerY_equalTo(self.contentView);
    }];
}

#pragma mark - Getters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [ UIFont ajkH5Font];
        _titleLabel.textColor = [UIColor ajkDarkBlackColor];
    }
    return _titleLabel;
}

@end

@implementation RFBluetoothPeripheralRow

- (void)updateCell:(RFBluetoothPeripheralRowCell *)cell indexPath:(NSIndexPath *)indexPath {
    [super updateCell:cell indexPath:indexPath];
    cell.titleLabel.text = self.title;
}

- (CGFloat)cellHeight {
    return 50.0;
}

@end
