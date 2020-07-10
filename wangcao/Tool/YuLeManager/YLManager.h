//
//  YLManager.h
//  wangcao
//
//  Created by EDZ on 2020/6/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TATMediaSDK/TATMediaSDK.h>
#import <IBXSDK/IBXSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLManager : NSObject

+ (instancetype)sharedManager;

#pragma mark 多游
//注册多游
- (void)registerDyAd;

//跳转娱乐界面
- (void)goToYuleControllerWithTaskCode:(NSString *)taskCode viewController:(UIViewController *)viewControll userId:(NSInteger)userid advertType:(NSInteger)advertType;

#pragma mark 推啊
- (void)registerTuia;
//设置userid
- (void)tuiaSetUserid;
//首页悬浮广告
- (UIView *)getTuiaXuanfuView:(CGRect)frame;
//推啊插屏
- (void)showInterstitialAd;

#define mark 爱变现
- (void)showIBXgame:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
