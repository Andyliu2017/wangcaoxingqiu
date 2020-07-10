//
//  LotteryListModel.m
//  wangcao
//
//  Created by EDZ on 2020/5/26.
//  Copyright © 2020 andy. All rights reserved.
//

#import "LotteryListModel.h"

@implementation LotteryListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"lotteryLists" : WinContentModel.class
    };
}

@end
