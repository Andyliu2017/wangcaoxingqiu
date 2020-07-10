//
//  BonusRecordModel.h
//  wangcao
//
//  Created by EDZ on 2020/6/2.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BonusRecordModel : NSObject

//sealCount (integer, optional): 玉玺数量 ,
@property (nonatomic,assign) NSInteger sealCount;
//totalAmount (number, optional): 分红金额 ,
@property (nonatomic,assign) double totalAmount;
//userId (integer, optional): 用户ID ,
@property (nonatomic,assign) NSInteger userId;
//userInfo (TinyUserInfo, optional): 用户对象
@property (nonatomic,strong) UserModel *userInfo;

@end

NS_ASSUME_NONNULL_END
