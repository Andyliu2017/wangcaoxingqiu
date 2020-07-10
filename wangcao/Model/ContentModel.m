//
//  ContentModel.m
//  wangcao
//
//  Created by EDZ on 2020/5/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import "ContentModel.h"
#import "TeamNumberModel.h"

@implementation ContentModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"content": TeamNumberModel.class
    };
}

@end
