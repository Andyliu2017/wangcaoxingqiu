//
//  OtherPopView.h
//  wangcao
//
//  Created by EDZ on 2020/5/21.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRebirthModel.h"
#import "AdSlotView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OtherPopViewDelegate <NSObject>
#pragma mark 答错之后看视频复活
- (void)watchVideoRebirth:(PKRebirthModel *)model;
- (void)noVideoRebirth:(PKRebirthModel *)model;   //跳过视频直接复活
#pragma mark 使用复活卡复活
- (void)useRebirthCard;
#pragma mark 直接退出挑战页面
- (void)exitBattleController;
#pragma mark 确认是否退出
- (void)confirmIsExit;

@end

@interface OtherPopView : AdSlotView

@property (weak, nonatomic) id<OtherPopViewDelegate> delegate;

//答错题
- (void)setAnswerErrorUI;
- (void)setAnswerErrorData:(NSInteger)correctNum fhCardNum:(NSInteger)fhCardNum reBirthNum:(NSInteger)reBirthNum viewType:(NSInteger)vType pkrebirthModel:(PKRebirthModel *)model;
//确定退出
- (void)setDetermineExitUI;
- (void)setDetermineExitData:(NSInteger)answerNum viewType:(NSInteger)vType;

- (void)showPopView:(UIViewController *)ViewController;
//外部调用
- (void)outCloseAction;

@end

NS_ASSUME_NONNULL_END
