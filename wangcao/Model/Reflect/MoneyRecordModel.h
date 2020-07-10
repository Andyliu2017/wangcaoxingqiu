//
//  MoneyRecordModel.h
//  wangcao
//
//  Created by EDZ on 2020/6/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoneyRecordModel : NSObject

//afterBlockMoney (number, optional): 保证金变动后 ,
@property (nonatomic,assign) double afterBlockMoney;
//afterMoney (number, optional): 总余额变动后 ,
@property (nonatomic,assign) double afterMoney;
//blockMoney (number, optional): 保证金变动 ,
@property (nonatomic,assign) double blockMoney;
//fromUserId (integer, optional): 来源用户 ,
@property (nonatomic,assign) NSInteger fromUserId;
//fromUserInfo (SimpleUserInfo, optional): 来源用户信息 ,
@property (nonatomic,strong) UserModel *fromUserInfo;
//invokeId (string, optional): 唯一号 ,
@property (nonatomic,copy) NSString *invokeId;
//money (number, optional): 总余额变动 ,
@property (nonatomic,copy) NSString *money;
//occurTime (string, optional): 时间 ,
@property (nonatomic,copy) NSString *occurTime;
//operDetail (string, optional): 操作详情 ,
@property (nonatomic,copy) NSString *operDetail;
//operInfo (string, optional): 操作信息 ,
@property (nonatomic,copy) NSString *operInfo;
//operType (integer, optional): 操作类型 ,
@property (nonatomic,assign) NSInteger operType;
//preBlockMoney (number, optional): 保证金变动前 ,
@property (nonatomic,assign) double preBlockMoney;
//preMoney (number, optional): 总余额变动前 ,
@property (nonatomic,assign) double preMoney;
//userId (integer, optional): 用户ID
@property (nonatomic,assign) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
