//
//  ProfitDetailModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfitDetailModel : NSObject

//amount (number, optional),
//fromUserId (integer, optional),
//userId (integer, optional),
//userInfo (TinyUserInfo, optional)
@property (nonatomic,assign) double amount;
@property (nonatomic,assign) NSInteger fromUserId;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,strong) TeamNumberModel *userInfo;

@end

NS_ASSUME_NONNULL_END
