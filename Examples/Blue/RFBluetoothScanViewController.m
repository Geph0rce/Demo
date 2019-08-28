//
//  RFBluetoothScanViewController.m
//  demo
//
//  Created by Roger on 2019/8/25.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothScanViewController.h"
#import "RFBluetoothPeripheralRow.h"
#import "RFBluetoothManager.h"


@interface RFBluetoothScanViewController ()

@property (nonatomic, strong) RFTableView *tableView;
@property (nonatomic, strong) RFTableSection *dataSection;
@property (nonatomic, strong) RFTableDataSource *dataSource;

@property (nonatomic, strong) NSMutableArray <CBPeripheral *> *periperals;

@end

@implementation RFBluetoothScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ajkWhiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make_top_equalTo(self.topViewAttribute);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    FORBIDDEN_ADJUST_SCROLLVIEW_INSETS(self, self.tableView);
    [self refresh];
}

- (void)refresh {
    weakify(self);
    [self.periperals removeAllObjects];
    [self.dataSection removeAllChildren];
    [self.tableView reloadData];
    [[RFBluetoothManager sharedInstance] scanDidDiscoverPeripheral:^(CBCentralManager * _Nonnull centralManager, CBPeripheral * _Nonnull peripheral, NSDictionary<NSString *,id> * _Nonnull advertisementData, NSNumber * _Nonnull RSSI) {
        strongify(self);
        NSUInteger index = [self.periperals indexOfObject:peripheral];
        if (index == NSNotFound) {
            [self.periperals addObject:peripheral];
            RFBluetoothPeripheralRow *row = [[RFBluetoothPeripheralRow alloc] init];
            row.peripheral = peripheral;
            row.title = [NSString stringWithFormat:@"%@(%@)", peripheral.name ?: @"Unknow", RSSI];
            [self.dataSection addRow:row];
            weakify(self, row);
            row.selectedBlock = ^(RFTableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                strongify(self, row);
                [[RFBluetoothManager sharedInstance] connect:row.peripheral];
            };
            [self.tableView reloadData];
        } else {
            RFBluetoothPeripheralRow *row = [self.dataSection rowAtIndex:index];
            row.title = [NSString stringWithFormat:@"%@(%@)", peripheral.name ?: @"Unknow", RSSI];
            [self.tableView reloadRowsAtIndexPaths:@[ row.indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}


#pragma mark - Custom Top Bar

- (BOOL)shouldUseCustomTopBar {
    return YES;
}

#pragma mark - Getters

- (RFTableView *)tableView {
    if (!_tableView) {
        _tableView = [[RFTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self.dataSource;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (RFTableSection *)dataSection {
    if (!_dataSection) {
        _dataSection = [[RFTableSection alloc] init];
    }
    return _dataSection;
}

- (RFTableDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[RFTableDataSource alloc] init];
        [_dataSource addSection:self.dataSection];
    }
    return _dataSource;
}

- (NSMutableArray *)periperals {
    if (!_periperals) {
        _periperals = [[NSMutableArray alloc] init];
    }
    return _periperals;
}

@end
