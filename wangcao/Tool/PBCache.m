//
//  PBCache.m
//  wangcao
//
//  Created by EDZ on 2020/5/13.
//  Copyright © 2020 andy. All rights reserved.
//

#import "PBCache.h"

@implementation PBCache

static PBCache *sharedInstance;

+ (PBCache *)shared {
    
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[PBCache alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

@end
