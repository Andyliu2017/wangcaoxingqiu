//
//  UncertInfoVoModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/14.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UncertInfoVoModel : NSObject

//uncertCount (integer, optional),
//uncertMoney (number, optional)
@property (nonatomic,assign) NSInteger uncertCount;  //未实名人数
@property (nonatomic,strong) NSNumber *uncertMoney;  //收益

@end

NS_ASSUME_NONNULL_END
