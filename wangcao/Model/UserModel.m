//
//  UserModel.m
//  wangcao
//
//  Created by EDZ on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"user_id":@"id"
    };
}

@end
