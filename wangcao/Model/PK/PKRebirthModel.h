//
//  PKRebirthModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/21.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKRebirthModel : NSObject

//rebirthNumber (integer, optional): 可用复活卡数量 ,
@property (nonatomic,assign) NSInteger rebirthNumber;
//videoAd (视频广告对象, optional): 广告对象
@property (nonatomic,strong) VideoModel *videoAd;

@end

NS_ASSUME_NONNULL_END
