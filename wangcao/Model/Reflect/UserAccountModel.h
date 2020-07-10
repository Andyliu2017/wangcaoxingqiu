//
//  UserAccountModel.h
//  wangcao
//
//  Created by EDZ on 2020/6/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserAccountModel : NSObject

//acquireMoney (number, optional): 累计收益 ,
@property (nonatomic,assign) double acquireMoney;
//blockMoney (number, optional): 冻结金额 ,
@property (nonatomic,assign) double blockMoney;
//cashMoney (number, optional): 可提现金额 ,
@property (nonatomic,assign) double cashMoney;
//createTime (string, optional): 创建时间 ,
@property (nonatomic,copy) NSString *createTime;
//enabledMoney (number, optional): 可用余额 ,
@property (nonatomic,assign) double enabledMoney;
//goldCoins (number, optional): 金币 ,
@property (nonatomic,assign) double goldCoins;
//id (integer, optional): ID ,
@property (nonatomic,assign) NSInteger account_id;
//money (number, optional): 总余额 ,
@property (nonatomic,assign) double money;
//score (number, optional): 积分 ,
@property (nonatomic,assign) double score;
//status (integer, optional): 状态 ,
@property (nonatomic,assign) NSInteger status;
//userId (integer, optional): 用户ID
@property (nonatomic,assign) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
