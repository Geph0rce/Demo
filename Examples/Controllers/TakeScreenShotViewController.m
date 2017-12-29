//
//  TakeScreenShotViewController.m
//  demo
//
//  Created by roger on 2017/12/29.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import "RIFScreenShotActionView.h"
#import "TakeScreenShotViewController.h"

static NSString *const kTakeScreenShotCellId = @"kTakeScreenShotCellId";

@interface TakeScreenShotViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *array;
@property (nonatomic, strong) RIFScreenShotActionView *screenShotActionView;
@property (nonatomic, strong) UIImageView *previewImageView;
@property (nonatomic, assign) CGRect originalFrame;

@end

@implementation TakeScreenShotViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeScreenShotAction:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [self.tableView reloadData];
    UIBarButtonItem *screenShotButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截屏" style:UIBarButtonItemStylePlain target:self action:@selector(takeScreenShot)];
    [self.navigationItem setRightBarButtonItem:screenShotButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.array[indexPath.row];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kTakeScreenShotCellId];
    cell.textLabel.text = text;
    return cell;
}

#pragma mark - Notifications and Actions

- (void)takeScreenShotAction:(NSNotification *)notification {
    
    if (self.screenShotActionView.superview) {
        [self.screenShotActionView dismiss];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *image = [self screenShotImage];
        self.screenShotActionView = [[RIFScreenShotActionView alloc] initWithFrame:CGRectMake(12.0, 0.0, SCREEN_WIDTH - 24.0, 100.0)];
        self.screenShotActionView.animateToTop = 46.0;
        self.screenShotActionView.previewImage = image;
        weakify(self)
        self.screenShotActionView.handleActions = ^(RIFScreenShotActionType actionType, UIImage * _Nullable image) {
            strongify(self);
            [self handleScreenShotActions:actionType image:image];
        };
        [self.screenShotActionView showInView:[UIApplication sharedApplication].keyWindow];
    });
}

- (void)dismissPreviewImageView {
    [UIView animateWithDuration:0.2 animations:^{
        self.previewImageView.frame = self.originalFrame;
    } completion:^(BOOL finished) {
        [self.previewImageView removeFromSuperview];
    }];
}

#pragma mark - Utils

- (UIImage *)screenShotImage {
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0.0);
    [[UIApplication sharedApplication].windows[0].layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

- (void)takeScreenShot {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)handleScreenShotActions:(RIFScreenShotActionType)actionType image:(UIImage *)image {
    if (actionType == RIFScreenShotActionTypeShareScreenShot && image) {
        self.originalFrame = [self.screenShotActionView.previewImageView convertRect:self.screenShotActionView.previewImageView.bounds toView:[UIApplication sharedApplication].keyWindow];
        self.previewImageView.frame = self.originalFrame;
        self.previewImageView.image = image;
        if (!self.previewImageView.superview) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.previewImageView];
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.previewImageView.width = 320.0;
            self.previewImageView.height = 320.0 * image.size.height/image.size.width;
            self.previewImageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        }];
    }
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTakeScreenShotCellId];
    }
    return _tableView;
}

- (NSArray<NSString *> *)array {
    if (!_array) {
        _array = @[
                   @"If you miss the train I'm on, ",
                   @"You will know that I am gone, ",
                   @"You can hear the whistle blow a hundred miles. ",
                   @"A hundred miles, a hundred miles, ",
                   @"A hundred miles, A hundred miles, ",
                   @"You can hear the whistle blow A hundred miles. ",
                   @"Lord, I'm one, Lord, I'm two, Lord, ",
                   @"I'm three, Lord, I'm four, Lord, ",
                   @"I'm five hundred miles away from home. ",
                   @"Away from home, away from home, ",
                   @"away from home, away from home, ",
                   @"Lord, I'm five hundred miles away from home ",
                   @"Not a shirt on my back, ",
                   @"Not a penny to my name. ",
                   @"Lord. I can't go back home this-a way. ",
                   @"This-a way, this-a way, ",
                   @"This-a way, this-a way, ",
                   @"Lord, I can't go back home this-a way. ",
                   @"If you miss the train I'm on, ",
                   @"You will know that I am gone, ",
                   @"You can hear the whistle blow A hundred miles. ",
                   @"A hundred miles. ",
                   @"A hundred miles. ",
                   @"A hundred miles. ",
                   @"A hundred miles. ",
                   @"You can hear the whistle blow a hundred miles ",
                   @"You can hear the whistle blow a hundred miles ",
                   @"You can hear the whistle blow a hundred miles "
                   ];
    }
    return [_array copy];
}

- (UIImageView *)previewImageView {
    if (!_previewImageView) {
        _previewImageView = [[UIImageView alloc] init];
        [_previewImageView addCorner:UIRectCornerAllCorners rect:CGRectMake(0, 0, 320.0, 320.0 * SCREEN_HEIGHT/SCREEN_WIDTH) radius:2.0];
        _previewImageView.layer.shadowColor = kRGBA(0, 0, 0, 0.54).CGColor;
        _previewImageView.layer.shadowOffset = CGSizeMake(-1.0, -1.0);
        _previewImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPreviewImageView)];
        [_previewImageView addGestureRecognizer:tap];
    }
    return _previewImageView;
}

@end
