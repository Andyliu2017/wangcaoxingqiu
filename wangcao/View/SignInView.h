//
//  SignInView.h
//  wangcao
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SignInViewDelegate <NSObject>

- (void)SingInActionBack:(VideoModel *)model;
//不看视频直接签到
- (void)SingInNotVideo:(VideoModel *)model;

@end

@interface SignInView : AdSlotView

@property (nonatomic,weak) id<SignInViewDelegate> delegate;

//签到数据
@property (nonatomic,strong) NSArray *dataArr;
//是否已经签到
@property (nonatomic,assign) BOOL isSignIn;
//连续签到天数
@property (nonatomic,assign) NSInteger continuNum;

- (void)showPopView:(UIViewController *)ViewController;
- (void)closeAction;

@end

NS_ASSUME_NONNULL_END
