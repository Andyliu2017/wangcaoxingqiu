//
//  RedButton.h
//  wangcao
//
//  Created by EDZ on 2020/5/13.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RedButton : UIButton
//金币、红包id
@property (nonatomic,assign) NSInteger redId;

//是否支持首次提现
@property (nonatomic,assign) NSInteger firstFlag;
//提现 使用
@property (nonatomic,assign) double amount;

@end

NS_ASSUME_NONNULL_END
