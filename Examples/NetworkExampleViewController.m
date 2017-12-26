//
//  NetworkExampleViewController.m
//  demo
//
//  Created by qianjie on 2017/12/26.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import "NetworkExampleViewController.h"

@interface NetworkExampleViewController ()

@end

@implementation NetworkExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upload:@"http://logger-uat.crfchina.com/common-api/ubt/log" image:[UIImage imageNamed:@"example.jpg"] progress:^(NSProgress * _Nonnull uploadProgress) {
        DLog(@"progress: %@", [uploadProgress description]);
    } complete:^(id  _Nullable response, NSInteger statusCode, NSError * _Nullable error) {
        
        DLog(@"status code: %@", @(statusCode));
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
