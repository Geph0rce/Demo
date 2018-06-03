//
//  RFRadarChartView.m
//  demo
//
//  Created by qianjie on 2018/4/2.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "RFRadarChartView.h"

static CGFloat const kRFRadarChartViewRadius = 30.0;
static NSInteger const kRFRadarChartLevels = 4;
static NSInteger const kRFRadarChartDefaultDemensions = 5;

typedef NS_ENUM(NSInteger, RFRadarChartViewAlignment) {
    RFRadarChartViewAlignmentTop = 0,
    RFRadarChartViewAlignmentLeft,
    RFRadarChartViewAlignmentBottom,
    RFRadarChartViewAlignmentRight
};

@interface RFRadarChartView ()

@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, strong) CAShapeLayer *scoreLayer;
@property (nonatomic, strong) NSMutableArray *titleLabels;

@end

@implementation RFRadarChartView


- (void)drawPolygonBackground {
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    for (NSInteger i = 0; i < kRFRadarChartLevels; i++) {
        CGFloat radius = kRFRadarChartViewRadius * (kRFRadarChartLevels - i);
        UIColor *color = self.colors[i];
        [self drawPolygon:center radius:radius color:color];
    }
    
    for (NSInteger i = 0; i < self.numberOfDemensions; i++) {
        NSArray *points = [self pointsToCennectAtIndex:i];
        [self drawLine:points];
    }
}

- (void)reloadTitles:(NSArray <NSString *> *)titles {
    if (titles.count != self.numberOfDemensions) {
        NSLog(@"titles.count = %@, and numberOfDemensions = %@", @(titles.count), @(self.numberOfDemensions));
        return;
    }
    
    for (UILabel *label in self.titleLabels) {
        [label removeFromSuperview];
    }
    [self.titleLabels removeAllObjects];
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    CGFloat radius = kRFRadarChartViewRadius * kRFRadarChartLevels;
    NSArray *points = [self points:center radius:radius];
    for (int i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont ajkH3Font];
        label.textColor = [UIColor ajkBlackColor];
        label.text = titles[i];
        [label sizeToFit];
        [self addSubview:label];
        CGPoint point = [points[i] CGPointValue];

        // position of label
        CGFloat dx = fabs(point.x - center.x);
        CGFloat dy = fabs(point.y - center.y);
        BOOL isVertical = (dy - dx >= radius/3.0);
        if (point.x > center.x && point.y < center.y) {
            // 第一象限
            if (isVertical) {
                [self align:label point:point aligment:RFRadarChartViewAlignmentBottom];
            } else {
                [self align:label point:point aligment:RFRadarChartViewAlignmentLeft];
            }
        } else if (point.x < center.x && point.y < center.y) {
            // 第二象限
            if (isVertical) {
                [self align:label point:point aligment:RFRadarChartViewAlignmentBottom];
            } else {
                [self align:label point:point aligment:RFRadarChartViewAlignmentRight];
            }
        } else if (point.x < center.x && point.y > center.y) {
            // 第三象限
            if (isVertical) {
                [self align:label point:point aligment:RFRadarChartViewAlignmentTop];
            } else {
                [self align:label point:point aligment:RFRadarChartViewAlignmentRight];
            }
        } else if (point.x > center.x && point.y > center.y) {
            // 第四象限
            if (isVertical) {
                [self align:label point:point aligment:RFRadarChartViewAlignmentTop];
            } else {
                [self align:label point:point aligment:RFRadarChartViewAlignmentLeft];
            }
        }
    }
}

- (void)reloadScores:(NSArray<NSNumber *> *)scores {
    if (scores.count != self.numberOfDemensions) {
        NSLog(@"scores.count = %@, and numberOfDemensions = %@", @(scores.count), @(self.numberOfDemensions));
        return;
    }
    
    if (self.scoreLayer) {
        [self.scoreLayer removeFromSuperlayer];
        self.scoreLayer = nil;
    }
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    for (int i = 0; i < self.numberOfDemensions; i++) {
        CGFloat score = [scores[i] floatValue];
        NSInteger n = i + 1;
        CGFloat alpha = 2 * M_PI / self.numberOfDemensions;
        CGFloat radius = roundf(score * kRFRadarChartViewRadius * kRFRadarChartLevels);
        CGFloat x = center.x + radius * cos(alpha * n - self.rotateArc);
        CGFloat y = center.y + radius * sin(alpha * n - self.rotateArc);
        if (i == 0) {
            [path moveToPoint:CGPointMake(x, y)];
        } else {
            [path addLineToPoint:CGPointMake(x, y)];
        }
    }
    [path closePath];
    
    NSArray *points = [self points:center radius:0.0];
    UIBezierPath *bezierPath = [self bezierPathWithPoints:points];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)bezierPath.CGPath;
    pathAnimation.toValue = (id)path.CGPath;
    pathAnimation.duration = 0.75;
    pathAnimation.autoreverses = NO;
    pathAnimation.repeatCount = 0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    self.scoreLayer = [[CAShapeLayer alloc] init];
    self.scoreLayer.fillColor = [[UIColor ajkBrandGreenColor] colorWithAlphaComponent:0.6].CGColor;
    [self.scoreLayer addAnimation:pathAnimation forKey:@"scale"];
    self.scoreLayer.path = path.CGPath;
    [self.layer addSublayer:self.scoreLayer];
}

- (void)drawPolygon:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color {
    NSArray *points = [self points:center radius:radius];
    [self.pointsArray addObject:points];
    UIBezierPath *path = [self bezierPathWithPoints:points];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
}

- (void)drawLine:(NSArray *)points {
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:center];
    for (int i = 0; i < points.count; i++) {
        NSValue *value = points[points.count - i - 1];
        CGPoint point = [value CGPointValue];
        [path addLineToPoint:point];
    }
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.strokeColor = [UIColor colorWithHex:0xDFF0DF alpha:1.0].CGColor;
    lineLayer.path = path.CGPath;
    [self.layer addSublayer:lineLayer];
}

- (NSArray *)points:(CGPoint)center radius:(CGFloat)radius {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.numberOfDemensions; i++) {
        NSInteger n = i + 1;
        CGFloat alpha = 2 * M_PI / self.numberOfDemensions;
        CGFloat x = center.x + radius * cos(alpha * n - self.rotateArc);
        CGFloat y = center.y + radius * sin(alpha * n - self.rotateArc);
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    return points;
}

- (UIBezierPath *)bezierPathWithPoints:(NSArray <NSValue *> *)points {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    for (NSInteger i = 0; i < points.count; i++) {
        CGPoint point = [points[i] CGPointValue];
        if (i == 0) {
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }
    [path closePath];
    return  path;
}

- (NSArray *)pointsToCennectAtIndex:(NSInteger)index {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.pointsArray.count; i++) {
        NSArray *pointsArray = self.pointsArray[i];
        [points addObject:pointsArray[index]];
    }
    return points;
}

#pragma mark - align label

- (void)align:(UILabel *)label point:(CGPoint)point aligment:(RFRadarChartViewAlignment)alignment {
    CGFloat margin = 6.0;
    if (alignment == RFRadarChartViewAlignmentLeft) {
        label.left = point.x + margin;
        label.top = point.y - label.height/2.0;
    } else if (alignment == RFRadarChartViewAlignmentBottom) {
        label.left = point.x - label.width/2.0;
        label.bottom = point.y - margin;
    } else if (alignment == RFRadarChartViewAlignmentRight) {
        label.right = point.x - margin;
        label.top = point.y - label.height/2.0;
    } else if (alignment == RFRadarChartViewAlignmentTop) {
        label.top = point.y + margin;
        label.left = point.x - label.width/2.0;
    }
}


#pragma mark - Getters and Setters


- (NSArray<UIColor *> *)colors {
    if (!_colors) {
        UIColor *color = [UIColor ajkBrandGreenColor];
        _colors = @[
                    [color colorWithAlphaComponent:0.1],
                    [color colorWithAlphaComponent:0.15],
                    [color colorWithAlphaComponent:0.2],
                    [color colorWithAlphaComponent:0.3]
                    ];
    }
    return _colors;
}

- (NSInteger)numberOfDemensions {
    return  _numberOfDemensions ?: kRFRadarChartDefaultDemensions;
}

- (NSMutableArray *)pointsArray {
    if (!_pointsArray) {
        _pointsArray = [[NSMutableArray alloc] init];
    }
    return _pointsArray;
}

- (NSMutableArray *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [[NSMutableArray alloc] init];
    }
    return _titleLabels;
}

@end
