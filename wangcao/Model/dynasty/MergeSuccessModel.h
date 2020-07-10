//
//  MergeSuccessModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/29.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MergeSuccessModel : NSObject

//number (integer, optional): 数量：限时分红（分钟） ,
@property (nonatomic,assign) NSInteger number;
//rewardType (string, optional): TIME_PROFIT：限时分红/PROFIT：永久分红
@property (nonatomic,copy) NSString *rewardType;

@end

NS_ASSUME_NONNULL_END
