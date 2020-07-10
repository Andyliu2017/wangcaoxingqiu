//
//  DynastyModel.m
//  wangcao
//
//  Created by EDZ on 2020/5/6.
//  Copyright © 2020 andy. All rights reserved.
//

#import "DynastyModel.h"

@implementation DynastyModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"structures":DynastyBuildModel.class
    };
}

@end
