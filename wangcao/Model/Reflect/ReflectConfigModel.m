//
//  ReflectConfigModel.m
//  wangcao
//
//  Created by EDZ on 2020/6/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import "ReflectConfigModel.h"
#import "ReflectListModel.h"

@implementation ReflectConfigModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"userWithdrawConfigVoList":ReflectListModel.class
    };
}

@end
