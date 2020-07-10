//
//  DrowPopView.h
//  wangcao
//
//  Created by EDZ on 2020/5/26.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DrowPopViewDelegate <NSObject>

- (void)drowPopWatchVideoBack:(WinLotteryModel *)model;

- (void)drowPopNoVideoBack:(WinLotteryModel *)model;

@end

@interface DrowPopView : AdSlotView

@property (nonatomic,weak) id<DrowPopViewDelegate> delegate;

- (void)showPopView:(UIViewController *)ViewController;
- (void)setDrowPopViewData:(WinLotteryModel *)model array:(NSArray *)imageArr;
- (void)closeAction;

@end

NS_ASSUME_NONNULL_END
