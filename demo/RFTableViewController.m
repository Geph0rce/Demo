//
//  RFTableViewController.m
//  demo
//
//  Created by qianjie on 2017/11/30.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import "RFTableModel.h"
#import "RFTableViewController.h"

static NSString *const kRFTableViewCellId = @"RFTableViewCellId";

@interface RFTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <RFTableModel *> *rowsArray;

@end

@implementation RFTableViewController

- (void)dealloc {
    DLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"functions";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - reloadData

- (void)reloadData {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.rowsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RFTableModel *model = self.rowsArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRFTableViewCellId];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RFTableModel *model = self.rowsArray[indexPath.row];
    guard (model.className.length > 0) else {
        DLog(@"className is nil");
        return;
    }
    
    Class controllerClass = NSClassFromString(model.className);
    UIViewController *controller = (UIViewController *)[[controllerClass alloc] init];
    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark - getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 44.0;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kRFTableViewCellId];
    }
    return _tableView;
}

- (NSArray <RFTableModel *> *)rowsArray {
    if (!_rowsArray) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        RFTableModel *handleModel = [[RFTableModel alloc] init];
        handleModel.title = @"NetworkExampleViewController";
        handleModel.className = @"NetworkExampleViewController";
        [array addObject:handleModel];
        RFTableModel *screenModel = [[RFTableModel alloc] init];
        screenModel.title = @"TakeScreenShotViewController";
        screenModel.className = @"TakeScreenShotViewController";
        [array addObject:screenModel];
        RFTableModel *flexModel = [[RFTableModel alloc] init];
        flexModel.title = @"FlexBoxViewController";
        flexModel.className = @"FlexBoxViewController";
        [array addObject:flexModel];
        RFTableModel *collectionModel = [[RFTableModel alloc] init];
        collectionModel.title = @"CollectionViewExampleViewController";
        collectionModel.className = @"CollectionViewExampleViewController";
        RFTableModel *dcollectionModel = [[RFTableModel alloc] init];
        dcollectionModel.title = @"DCollectionViewController";
        dcollectionModel.className = @"DCollectionViewController";
        [array addObject:dcollectionModel];
        _rowsArray = [array copy];
        
    }
    return _rowsArray;
}

@end
