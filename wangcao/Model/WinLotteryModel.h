//
//  WinLotteryModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WinLotteryModel : NSObject

@property (nonatomic ,assign) NSInteger base; // (integer, optional): 金币时长(分钟)/宝箱倍数 ,
@property (nonatomic ,strong) NSString *goldCoins; // (number, optional): 金币额度 ,
@property (nonatomic ,assign) NSInteger winId; // (integer, optional): 奖项主键id ,
@property (nonatomic ,strong) NSString *money; // (number, optional): 现金额度 ,
@property (nonatomic ,strong) NSString *name; // (string, optional): 奖项名称 ,
@property (nonatomic ,assign) NSInteger remainVoucher; // (integer, optional): 剩余抽奖券 ,
@property (nonatomic ,assign) NSInteger type; // (integer, optional): 奖项类型，0：金币、1：宝箱,2：现金、、-1：谢谢参与 ,
@property (nonatomic ,strong) VideoModel *videoAdVo; // (视频广告对象, optional): 抽中宝箱时广告对象

//福豆数量
@property (nonatomic,assign) NSInteger blessBean;

@end

NS_ASSUME_NONNULL_END
