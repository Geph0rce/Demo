//
//  UIViewController+RFNetworking.m
//  demo
//
//  Created by qianjie on 2017/12/18.
//  Copyright © 2017年 Zen. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+RFNetworking.h"

static NSInteger const RFNetworkingTokenExpireErrorCode = 401;
static NSString *const RFNetworkingRefreshTokenURL = @"http://www.baidu.com/refreshtoken";

@implementation UIViewController (RFNetworking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(crf_dealloc);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)crf_dealloc {
    [self.crf_networkManager abort];
    [self crf_dealloc];
}

- (void)get:(NSString *)url params:(NSDictionary *)params complete:(RFNetworkCompleteBlock)complete {
    [self.crf_networkManager get:url params:params complete:^(__kindof NSObject *  _Nullable response, NSInteger statusCode, NSError * _Nullable error) {
        if (statusCode == RFNetworkingTokenExpireErrorCode) {
            [self refreshToken:^(RFTokenModel *model, NSInteger statusCode, NSError * _Nullable error) {
                if (error && complete) {
                    complete(nil, statusCode, error);
                } else {
                    [self.crf_networkManager get:url params:params complete:complete];
                }
            }];
            return;
        }
        
        if (complete) {
            complete(response, statusCode, error);
        }
        
    }];
}

- (void)post:(NSString *)url params:(NSDictionary *)params complete:(RFNetworkCompleteBlock)complete {
    [self.crf_networkManager post:url params:params complete:^(__kindof NSObject *  _Nullable response, NSInteger statusCode, NSError * _Nullable error) {
        if (statusCode == RFNetworkingTokenExpireErrorCode) {
            [self refreshToken:^(RFTokenModel *model, NSInteger statusCode, NSError * _Nullable error) {
                if (error && complete) {
                    complete(nil, statusCode, error);
                } else {
                    [self.crf_networkManager post:url params:params complete:complete];
                }
            }];
            return;
        }
        
        if (complete) {
            complete(response, statusCode, error);
        }
    }];

}

- (void)upload:(NSString *)url imageData:(NSData *)imageData progress:(nullable RFNetworkProgressBlock)progress complete:(nullable RFNetworkCompleteBlock)complete; {
    [self.crf_networkManager upload:url imageData:imageData progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } complete:^(__kindof NSObject * _Nullable response, NSInteger statusCode, NSError * _Nullable error) {
        if (statusCode == RFNetworkingTokenExpireErrorCode) {
            [self refreshToken:^(RFTokenModel *model, NSInteger statusCode, NSError * _Nullable error) {
                if (error && complete) {
                    complete(nil, statusCode, error);
                } else {
                    [self.crf_networkManager upload:url imageData:imageData progress:progress complete:complete];
                }
            }];
            return;
         }
        
        if (complete) {
            complete(response, statusCode, error);
        }
    }];
}

- (void)cancel:(NSString *)url {
    [self.crf_networkManager cancel:url];
}


- (void)refreshToken:(RFNetworkCompleteBlock)complete {
    [[RFTokenUtil sharedInstance] refreshToken:complete];
}

#pragma mark - Getters

- (RFNetworkManager *)crf_networkManager {
    RFNetworkManager *manager = objc_getAssociatedObject(self, _cmd);
    if (!manager) {
        manager = [[RFNetworkManager alloc] init];
        objc_setAssociatedObject(self, _cmd, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return manager;
}

@end
