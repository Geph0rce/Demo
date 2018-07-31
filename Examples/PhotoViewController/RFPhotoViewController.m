//
//  RFPhotoViewController.m
//  demo
//
//  Created by qianjie on 2018/7/31.
//  Copyright © 2018 Zen. All rights reserved.
//

#import "RFPhotoCollectionViewCell.h"
#import "RFPhotoViewController.h"

@interface RFPhotoViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray *urls;

@property (nonatomic, assign) CGFloat offsetXWhenBeginDragging;

@end

@implementation RFPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make_edges_equalTo(self.view);
    }];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.offsetXWhenBeginDragging = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat itemWidth = SCREEN_WIDTH + 30.0;
    NSInteger page = roundf(self.offsetXWhenBeginDragging / itemWidth);
    DLog(@"velocity: %@ offset: %@", NSStringFromCGPoint(velocity), NSStringFromCGPoint(scrollView.contentOffset));
    if (velocity.x > 0 && targetContentOffset->x > scrollView.contentOffset.x) {
        page++;
    } else if (velocity.x < 0 && targetContentOffset->x < scrollView.contentOffset.x) {
        page--;
    }
    
    page = MIN(MAX(0, page), (self.urls.count - 1));
    CGFloat targetOffsetX = MIN((page * itemWidth), (scrollView.contentSize.width - scrollView.width));
    targetContentOffset->x = MAX(targetOffsetX, 0);
}


#pragma mark - UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RFPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RFPhotoCollectionViewCell class]) forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.urls[indexPath.row]]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [_collectionView registerClass:[RFPhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([RFPhotoCollectionViewCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 30.0;
    }
    return _flowLayout;
}

- (NSArray *)urls {
    if (!_urls) {
        NSArray *urls = @[ @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=16e69d830f4f78f09f0b9cf349300a83/63d0f703918fa0ece5f167da2a9759ee3d6ddb37.jpg",
                           @"https://ss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=ff6ed7cfa718972bbc3a06cad6cc7b9d/267f9e2f07082838304837cfb499a9014d08f1a0.jpg",
                           @"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=65d890b39422720e64cee4fa4bca0a3a/4a36acaf2edda3cc10f68df10de93901203f92d4.jpg",
                           @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=e28f94a74fa98226a7c12d27ba83b97a/54fbb2fb43166d22460103464a2309f79152d2e9.jpg",
                           @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=82f1640b19ce36d3bd0485300af23a24/fcfaaf51f3deb48f5510390ffc1f3a292cf578e2.jpg",
                           @"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=01805b674b10b912a0c1f0fef3fcfcb5/42a98226cffc1e17461390ed4690f603728de9ba.jpg",
                           @"https://ss3.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a01da5ed77f40ad10ae4c1e3672d1151/d439b6003af33a87433692cfca5c10385243b588.jpg",
                           @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=c012e3ae9e58d109dbe3afb2e159ccd0/b7fd5266d0160924b65e22cbd80735fae7cd34e2.jpg"
                          
                          ];
        _urls = [urls copy];
    }
    return _urls;
}

@end
