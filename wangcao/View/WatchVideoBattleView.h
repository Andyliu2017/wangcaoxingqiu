//
//  WatchVideoBattleView.h
//  wangcao
//
//  Created by EDZ on 2020/5/26.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WatchVideoBattleViewDelegate <NSObject>

- (void)WatchVideoBattleViewBack:(VideoModel *)model;
- (void)noVideoBattleViewBack:(VideoModel *)model;

@end

@interface WatchVideoBattleView : AdSlotView

@property (nonatomic,weak) id<WatchVideoBattleViewDelegate> delegate;

- (void)showPopView:(UIViewController *)ViewController;
- (void)setVideoIdData:(VideoModel *)model;
- (void)closeAction;

@end

NS_ASSUME_NONNULL_END
