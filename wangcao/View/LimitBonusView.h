//
//  LimitBonusView.h
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LimitBonusView : UIView

- (void)showPopView:(UIViewController *)ViewController;

#pragma mark 限时分红
- (void)limitBonusView;
- (void)setLimitBonusData:(FotonExchangeModel *)model withType:(int)type;

#pragma mark 限时分红结束弹窗
- (void)expireBonusView;
- (void)setExpireBonusData:(FotonExchangeModel *)model;

#pragma mark 现金红包
- (void)cashBonusView;
- (void)setCashBonusData:(FotonModel *)model;

@end

NS_ASSUME_NONNULL_END
