//
//  VideoModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoModel : NSObject

@property (nonatomic ,strong) NSString *advertChannel; // (string, optional) = ['PANGOLIN']
@property (nonatomic ,strong) NSString *award; // (number, optional),
@property (nonatomic ,strong) NSString *awardTime; // (integer, optional): 金币收益时长（分钟） ,
@property (nonatomic ,strong) NSString *awardType; // (string, optional): 奖励类型 COIN：奖励金币 LOTTERY_VOUCHER:奖券 NEXT_LOTTETY_DOUBLE:下一次抽奖翻倍(倍数根据award计算) = ['COIN', 'NEXT_LOTTETY_DOUBLE', 'LOTTERY_VOUCHER']
@property (nonatomic ,assign) NSInteger countDown; // (integer, optional): 广告倒计时，0：可观看，大于0：倒计时 ,
@property (nonatomic ,strong) NSString *videoId; // (string, optional): 流水字段 ,
@property (nonatomic ,assign) NSInteger remainNum; // (integer, optional): 广告剩余次数 ,
@property (nonatomic ,strong) NSString *uid; // (integer, optional): 用户ID

@end

NS_ASSUME_NONNULL_END
