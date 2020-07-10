//
//  FotonModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FotonModel : NSObject

/*************** 福豆 *****************/
//afterBlessBean (integer, optional): 福豆变更后 ,
@property (nonatomic,assign) NSInteger afterBlessBean;
//blessBean (integer, optional): 福豆变更 ,
@property (nonatomic,assign) NSInteger blessBean;
//id (integer, optional): ID ,
@property (nonatomic,assign) NSInteger foton_id;
//invokeId (string, optional): 唯一串 ,
@property (nonatomic,copy) NSString *invokeId;
//occurTime (string, optional): 操作时间 ,
@property (nonatomic,copy) NSString *occurTime;
//operInfo (string, optional): 操作信息 ,
@property (nonatomic,copy) NSString *operInfo;
//operType (integer, optional): 操作类型 ,
@property (nonatomic,assign) NSInteger operType;
//preBlessBean (integer, optional): 福豆变更前 ,
@property (nonatomic,assign) NSInteger preBlessBean;
//userId (integer, optional): 用户ID
@property (nonatomic,assign) NSInteger userId;

/***************** 现金红包 ****************/
//money (number, optional): 钱 ,
@property (nonatomic,assign) double money;
//status (integer, optional): 状态 0:未领取 1:已领取 ,
@property (nonatomic,assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
