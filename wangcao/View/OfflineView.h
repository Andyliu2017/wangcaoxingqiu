//
//  OfflineView.h
//  wangcao
//
//  Created by EDZ on 2020/5/25.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OfflineViewDelegate <NSObject>

//金币不足
- (void)goldNotEnoughBack:(VideoModel *)model;
//弹窗关闭
- (void)offlineViewClose;
//离线收益看视频翻倍
- (void)offlineGoldDoubleWithVideo:(VideoModel *)model;

@end

@interface OfflineView : AdSlotView

@property (nonatomic,weak) id<OfflineViewDelegate> delegate;

- (void)showPopView:(UIViewController *)ViewController;
- (void)closeAction;

#pragma mark 获取福豆
- (void)setFutonView;
- (void)setFotonData:(FotonModel *)model;

#pragma mark 离线收益
- (void)setOfflineView;
- (void)setOfflineData:(OfflineProfitModel *)model;

#pragma mark 金币不足
- (void)setGoldEnoughView;
- (void)setgoldEnoughData:(VideoModel *)model;
//看视频获取金币
- (void)watchVideoGetGold;

@end

NS_ASSUME_NONNULL_END
