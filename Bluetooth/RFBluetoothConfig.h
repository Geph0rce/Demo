//
//  RFBluetoothConfig.h
//  demo
//
//  Created by qianjie on 2019/8/27.
//  Copyright © 2019 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RFBluetoothConfig : NSObject

@property (nonatomic, copy) NSString *serviceUUID;
@property (nonatomic, copy) NSString *readCharacteristicUUID;
@property (nonatomic, copy) NSString *writeCharacteristicUUID;

@end

NS_ASSUME_NONNULL_END
