//
//  SignInSuccessView.h
//  wangcao
//
//  Created by EDZ on 2020/5/21.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignInSuccessView : UIView
/*
 reward  奖励的数量
 rewardType 签到奖励什么，GOLD:金币，REBIRTH_CARD:复活卡，BLESS_BEAN:福豆
 */
- (void)setDataContinuNum:(NSInteger)continuNum reward:(NSInteger)reward rewardType:(NSString *)rewardType;

- (void)showPopView:(UIViewController *)ViewController;

@end

NS_ASSUME_NONNULL_END
