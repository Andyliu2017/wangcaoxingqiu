//
//  PKSubjectModel.m
//  wangcao
//
//  Created by EDZ on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import "PKSubjectModel.h"

@implementation PKSubjectModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"options":PKOptionModel.class
    };
}

@end
