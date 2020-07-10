//
//  RedPackageModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/13.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RedPackageModel : NSObject

//amount (number, optional): 金额 ,
//effectTime (string, optional): 可领取时间 ,
//id (integer, optional): 可偷红包ID ,
//invalidTime (string, optional): 红包失效时间 ,
//pickFlag (boolean, optional): true:可领取、false：不可领取 ,
//stealEnableTime (string, optional): 可偷取时间 ,
//stealFlag (boolean, optional): true:可偷取、false：不可偷取 ,
//type (integer, optional): 1:金币 ,
//userSteal (boolean, optional): 当前用户是否偷取过

@property (nonatomic,assign) NSInteger amount;
@property (nonatomic,copy) NSString *effectTime;
@property (nonatomic,assign) NSInteger red_id;
@property (nonatomic,copy) NSString *invalidTime;
@property (nonatomic,assign) BOOL pickFlag;
@property (nonatomic,copy) NSString *stealEnableTime;
@property (nonatomic,assign) BOOL stealFlag;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) BOOL userSteal;

//收取红包成功后的返回
@property (nonatomic,assign) double stealMoney;   //领取数额
@property (nonatomic,assign) NSInteger userId;       //当前用户

@end

NS_ASSUME_NONNULL_END
