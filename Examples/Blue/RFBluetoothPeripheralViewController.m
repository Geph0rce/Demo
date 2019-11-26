//
//  RFBluetoothPeripheralViewController.m
//  demo
//
//  Created by Roger on 2019/8/30.
//  Copyright © 2019 Zen. All rights reserved.
//

#import "RFBluetoothPeripheralViewController.h"

@interface RFBluetoothPeripheralViewController ()

@property (nonatomic, strong) UIButton *voltageButton;
@property (nonatomic, strong) UIButton *currentButton;
@property (nonatomic, strong) UIButton *powerButton;




@end

@implementation RFBluetoothPeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ajkWhiteColor];
    [self.view addSubview:self.voltageButton];
    [self.view addSubview:self.currentButton];
    [self.view addSubview:self.powerButton];
    
    [self.voltageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make_top_equalTo(100.0);
        make_centerX_equalTo(self.view);
    }];
    
    [self.currentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make_top_equalTo(self.voltageButton.mas_bottom).offset(20.0);
        make_centerX_equalTo(self.voltageButton);
    }];
    
    [self.powerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make_top_equalTo(self.currentButton.mas_bottom).offset(20.0);
        make_centerX_equalTo(self.currentButton);
    }];
}

- (BOOL)shouldUseCustomTopBar {
    return YES;
}

#pragma mark - Getters

- (UIButton *)voltageButton {
    if (!_voltageButton) {
        _voltageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_voltageButton setTitle:@"电压" forState:UIControlStateNormal];
        weakify(self);
        [_voltageButton handleTouchUpInsideWithBlock:^{
            strongify(self);
            [self.manager requestVoltageData:^(RFBluetoothDataManager * _Nonnull manager, __kindof RFBluetoothPackage * _Nullable package, NSError * _Nullable error) {

            }];
        }];
    }
    return _voltageButton;
}

- (UIButton *)currentButton {
    if (!_currentButton) {
        _currentButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_currentButton setTitle:@"电流" forState:UIControlStateNormal];
        weakify(self);
        [_currentButton handleTouchUpInsideWithBlock:^{
            strongify(self);
            [self.manager requestCurrentData:^(RFBluetoothDataManager * _Nonnull manager, __kindof RFBluetoothPackage * _Nullable package, NSError * _Nullable error) {
                
            }];
        }];
    }
    return _currentButton;
}

- (UIButton *)powerButton {
    if (!_powerButton) {
        _powerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_powerButton setTitle:@"电量" forState:UIControlStateNormal];
        weakify(self);
        [_powerButton handleTouchUpInsideWithBlock:^{
            strongify(self);
            [self.manager requestBatteryPowerData:^(RFBluetoothDataManager * _Nonnull manager, __kindof RFBluetoothPackage * _Nullable package, NSError * _Nullable error) {
                
            }];
        }];
    }
    return _powerButton;
}

@end
