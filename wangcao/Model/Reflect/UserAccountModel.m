//
//  UserAccountModel.m
//  wangcao
//
//  Created by EDZ on 2020/6/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import "UserAccountModel.h"

@implementation UserAccountModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"account_id":@"id"
    };
}

@end
