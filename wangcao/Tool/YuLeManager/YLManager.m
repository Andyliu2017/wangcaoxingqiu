//
//  YLManager.m
//  wangcao
//
//  Created by EDZ on 2020/6/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import "YLManager.h"
#import <DyAdSdk/DyAdApi.h>

//多游
#define DyAdMediaid @"dy_59632717"
#define DyAdAppkey @"4aea5f25b532d4521c295a9e5ba6ed16"

//推啊
#define TuiaAPPKey @"b67rS4daAwNcV7agahvGXqSMjX8"
#define TuiaAPPSecret @"MNMPigWrM6jiZJCyvnUNix8b1ArVDZsXYC3s9"
#define TuiaSplashID @"348518"
#define TuiaXuanfuID @"348509"

//爱变现
#define IBXAppKey @"142792796"
#define IBXAppSecret @"758ebae521e5a4c4"

@interface YLManager()<IBXSDKDelegate>

@end

@implementation YLManager

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static YLManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[YLManager alloc] init];
    });
    return instance;
}
#pragma mark 多游
//注册多游
- (void)registerDyAd{
    [DyAdApi registerWithMediaId:DyAdMediaid appKey:DyAdAppkey];
}

//跳转娱乐界面
/*
 多游
 打开广告列表页面
 currentVC:当前的ViewController
 userId:为当前应用的用户Id，或者是用户的唯一标志
 advertType: 0（默认值）显示全部数据  1.手游  2.棋牌游戏
 */
- (void)goToYuleControllerWithTaskCode:(NSString *)taskCode viewController:(UIViewController *)viewControll userId:(NSInteger)userid advertType:(NSInteger)advertType{
    if ([taskCode isEqualToString:@"DUOYOU"]) {
        [DyAdApi presentListViewController:viewControll userId:[NSString stringWithFormat:@"%ld",userid] advertType:advertType];
    }
}

#pragma mark 推啊
- (void)registerTuia{
    [TATMediaCenter startWithAppKey:TuiaAPPKey appSecret:TuiaAPPSecret];
}
- (void)tuiaSetUserid{
    [TATMediaCenter setUserId:[NSString stringWithFormat:@"%ld",[PBCache shared].memberModel.userId]];
}

- (UIView *)getTuiaXuanfuView:(CGRect)frame{
    __weak __typeof(self)weakSelf = self;
    __block UIView *adView = [TATMediaCenter initSimpleAdWithSlotId:TuiaXuanfuID resultBlock:^(BOOL result, NSError *error) {
        if (result) {
            CGRect adViewFrame = adView.frame;
            adViewFrame.origin.x = frame.origin.x;
            adViewFrame.origin.y = frame.origin.y;
            adView.frame = adViewFrame;
        } else {
            NSLog(@"推啊悬浮error:%@",error);
        }
    }];
    
    return adView;
}
//推啊插屏
- (void)showInterstitialAd{
    [TATMediaCenter showInterstitialWithSlotId:TuiaSplashID resultBlock:^(BOOL result, NSError *error) {
        NSLog(@"推啊插屏:%ld,,%@",result,error);
    } closeBlock:^{
        
    }];
}

#pragma mark 爱变现
- (void)registerIBX{
    
}
- (void)showIBXgame:(UIViewController *)viewController{
    [IBXSDKConfig setupAppKey:IBXAppKey secretKey:IBXAppSecret targetId:[NSString stringWithFormat:@"%ld",[PBCache shared].memberModel.userId] notifyUrl:@"not_notifyUrl"];
    [IBXSDK loadWithRootViewController:viewController delegate:self];
}
#pragma mark IBXDelegate
- (void)ibx_didLoad{
    NSLog(@"ibx_didLoad");
}
- (void)ibx_didLoadFail:(NSError *)error{
    NSLog(@"ibx_didLoadFail:%@",error);
}
- (void)ibx_didClose{
    NSLog(@"ibx_didClose");

}

@end
