//
//  CollectionViewExampleViewController.m
//  demo
//
//  Created by qianjie on 2018/1/22.
//  Copyright © 2018年 Zen. All rights reserved.
//

#import "AJKPeopleTagCell.h"
#import "AJKSubregionEvaluationCell.h"
#import "CollectionViewExampleViewController.h"

@interface CollectionViewExampleViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *tagsTitleLabel;
@property (nonatomic, strong) UICollectionView *tagsCollectionView;
@property (nonatomic, strong) UICollectionView *evaluationCollectionView;
@property (nonatomic, strong) UILabel *evaluationTitleLabel;
@property (nonatomic, strong) NSArray *tagsArray;
@property (nonatomic, strong) NSArray *evaluationArray;

@end

@implementation CollectionViewExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UICollectionViewExample";
    self.view.backgroundColor = [UIColor ajkBackgroundPageColor];
    [self.view addSubview:self.tagsTitleLabel];
    [self.view addSubview:self.tagsCollectionView];
    
    [self.view addSubview:self.evaluationTitleLabel];
    [self.view addSubview:self.evaluationCollectionView];
    
    [self.tagsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0);
        make.top.mas_equalTo(20.0);
    }];
    
    [self.tagsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.tagsTitleLabel.mas_bottom).offset(20.0);
        make.height.mas_equalTo(56.0);
    }];
    
    [self.evaluationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0);
        make.top.mas_equalTo(self.tagsCollectionView.mas_bottom).offset(20.0);
    }];
    
    [self.evaluationCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.evaluationTitleLabel.mas_bottom).offset(20.0);
        make.height.mas_equalTo(180.0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.tagsCollectionView]) {
        return self.tagsArray.count;
    }
    return self.evaluationArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.tagsCollectionView]) {
        AJKPeopleTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AJKPeopleTagCell" forIndexPath:indexPath];
        NSString *tag = self.tagsArray[indexPath.row];
        [cell reloadData:tag];
        return  cell;
    } else {
        AJKSubregionEvaluationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AJKSubregionEvaluationCell" forIndexPath:indexPath];
        NSString *content = self.evaluationArray[indexPath.row];
        [cell reloadData:content];
        return cell;
    }
}

#pragma mark - Getters

- (UILabel *)tagsTitleLabel {
    if (!_tagsTitleLabel) {
        _tagsTitleLabel = [[UILabel alloc] init];
        _tagsTitleLabel.font = [UIFont ajkH2Font];
        _tagsTitleLabel.textColor = [UIColor ajkBlackColor];
        _tagsTitleLabel.text = @"人群特征";
    }
    return _tagsTitleLabel;
}

- (UICollectionView *)tagsCollectionView {
    if (!_tagsCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(55.0, 55.0);
        flowLayout.minimumInteritemSpacing = 10.0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
        _tagsCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _tagsCollectionView.backgroundColor = [UIColor whiteColor];
        _tagsCollectionView.showsHorizontalScrollIndicator = NO;
        _tagsCollectionView.showsVerticalScrollIndicator = NO;
        _tagsCollectionView.delegate = self;
        _tagsCollectionView.dataSource = self;
        [_tagsCollectionView registerClass:[AJKPeopleTagCell class] forCellWithReuseIdentifier:@"AJKPeopleTagCell"];
    }
    return _tagsCollectionView;
}

- (UILabel *)evaluationTitleLabel {
    if (!_evaluationTitleLabel) {
        _evaluationTitleLabel = [[UILabel alloc] init];
        _evaluationTitleLabel.font = [UIFont ajkH2Font];
        _evaluationTitleLabel.textColor = [UIColor ajkBlackColor];
        _evaluationTitleLabel.text = @"张江评测";
    }
    return _evaluationTitleLabel;
}

- (UICollectionView *)evaluationCollectionView {
    if (!_evaluationCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(240.0, 165.0);
        flowLayout.minimumInteritemSpacing = 10.0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
        _evaluationCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _evaluationCollectionView.backgroundColor = [UIColor whiteColor];
        _evaluationCollectionView.showsHorizontalScrollIndicator = NO;
        _evaluationCollectionView.showsVerticalScrollIndicator = NO;
        _evaluationCollectionView.delegate = self;
        _evaluationCollectionView.dataSource = self;
        [_evaluationCollectionView registerClass:[AJKSubregionEvaluationCell class] forCellWithReuseIdentifier:@"AJKSubregionEvaluationCell"];
    }
    return _evaluationCollectionView;
}

- (NSArray *)tagsArray {
    if (!_tagsArray) {
        _tagsArray = @[@"80后", @"刚需", @"新中产", @"很长的标题", @"Hello", @"很长的标题", @"Hello"];
    }
    return _tagsArray;
}

- (NSArray *)evaluationArray {
    if (!_evaluationArray) {
        _evaluationArray = @[
                             @"In case we need to dynamically adjust the cell layout, we should take care of that by overriding apply(_:) in our custom collection view cell (which is a subclass of UICollectionViewCell):",
                             @"In case we need to dynamically adjust the cell layout, we should take care of that by overriding apply(_:) in our custom collection view cell (which is a subclass of UICollectionViewCell):",
                             @"In case we need to dynamically adjust the cell layout, we should take care of that by overriding apply(_:) in our custom collection view cell (which is a subclass of UICollectionViewCell):"
                             ];
    }
    return _evaluationArray;
}

@end
