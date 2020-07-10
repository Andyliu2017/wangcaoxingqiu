//
//  WCLoginModel.m
//  wangcao
//
//  Created by liu dequan on 2020/4/29.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WCLoginModel.h"
#import "NSObject+YYModel.h"

@implementation WCLoginModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self modelCopy];
}

- (NSUInteger)hash
{
    return [self modelHash];
}

- (BOOL)isEqual:(id)object
{
    return [self modelIsEqual:object];
}

- (NSString *)description
{
    return [self modelDescription];
}

@end
