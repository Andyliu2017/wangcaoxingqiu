//
//  RankModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RankModel : NSObject

//allusionCount (integer, optional): 典故卡数量 ,
@property (nonatomic ,assign) NSInteger allusionCount;
//avatar (string, optional): 用户头像 ,
@property (nonatomic ,copy) NSString *avatar;
//dynasty (integer, optional): 朝代等级 ,
@property (nonatomic,assign) NSInteger dynasty;
//dynastyName (string, optional): 王朝名称 ,
@property (nonatomic ,copy) NSString *dynastyName;
//goldCoins (number, optional): 金币排行金币数 ,
@property (nonatomic,assign) double goldCoins;
//nickName (string, optional): 用户昵称 ,
@property (nonatomic ,copy) NSString *nickName;
//price (number, optional): 收益排行价格 ,
@property (nonatomic,assign) double price;
//userId (integer, optional): 用户ID
@property (nonatomic,assign) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
