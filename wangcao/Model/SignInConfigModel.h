//
//  SignInConfigModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignInConfigModel : NSObject

//day (integer, optional): 第几天 ,
//desc (string, optional): 描述 ,
//reward (number, optional): 奖励数量 ,
//rewardType (string, optional): 签到奖励什么，GOLD:金币，REBIRTH_CARD:复活卡，BLESS_BEAN:福豆 = ['GOLD', 'REBIRTH_CARD', 'BLESS_BEAN']
@property (nonatomic,assign) NSInteger day;   //第几天
@property (nonatomic,copy) NSString *desc;    //描述
@property (nonatomic,assign) NSInteger reward;
@property (nonatomic,copy) NSString *rewardType;

@end

NS_ASSUME_NONNULL_END
