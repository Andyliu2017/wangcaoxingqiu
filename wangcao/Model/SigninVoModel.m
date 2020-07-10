//
//  SigninVoModel.m
//  wangcao
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import "SigninVoModel.h"
#import "SignInConfigModel.h"

@implementation SigninVoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"configs":SignInConfigModel.class
    };
}

@end
