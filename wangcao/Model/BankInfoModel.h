//
//  BankInfoModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/22.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankInfoModel : NSObject

//base (integer, optional): 基本手续费（元） ,
@property (nonatomic,assign) NSInteger base;

//rate (integer, optional): 附加手续费比例（需要除以1万。比如千分之1.2这里给的值是12） ,
@property (nonatomic,assign) NSInteger rate;

//rateStartAmount (integer, optional): 附加手续费比例开始值（元）
@property (nonatomic,assign) NSInteger rateStartAmount;

@end

NS_ASSUME_NONNULL_END
