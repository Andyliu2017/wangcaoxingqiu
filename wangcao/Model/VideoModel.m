//
//  VideoModel.m
//  wangcao
//
//  Created by EDZ on 2020/5/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"videoId":@"id"
            };
}

@end
