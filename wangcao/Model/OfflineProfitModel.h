//
//  OfflineProfitModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/25.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OfflineProfitModel : NSObject

//goldCoin (number, optional): 离线产生了多少金币 ,
@property (nonatomic,assign) double goldCoin;
//offlineTime (integer, optional): 离线多久 ,
@property (nonatomic,assign) NSInteger offlineTime;
//videoAd (视频广告对象, optional): 视频广告对象：如果有广告才会有。如果没有广告。则这个地方为空 ,
@property (nonatomic,strong) VideoModel *videoAd;
//videoAdDouble (integer, optional): 广告是否翻倍,如果为0则代表没有看广告翻倍这么一说。如果>0则代表翻多少倍
@property (nonatomic,assign) NSInteger videoAdDouble;

@end

NS_ASSUME_NONNULL_END
