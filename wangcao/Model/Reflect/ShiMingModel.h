//
//  ShiMingModel.h
//  wangcao
//
//  Created by EDZ on 2020/6/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShiMingModel : NSObject

//aliAccount (string, optional): 支付宝号 ,
@property (nonatomic,copy) NSString *aliAccount;
//bankno (string, optional): 银行卡号 ,
@property (nonatomic,copy) NSString *bankno;
//idcard (string, optional): 身份证号 ,
@property (nonatomic,copy) NSString *idcard;
//name (string, optional): 名称 ,
@property (nonatomic,copy) NSString *name;
//status (integer, optional): 状态 -1:审核不通过,0:待审核 1成功 ,
@property (nonatomic,assign) NSInteger status;
//userId (integer, optional): 用户ID
@property (nonatomic,assign) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
