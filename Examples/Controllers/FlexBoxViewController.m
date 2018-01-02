//
//  FlexBoxViewController.m
//  demo
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 Zen. All rights reserved.
//

#import "FlexBoxViewController.h"

@interface FlexBoxViewController ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation FlexBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:contentView];
    [contentView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionColumn;
        layout.alignItems = YGAlignCenter;
        layout.justifyContent = YGJustifySpaceAround;
        layout.width = YGPointValue(self.view.width);
        layout.height = YGPointValue(200.0);
        layout.marginTop = YGPointValue(20.0);
    }];

    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor grayColor];
    [redView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(50.0);
        layout.height = YGPointValue(50.0);
    }];
    [contentView addSubview:redView];
    
    UIView *orengeView = [[UIView alloc] init];
    orengeView.backgroundColor = kRGB(232, 74, 1);
    [orengeView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(60.0);
        layout.height = YGPointValue(60.0);
    }];
    [contentView addSubview:orengeView];
    self.contentView = contentView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.contentView.yoga applyLayoutPreservingOrigin:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
