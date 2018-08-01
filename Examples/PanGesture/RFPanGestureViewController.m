//
//  RFPanGestureViewController.m
//  demo
//
//  Created by qianjie on 2018/7/26.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "RFPanGestureViewController.h"

@interface RFPanGestureViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *panGestureView;

@end

@implementation RFPanGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.panGestureView];
    [self.panGestureView addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.contentLabel];
    
    [self.panGestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make_top_equalTo(self.view.mas_bottom).offset(-160);
        make.left.right.mas_equalTo(self.view);
        make_height_equalTo(self.view);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make_edges_equalTo(self.panGestureView);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make_edges_equalTo(self.scrollView);
        make_width_equalTo(self.scrollView);
        make_height_equalTo(self.scrollView).multipliedBy(1.1);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make_left_equalTo(15.0);
        make_right_equalTo(-15.0);
        make_top_equalTo(20.0);
    }];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGesture.delegate = self;
    [self.panGestureView addGestureRecognizer:panGesture];
    
    UIPanGestureRecognizer *panScrollGesture = [[UIPanGestureRecognizer alloc] init];
    panScrollGesture.delegate = self;
    [self.scrollView addGestureRecognizer:panScrollGesture];
    
    self.contentLabel.attributedText = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer.view isEqual:self.panGestureView] && self.panGestureView.top > 100.0) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        return YES;
    } else if ([gestureRecognizer.view isEqual:self.scrollView]) {
        return NO;
    }
    else {
        self.scrollView.scrollEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = YES;
        return NO;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.view isEqual:self.panGestureView]) {
        CGPoint point = [gestureRecognizer translationInView:self.view];
        self.panGestureView.top = self.panGestureView.top + point.y;
        [gestureRecognizer setTranslation:CGPointMake(0.0, 0.0) inView:self.view];
        if (self.panGestureView.top <= 100.0) {
            self.scrollView.scrollEnabled = YES;
            self.scrollView.showsVerticalScrollIndicator = YES;
        }
    }
}


- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Getters

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30.0;
        NSString *oldMan = @"Old man look at my life,I'm a lot like you were.Old man look at my life,I'm a lot like you were.Old man look at my life,Twenty four and there's so much moreLive alone in a paradiseThat makes me think of two.Love lost, such a cost,Give me things that don't get lost.Like a coin that won't get tossedRolling home to you.Old man take a look at my life I'm a lot like youI need someone to love me the whole day throughAh, one look in my eyes and you can tell that's true.Lullabies, look in your eyes,Run around the same old town.Doesn't mean that much to meTo mean that much to you.I've been first and lastLook at how the time goes past.But I'm all alone at last.Rolling home to you.";
        _contentLabel.attributedText = oldMan.typeface.font([UIFont systemFontOfSize:16.0]).lineHeight(22.0).compose;
    }
    return _contentLabel;
}

- (UIView *)panGestureView {
    if (!_panGestureView) {
        _panGestureView = [[UIView alloc] init];
        _panGestureView.backgroundColor = [UIColor ajkBgTagBlueColor];
    }
    return _panGestureView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

@end
