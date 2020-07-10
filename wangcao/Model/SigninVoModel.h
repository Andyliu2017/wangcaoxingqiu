//
//  SigninVoModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SigninVoModel : NSObject

//configs (Array[签到配置], optional): 签到配置奖励项 ,
//continuNum (integer, optional): 连续签到第几天 ,
//signin (boolean, optional)

@property (nonatomic,strong) NSArray *configs;  //签到配置奖励项
@property (nonatomic,assign) NSInteger continuNum;  //连续签到第几天
@property (nonatomic,assign) BOOL signin;

@end

NS_ASSUME_NONNULL_END
