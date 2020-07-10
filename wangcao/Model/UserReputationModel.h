//
//  UserReputationModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserReputationModel : NSObject

//levelNo (integer, optional): 用户等级 ,
@property (nonatomic,assign) NSInteger levelNo;
//nextLevelRequired (integer, optional): 用户下级升级所需积分 ,
@property (nonatomic,assign) NSInteger nextLevelRequired;
//point (integer, optional): 用户当前总积分
@property (nonatomic,assign) NSInteger point;

@end

NS_ASSUME_NONNULL_END
