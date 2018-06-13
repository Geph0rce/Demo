//
//  RFRadarChartViewController.m
//  demo
//
//  Created by qianjie on 2018/4/2.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "RFRadarChartView.h"
#import "RFRadarChartViewController.h"

@interface RFRadarChartViewController ()

@property (nonatomic, strong) RFRadarChartView *radarChartView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation RFRadarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ajkWhiteColor];
    [self.view addSubview:self.radarChartView];
    [self.view addSubview:self.imageView];
    [self.radarChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make_left_equalTo(self.view);
        make_right_equalTo(self.view);
        make_top_equalTo(100.0);
        make_height_equalTo(200.0);
    }];
    [self.radarChartView reloadTitles:@[
                                        @"医疗",
                                        @"商业",
                                        @"生活",
                                        @"交通",
                                        @"教育"
                                        ]];
    [self.radarChartView reloadScores:@[
                                        @(0.5),
                                        @(0.75),
                                        @(0.25),
                                        @(0.35),
                                        @(0.8)
                                        ]];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make_top_equalTo(self.radarChartView.mas_bottom).offset(60.0);
        make_centerX_equalTo(self.view);
        make_width_equalTo(200.0);
        make_height_equalTo(60.0);
    }];
    
    self.imageView.image = [[UIImage imageNamed:@"esf_propdetail_popover"] resizableImageWithCapInsets:UIEdgeInsetsMake(8.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeStretch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (RFRadarChartView *)radarChartView {
    if (!_radarChartView) {
        _radarChartView = [[RFRadarChartView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 200.0)];
        _radarChartView.rotateArc = M_PI_4;
        [_radarChartView drawPolygonBackground];
    }
    return _radarChartView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
