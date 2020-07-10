//
//  RecordListModel.m
//  wangcao
//
//  Created by EDZ on 2020/5/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import "RecordListModel.h"
#import "LuckMessageModel.h"

@implementation RecordListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"content" : LuckMessageModel.class
    };
}

@end
