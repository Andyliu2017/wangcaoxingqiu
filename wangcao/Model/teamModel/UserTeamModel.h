//
//  UserTeamModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/14.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamNumberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserTeamModel : NSObject

//bindInviteCode (boolean, optional): 是否绑定邀请码 ,
//contactCount (integer, optional): 通讯录人数 ,
//directCount (integer, optional): 直推人数 ,
//indirectCount (integer, optional): 间推人数 ,
//referUser (ParentVo, optional): 推荐人信息 ,
//totalCount (integer, optional): 总人数

@property (nonatomic,assign) BOOL bindInviteCode;
@property (nonatomic,assign) NSInteger contactCount;
@property (nonatomic,assign) NSInteger directCount;
@property (nonatomic,assign) NSInteger indirectCount;
@property (nonatomic,strong) TeamNumberModel *referUser;
@property (nonatomic,assign) NSInteger totalCount;

/********************* 今日好友赚钱 ****************************/
/// (integer, optional): 活跃人数 ,
@property (nonatomic ,assign) NSInteger activeUser;

/// (number, optional): 扩散好友贡献  代理
@property (nonatomic ,assign) double agentAmount;

/// (number, optional): 直邀好友贡献 ,
@property (nonatomic ,assign) double directAmount;

/// (number, optional): 扩散好友贡献
@property (nonatomic ,assign) double indirectAmount;

/// (number, optional): 今日累计战队收益
@property (nonatomic ,assign) double totalAmount;
 
/********************* 好友累计赚钱 ****************************/

/// (string, optional): 当前阶段名称 ,
@property (nonatomic ,copy) NSString *name;

/// (number, optional): 当前阶段倍数 ,
@property (nonatomic ,assign) double ratio;

/// (integer, optional): 当前阶段 ,
@property (nonatomic ,assign) int stage;

/// (number, optional): 当前阶段收益 ,
@property (nonatomic ,assign) double stageMoney;

/// (number, optional): 当前阶段目标收益 ,
@property (nonatomic ,assign) double targetMoney;

/// (number, optional): 当前未实名收益 ,
@property (nonatomic ,assign) double uncertMoney;

/// (integer, optional): 用户id
@property (nonatomic ,assign) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
