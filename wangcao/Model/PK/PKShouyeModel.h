//
//  PKShouyeModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKBonusPoolModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKShouyeModel : NSObject

//answerTime (integer, optional): 答题时长(s) ,
//battleInfo (string, optional): 描述信息 ,
//groupPool (pk奖金池, optional): 团体PK奖金池信息 ,
//hasGroup (boolean, optional): 是否有组队 ,
//personalPool (pk奖金池, optional): 个人PK奖金池信息 ,
//status (integer, optional): 1:进行中，-1:已结束 0:还未开始 ,
//surplusTime (integer, optional): 如果是进行中：返回剩余结束时间(s),如果是还未开始，返回：剩余开始时间（s）。否则返回-1
@property (nonatomic,assign) NSInteger answerTime;
@property (nonatomic,copy) NSString *battleInfo;
@property (nonatomic,strong) PKBonusPoolModel *groupPool;
@property (nonatomic,assign) BOOL hasGroup;
@property (nonatomic,strong) PKBonusPoolModel *personalPool;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger surplusTime;

@end

NS_ASSUME_NONNULL_END
