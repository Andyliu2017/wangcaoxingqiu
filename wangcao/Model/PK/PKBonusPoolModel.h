//
//  PKBonusPoolModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKBonusPoolModel : NSObject

//joinNumber (integer, optional),
//poolAmount (number, optional)

@property (nonatomic,assign) NSInteger joinNumber;
@property (nonatomic,assign) CGFloat poolAmount;

@end

NS_ASSUME_NONNULL_END
