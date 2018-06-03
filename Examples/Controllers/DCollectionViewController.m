//
//  DCollectionViewController.m
//  demo
//
//  Created by Roger on 07/03/2018.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "DemoHitTestView.h"
#import "DCollectionViewCell.h"
#import "DCollectionViewController.h"

static NSString *const kDCollectionViewCellId = @"DCollectionViewCellId";
static float const factor = 0.773;

@interface DCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) DemoHitTestView *hitTestView;
@property (nonatomic, strong) NSArray <NSString *> *array;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ajkWhiteColor];
    [self.view addSubview:self.hitTestView];
    [self.hitTestView addSubview:self.collectionView];
    
    [self.hitTestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make_top_equalTo(100.0);
        make_height_equalTo(182.0);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make_left_equalTo(self.hitTestView);
        make_top_equalTo(self.hitTestView);
        make_height_equalTo(self.hitTestView);
        make_width_equalTo(290.0);
    }];
    
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSInteger targetIndex = roundf(targetContentOffset->x / 300.0);
//    NSInteger currentIndex = roundf(scrollView.contentOffset.x / 300.0);
//
//    targetContentOffset->x = targetIndex * 300.0;
//}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDCollectionViewCellId forIndexPath:indexPath];
    NSString *title = self.array[indexPath.row];
    cell.titleLabel.text = title;
    return cell;
}

#pragma mark - Getters

- (DemoHitTestView *)hitTestView {
    if (!_hitTestView) {
        _hitTestView = [[DemoHitTestView alloc] init];
        _hitTestView.viewToHitTest = self.collectionView;
    }
    return _hitTestView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(290.0, 180.0);
        layout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 200) collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [_collectionView registerClass:[DCollectionViewCell class] forCellWithReuseIdentifier:kDCollectionViewCellId];
    }
    return _collectionView;
}

- (NSArray<NSString *> *)array {
    if (!_array) {
        _array = @[@"香烟请再为我点一颗", @"火车上的情侣也不多", @"你推荐的歌我都听过", @"听过后和你一样寂寞", @"抹不去我多情的思绪"];
    }
    return _array;
}

@end
