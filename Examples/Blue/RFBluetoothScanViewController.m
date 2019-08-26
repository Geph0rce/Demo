//
//  RFBluetoothScanViewController.m
//  demo
//
//  Created by Roger on 2019/8/25.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothScanViewController.h"
#import "RFBluetoothManager.h"

@interface RFBluetoothScanViewController ()

@end

@implementation RFBluetoothScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ajkWhiteColor];
    [[RFBluetoothManager sharedInstance].centralManager scanForPeripheralsWithServices:nil options:nil];
}


@end
