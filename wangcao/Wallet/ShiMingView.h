//
//  ShiMingView.h
//  wangcao
//
//  Created by EDZ on 2020/6/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ShiMingViewDelegate <NSObject>

- (void)cancelAction;
- (void)comfireAction:(NSString *)name idcard:(NSString *)idcard alipay:(NSString *)alipay;

@end

@interface ShiMingView : UIView

@property (nonatomic,weak) id<ShiMingViewDelegate> delegate;

- (void)showPopView:(UIViewController *)ViewController;

- (void)setData:(NSString *)name idcard:(NSString *)idcard alipaystr:(NSString *)alipay;

- (void)closeAction;

@end

NS_ASSUME_NONNULL_END
