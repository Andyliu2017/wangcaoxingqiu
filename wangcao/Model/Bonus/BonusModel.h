//
//  BonusModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/22.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BonusModel : NSObject

/*************** 我的分红玉玺 ****************/
//dateProfit (number, optional): 今日分红 ,
@property (nonatomic,assign) double dateProfit;
//profitCount (integer, optional): 分红果数量 ,
@property (nonatomic,assign) NSInteger profitCount;
//profitFruitInfo (string, optional): 分红果说明 ,
@property (nonatomic,copy) NSString *profitFruitInfo;
//totalProfit (number, optional): 累计分红 ,
@property (nonatomic,assign) double totalProfit;
//userId (integer, optional): 用户ID
@property (nonatomic,assign) NSInteger userId;

/***************** 获取平台分红玉玺的金额 ******************/
//hasProfitFruit (boolean, optional): 平台是否有分红玉玺 ,
@property (nonatomic,assign) BOOL hasProfitFruit;
//profitMoney (number, optional): 当日限时分红玉玺瓜分金额
@property (nonatomic,assign) double profitMoney;

@end

NS_ASSUME_NONNULL_END
