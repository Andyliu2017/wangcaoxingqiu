//
//  AdHandleManager.h
//  wangcao
//
//  Created by EDZ on 2020/5/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUSplashAdView.h>
#import <GDTSDKConfig.h>
#import <GDTSplashAd.h>
#import <GDTRewardVideoAd.h>
#import <WindSDK/WindSDK.h>

//typedef enum : NSUInteger{
//    PANGOLIN,
//    BQT,
//    SIG_MOB,
//    MINTEGRAL,
//    TENCENT,
//}AdChannel;

NS_ASSUME_NONNULL_BEGIN
@protocol AdHandleManagerDelegate <NSObject>

- (void)BUADVideoFinish:(id)rewardedVideoAd withVideoModel:(VideoModel *)model withType:(NSInteger)type;

- (void)BUADSlotVideoLoadSuccess;
- (void)BUADSlotVideoLoadFail;

@end

@interface AdHandleManager : NSObject

@property (nonatomic,weak) id<AdHandleManagerDelegate> delegate;

+ (instancetype)sharedManager;

#pragma mark 穿山甲
//注册穿山甲
- (void)registerBUAD;
/// 观看广告  激励视频
/// @param videoId 广告ID
/// @param videoType 观看广告类型 1：签到  2：看视频领取抽奖券
///  3：抽奖宝箱领取金币 4：看视频领取金币 5：看视频领取复活卡 6：看视频继续挑战  7：看视频复活  8 离线收益
///@param adchannel 广告渠道  PANGOLIN 穿山甲  BQT SIG_MOB  MINTEGRAL  TENCENT 腾讯
- (void)RewardedSlotVideoAdViewRender:(VideoModel *)vModel
videoType:(NSInteger)videoType viewController:(UIViewController *)vc;

#pragma mark 开屏 启动页
- (void)playSplashVideoWithBUAD:(UIWindow *)keyWindow;
#pragma mark 信息流
- (void)loadNativeAdsWithWidth:(CGFloat)width height:(CGFloat)height view:(UIView *)slotview viewController:(UIViewController *)viewController;

#pragma mark 腾讯视频
//注册腾讯视频
- (void)registerGDTAD;
#pragma mark 腾讯开屏
- (void)playSplashVideoWithGDT;

#pragma mark sigmob
- (void)registerSigmob;
//sigmob开屏广告
- (void)showSigmobSplashAd;

@end

NS_ASSUME_NONNULL_END
