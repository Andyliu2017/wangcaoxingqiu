//
//  TaskDetailModel.m
//  wangcao
//
//  Created by liu dequan on 2020/5/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TaskDetailModel.h"

@implementation TaskDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"task_id":@"id"
    };
}

@end
