//
//  YinSiView.h
//  wangcao
//
//  Created by EDZ on 2020/6/1.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YinSiViewDelegate <NSObject>

- (void)agreeYinsiBack;
- (void)noAgreeYinsiBack;

@end

@interface YinSiView : UIView

@property (nonatomic,weak) id<YinSiViewDelegate> delegate;

- (void)showPopView:(UIViewController *)ViewController;

- (void)setWebViewUrl:(NSString *)webUrl withTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
