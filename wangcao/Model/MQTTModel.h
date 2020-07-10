//
//  MQTTModel.h
//  wangcao
//
//  Created by EDZ on 2020/6/6.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FotonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MQTTModel : NSObject

//{"data":{"blessBean":1252,"id":477,"invokeId":"6cd52296a41141d6bdb9b761dc032e21","operInfo":"升级建筑赠送","operType":6},"messageId":"e8137e74972c4635b467b89f5689911a","messageTime":1591415710015,"type":"ACQUIRE_BLESS_BEAN"}

@property (nonatomic,strong) FotonModel *data;
@property (nonatomic,copy) NSString *messageId;
@property (nonatomic,assign) NSInteger messageTime;
@property (nonatomic,copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
