//
//  APRequestSerializer.h
//  wangcao
//
//  Created by EDZ on 2020/5/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APRequestSerializer : NSObject

FOUNDATION_EXPORT NSString *APQueryStringFromParameters(NSDictionary *parameters);

@end

NS_ASSUME_NONNULL_END
