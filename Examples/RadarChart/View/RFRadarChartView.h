//
//  RFRadarChartView.h
//  demo
//
//  Created by qianjie on 2018/4/2.
//  Copyright © 2018 Zen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFRadarChartView : UIView

@property (nonatomic, assign) NSInteger numberOfDemensions;
@property (nonatomic, strong) NSArray <UIColor *> *colors;
@property (nonatomic, assign) CGFloat rotateArc;

- (void)drawPolygonBackground;
- (void)reloadTitles:(NSArray <NSString *> *)titles;
- (void)reloadScores:(NSArray <NSNumber *> *)scores;

@end
