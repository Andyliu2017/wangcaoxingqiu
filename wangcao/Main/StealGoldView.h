//
//  StealGoldView.h
//  wangcao
//
//  Created by EDZ on 2020/6/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol StealGoldViewDelegate <NSObject>



@end

@interface StealGoldView : AdSlotView

@property (nonatomic,weak) id<StealGoldViewDelegate> delegate;

- (void)setData:(NSInteger)goldNum;

- (void)showPopView:(UIViewController *)ViewController;

@end

NS_ASSUME_NONNULL_END
