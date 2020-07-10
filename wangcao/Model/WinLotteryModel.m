//
//  WinLotteryModel.m
//  wangcao
//
//  Created by EDZ on 2020/5/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WinLotteryModel.h"

@implementation WinLotteryModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"winId":@"id"
            };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"videoAdVo" : VideoModel.class
            };
}

@end
