//
//  TakeScreenShotViewController.m
//  demo
//
//  Created by roger on 2017/12/29.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import "TakeScreenShotViewController.h"

static NSString *const kTakeScreenShotCellId = @"kTakeScreenShotCellId";

@interface TakeScreenShotViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *array;

@end

@implementation TakeScreenShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeScreenShotAction:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [self.tableView reloadData];
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
    
}


#pragma mark - Utils

- (UIImage *)screenShotImage {
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    [[UIApplication sharedApplication].windows[0].layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

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

@end
