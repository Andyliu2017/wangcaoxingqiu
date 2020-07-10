//
//  PKTeamInfoModel.m
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import "PKTeamInfoModel.h"

@implementation PKTeamInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"team_id":@"id"
    };
}

@end
