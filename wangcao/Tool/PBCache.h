//
//  PBCache.h
//  wangcao
//
//  Created by EDZ on 2020/5/13.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "SystemModel.h"
#import "GoldModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PBCache : NSObject

+(PBCache *)shared;

@property (nonatomic,strong) WCLoginModel *memberModel;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,copy) NSString *code;  //唯一串/答题需要提交
@property (nonatomic,assign) NSInteger fhCardNum;  //复活卡数量
@property (nonatomic,assign) NSInteger maxCountDown;  //最大倒计时 答题
@property (nonatomic,strong) SystemModel *systemModel;  //系统配置
@property (nonatomic,strong) GoldModel *goldModel;   //金币、福豆信息

@end

NS_ASSUME_NONNULL_END
