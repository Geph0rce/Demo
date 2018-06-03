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

@end

@implementation RFRadarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ajkWhiteColor];
    [self.view addSubview:self.radarChartView];
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


@end
