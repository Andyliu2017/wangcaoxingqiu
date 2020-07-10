//
//  AdHandleManager.m
//  wangcao
//
//  Created by EDZ on 2020/5/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import "AdHandleManager.h"

/// 穿山甲APPID
#define BU_Appid @"5074530"
/// 穿山甲激励视屏ID
#define BU_SlotID @"945229391"
///插屏广告
#define BU_InsetID @"945229396"
///信息流广告
#define BU_InformationID @"945229399"
///开屏广告
#define BU_OpenID @"887334788"
//draw信息流
#define BU_DrawInformationID @"945229395"

//sigmob
#define SigmobAPPID @"4493"
#define SigmobAPPKEY @"3466a7994c66e911"
#define SigmobSplashID @"e7c8bd171ea"
#define SigmobRewardeID @"e7c8bcd8ce3"

//腾讯
#define GDTAppId @"1110553231"
#define GDTRewardId @"3021118810347956"
#define GDTSplashId @"8031412830357087"

@interface AdHandleManager()<BUNativeExpressRewardedVideoAdDelegate,BUSplashAdDelegate,BUNativeExpressAdViewDelegate,GDTRewardedVideoAdDelegate,GDTSplashAdDelegate,WindSplashAdDelegate,WindRewardedVideoAdDelegate>

@property (nonatomic,strong) UIViewController *viewController;

@property (nonatomic,strong) BUNativeExpressRewardedVideoAd *rewardedAd;
//BUNativeExpressSplashViewDelegate
//@property (nonatomic,strong) BUNativeExpressSplashView *splashView;

@property (nonatomic,strong) VideoModel *videomodel;

@property (nonatomic,assign) NSInteger loadNum;   //视频拉取次数
//激励视频奖励类型 1：签到  2：看视频领取抽奖券
///  3：抽奖宝箱领取金币 4：看视频领取金币 5：看视频领取复活卡 6：看视频继续挑战  7：看视频复活  8 离线收益
@property (nonatomic,assign) NSInteger rewardeType;

//开屏 视频
@property (nonatomic, assign) CFTimeInterval startTime;

//信息流
@property (nonatomic,strong) BUAdSlot *slot1;
@property (strong, nonatomic) BUNativeExpressAdManager *nativeExpressAdManager;
@property (nonatomic,strong) BUNativeExpressAdView *expressView;
@property (nonatomic,assign) CGFloat videoWidth;
@property (nonatomic,assign) CGFloat videoHeight;
@property (nonatomic,strong) UIView *slotView;
//腾讯
@property (nonatomic,strong) GDTRewardVideoAd *GDTRewardad;
@property (nonatomic,strong) GDTSplashAd *GDTSplashad;

//sigmob
@property (nonatomic,strong) WindSplashAd *splashAd;

@end

@implementation AdHandleManager

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static AdHandleManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AdHandleManager alloc] init];
    });
    return instance;
}

//注册穿山甲
- (void)registerBUAD{
    [BUAdSDKManager setAppID:BU_Appid];
    [BUAdSDKManager setIsPaidApp:NO];
#if DEBUG
    [BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
#endif
}
#pragma mark 激励视频
- (void)RewardedSlotVideoAdViewRender:(VideoModel *)vModel
                            videoType:(NSInteger)videoType viewController:(UIViewController *)vc{
    if (!vModel.videoId) {
        return;
    }
    NSLog(@"激励视频播放渠道:%@",vModel.advertChannel);
    self.videomodel = vModel;
    self.viewController = vc;
    self.rewardeType = videoType;
    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    if ([vModel.advertChannel isEqualToString:BUADVIDEOTYPE]) {   //穿山甲
        BURewardedVideoModel *models = [[BURewardedVideoModel alloc] init];
        models.userId = [NSString stringWithFormat:@"%ld",[PBCache shared].userModel.user_id];
        models.extra = vModel.videoId;
        models.rewardAmount = videoType;
        self.rewardedAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:BU_SlotID rewardedVideoModel:models];
        self.rewardedAd.delegate = self;
        [self.rewardedAd loadAdData];
    }else if ([vModel.advertChannel isEqualToString:TENCENTVIDEOTYPE]){  //腾讯
        self.GDTRewardad = [[GDTRewardVideoAd alloc] initWithAppId:GDTAppId placementId:GDTRewardId];
        self.GDTRewardad.delegate = self;
        self.GDTRewardad.videoMuted = NO; // 设置激励视频是否静音
        [self.GDTRewardad loadAd];
    }else if ([vModel.advertChannel isEqualToString:SIGMOBVIDEOTYPE]){  //sigmob
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            WindAdRequest *request = [WindAdRequest request];
            //userId可选值
            request.userId = [NSString stringWithFormat:@"%ld",[PBCache shared].userModel.user_id];
            //设置delegate
            [[WindRewardedVideoAd sharedInstance] setDelegate:self];
            //执行加载广告
            [[WindRewardedVideoAd sharedInstance] loadRequest:request withPlacementId:SigmobRewardeID];
        });
    }
}
#pragma mark BUADDelegate
- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    [MBProgressHUD hideHUDForView:self.viewController.view];
    if (self.rewardedAd)
    {
        [self.rewardedAd showAdFromRootViewController:self.viewController];
    }
}
- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    [MBProgressHUD hideHUDForView:self.viewController.view];
    
}
- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{
    [MBProgressHUD hideHUDForView:self.viewController.view];
//    [self.delegate BUADVideoFinish:rewardedVideoAd withVideoModel:self.videomodel];
}
- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    [MBProgressHUD hideHUDForView:self.viewController.view];
    [self.delegate BUADVideoFinish:rewardedVideoAd withVideoModel:self.videomodel withType:self.rewardeType];
}

#pragma mark 开屏 启动页
- (void)playSplashVideoWithBUAD:(UIWindow *)keyWindow{
    CGRect frame = [UIScreen mainScreen].bounds;
    BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:BU_OpenID frame:frame];
    // tolerateTimeout = CGFLOAT_MAX , The conversion time to milliseconds will be equal to 0
    splashView.tolerateTimeout = 3;
    splashView.delegate = self;
    splashView.delegate = self;
    splashView.tolerateTimeout = 3;
    [splashView loadAdData];
    [keyWindow.rootViewController.view addSubview:splashView];
    self.startTime = CACurrentMediaTime();
    [keyWindow.rootViewController.view addSubview:splashView];
    
//    self.splashView = [[BUNativeExpressSplashView alloc] initWithSlotID:BU_OpenID adSize:frame.size rootViewController:keyWindow.rootViewController];
//    self.splashView.delegate = self;
//    self.splashView.tolerateTimeout = 3;
//    [self.splashView loadAdData];
//    [keyWindow.rootViewController.view addSubview:self.splashView];
    
}
//- (void)nativeExpressSplashView:(nonnull BUNativeExpressSplashView *)splashAdView didFailWithError:(NSError * _Nullable)error {
//    [self.splashView removeSplashView];//记得在remove广告视图前调用remove方法，否则可能出现倒计时有问题或者视频播放有问题
//    [self.splashView removeFromSuperview];
//    self.splashView = nil;
//    NSLog(@"%s",__func__);
//    NSLog(@"error code : %ld , error message : %@",(long)error.code,error.description);
//}
//- (void)nativeExpressSplashViewRenderFail:(nonnull BUNativeExpressSplashView *)splashAdView error:(NSError * _Nullable)error {
//    [self.splashView removeSplashView];//记得在remove广告视图前调用remove方法，否则可能出现倒计时有问题或者视频播放有问题
//    [self.splashView removeFromSuperview];
//    self.splashView = nil;
//    NSLog(@"%s",__func__);
//}
//- (void)nativeExpressSplashViewDidClose:(nonnull BUNativeExpressSplashView *)splashAdView {
//    [self.splashView removeSplashView];//记得在remove广告视图前调用remove方法，否则可能出现倒计时有问题或者视频播放有问题
//    [self.splashView removeFromSuperview];
//    self.splashView = nil;
//    NSLog(@"%s",__func__);
//}


- (void)splashAdCountdownToZero:(BUSplashAdView *)splashAd{
    [splashAd removeFromSuperview];
    LFLog(@"广告倒计时为0");
}
- (void)splashAdDidClose:(BUSplashAdView *)splashAd{
    [splashAd removeFromSuperview];
    CFTimeInterval endTime = CACurrentMediaTime();
    LFLog(@"Total Runtime: %g s", endTime - self.startTime);
}
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error {
    [splashAd removeFromSuperview];
    CFTimeInterval endTime = CACurrentMediaTime();
    LFLog(@"Total Runtime: %g s error=%@", endTime - self.startTime, error);
}
- (void)splashAdWillVisible:(BUSplashAdView *)splashAd {
    CFTimeInterval endTime = CACurrentMediaTime();
    LFLog(@"Total Showtime: %g s", endTime - self.startTime);
}

#pragma mark 信息流
- (void)loadNativeAdsWithWidth:(CGFloat)width height:(CGFloat)height view:(UIView *)slotview viewController:(UIViewController *)viewController{
    self.videoWidth = width;
    self.videoHeight = height;
    self.slot1 = [[BUAdSlot alloc] init];
    self.slot1.ID = BU_InformationID;
    self.slot1.AdType = BUAdSlotAdTypeFeed;
    self.slot1.position = BUAdSlotPositionFeed;
    BUSize *size = [[BUSize alloc] init];
    size.width = width;
    size.height = height;
    self.slot1.imgSize = size;
    self.slot1.isSupportDeepLink = YES;
    if (!self.nativeExpressAdManager) {
        self.nativeExpressAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:self.slot1 adSize:CGSizeMake(width, height)];
    }
    self.nativeExpressAdManager.delegate = self;
    [self.nativeExpressAdManager loadAd:1];
    self.slotView = slotview;
    self.viewController = viewController;
}
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAd views:(NSArray<__kindof BUNativeExpressAdView *> *)views{
    if (views.count) {
//        self.expressView = [[BUNativeExpressAdView alloc] initWithFrame:CGRectMake(0, 0, self.videoWidth, self.videoHeight)];
//        self.expressView = (BUNativeExpressAdView *)views[0];
//        [self.slotView addSubview:self.expressView];
//        [self.expressView render];
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.expressView = [[BUNativeExpressAdView alloc] initWithFrame:CGRectMake(0, 0, self.videoWidth, self.videoHeight)];
            self.expressView = (BUNativeExpressAdView *)obj;
            [self.slotView addSubview:self.expressView];
            self.expressView.rootViewController = self.viewController;
            [self.expressView render];
        }];
    }
}
- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *)error {
    NSLog(@"error code : %ld , error message : %@",(long)error.code,error.description);
    [self.delegate BUADSlotVideoLoadFail];
}

- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"====== %p videoDuration = %ld,,,,,,,,,%@",nativeExpressAdView,(long)nativeExpressAdView.videoDuration,self.viewController);
    //信息流视频出现
    [self.delegate BUADSlotVideoLoadSuccess];
}

- (void)updateCurrentPlayedTime {
    
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView stateDidChanged:(BUPlayerPlayState)playerState {
    NSLog(@"====== %p playerState = %ld",nativeExpressAdView,playerState);
}

- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
    
}

- (void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView {
    
}

- (void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView {
    
}

- (void)nativeExpressAdViewPlayerDidPlayFinish:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
    
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords {//【重要】需要在点击叉以后 在这个回调中移除视图，否则，会出现用户点击叉无效的情况
    [self.expressView removeFromSuperview];
    [self.slotView removeFromSuperview];
}

- (void)nativeExpressAdViewDidClosed:(BUNativeExpressAdView *)nativeExpressAdView {
    
}

- (void)nativeExpressAdViewWillPresentScreen:(BUNativeExpressAdView *)nativeExpressAdView {
    
}

- (void)nativeExpressAdViewDidCloseOtherController:(BUNativeExpressAdView *)nativeExpressAdView interactionType:(BUInteractionType)interactionType {
    NSString *str = nil;
    if (interactionType == BUInteractionTypePage) {
        str = @"ladingpage";
    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
        str = @"videoDetail";
    } else {
        str = @"appstoreInApp";
    }
    NSLog(@"%s __ %@",__func__,str);
}

#pragma mark 腾讯视频
//注册腾讯视频
- (void)registerGDTAD{
//    BOOL result = [GDTSDKConfig registerAppId:GDTAppId];
//    if (result) {
//        NSLog(@"腾讯视频注册成功");
//    }else{
//        NSLog(@"腾讯视频注册失败");
//    }
}
#pragma mark 腾讯开屏
- (void)playSplashVideoWithGDT{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.GDTSplashad = [[GDTSplashAd alloc] initWithAppId:GDTAppId placementId:GDTSplashId];
        self.GDTSplashad.delegate = self; //设置代理
        self.GDTSplashad.fetchDelay = 3; //开发者可以设置开屏拉取时间，超时则放弃展示=
        [self.GDTSplashad loadAdAndShowInWindow:[UIApplication sharedApplication].keyWindow];
    }
}
#pragma mark 腾讯开屏回调
//开屏广告成功展示
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
    NSLog(@"腾讯开屏广告成功展示");
}
//开屏广告关闭回调
- (void)splashAdClosed:(GDTSplashAd *)splashAd{
    self.GDTSplashad = nil;
}

#pragma mark 腾讯激励视频回调
//激励视频广告加载广告数据成功回调
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd{
    NSLog(@"腾讯激励视频");
    [MBProgressHUD hideHUDForView:self.viewController.view];
    if (self.GDTRewardad)
    {
        [self.GDTRewardad showAdFromRootViewController:self.viewController];
    }
}
//激励视频数据下载成功回调，已经下载过的视频会直接回调
- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd{
    
}
//激励视频播放页即将展示回调
- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd{
    
}
//激励视频广告曝光回调
- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd{
    
}
//激励视频广告播放页关闭回调
- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd{
    [MBProgressHUD hideHUDForView:self.viewController.view];
    [self.delegate BUADVideoFinish:rewardedVideoAd withVideoModel:self.videomodel withType:self.rewardeType];
}
//激励视频广告信息点击回调
- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd{
    
}
//激励视频广告各种错误信息回调
- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.viewController.view];
}
//激励视频广告播放达到激励条件回调，以此回调作为奖励依据
- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd{
    
}
//激励视频广告播放完成回调
- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd{
    [MBProgressHUD hideHUDForView:self.viewController.view];
}

#pragma mark sigmob
- (void)registerSigmob{
    //appkey 3466a7994c66e911
    //应用id 4493
    WindAdOptions *options = [WindAdOptions options];
    options.appId = SigmobAPPID;
    options.apiKey = SigmobAPPKEY;
    [WindAds startWithOptions:options];
}
//sigmob开屏广告
- (void)showSigmobSplashAd{
    //2. 开屏广告初始化并展示代码
    self.splashAd = [[WindSplashAd alloc] initWithPlacementId:SigmobSplashID];
    self.splashAd.delegate = self;
    self.splashAd.fetchDelay = 3;////开发者可以设置开屏拉取时间，超时则放弃展

    //[可选]拉取并展示全屏开屏广告
    [self.splashAd loadAdAndShow];
}
#pragma mark SigmobSplashDelegate
//开屏广告成功展示
- (void)onSplashAdSuccessPresentScreen:(WindSplashAd *)splashAd{
    NSLog(@"sigmob开屏广告展示成功");
}
//开屏广告展示失败
- (void)onSplashAdFailToPresent:(WindSplashAd *)splashAd withError:(NSError *)error{
    NSLog(@"sigmob开屏广告展示失败:%@",error);
}
/**
 *  开屏广告点击回调
 */
- (void)onSplashAdClicked:(WindSplashAd *)splashAd{
    NSLog(@"sigmob开屏广告点击");
}
/**
 *  开屏广告将要关闭回调
 */
- (void)onSplashAdWillClosed:(WindSplashAd *)splashAd{
    NSLog(@"sigmob开屏广告关闭");
}
/**
 *  开屏广告关闭回调（可在开屏关闭时释放开屏对象）
 */
- (void)onSplashAdClosed:(WindSplashAd *)splashAd{
    NSLog(@"sigmob开屏广告关闭(可在开屏关闭时释放开屏对象)");
    self.splashAd = nil;
}
#pragma mark SigmobRewardeDelegate
/**
 激励视频广告AdServer返回广告

 @param placementId 广告位Id
 */
- (void)onVideoAdServerDidSuccess:(NSString *)placementId{
    
}
/**
 激励视频广告AdServer无广告返回
 表示无广告填充

 @param placementId 广告位Id
 */
- (void)onVideoAdServerDidFail:(NSString *)placementId{
    [MBProgressHUD hideHUDForView:self.viewController.view];
    NSLog(@"sigmob激励视频无广告返回");
}
/**
 激励视频广告物料加载成功(此时isReady=YES)
 广告是否加载完成请以改回调为准

 @param placementId 广告位Id
 */
-(void)onVideoAdLoadSuccess:(NSString * _Nullable)placementId{
    [MBProgressHUD hideHUDForView:self.viewController.view];
    NSLog(@"sigmob激励视频广告物料加载成功");
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[WindRewardedVideoAd sharedInstance] playAd:self.viewController withPlacementId:SigmobRewardeID options:nil error:nil];
//    });
}

/**
 激励视频广告开始播放

 @param placementId 广告位Id
 */
-(void)onVideoAdPlayStart:(NSString * _Nullable)placementId{
    
}

/**
 激励视频广告视频播放完毕

 @param placementId 广告位Id
 */
- (void)onVideoAdPlayEnd:(NSString *)placementId{
    NSLog(@"sigmob激励视频广告视频播放完毕");
    [MBProgressHUD hideHUDForView:self.viewController.view];
}

/**
 激励视频广告发生点击

 @param placementId 广告位Id
 */
-(void)onVideoAdClicked:(NSString * _Nullable)placementId{
    
}

/**
 激励视频广告关闭

 @param info WindRewardInfo里面包含一次广告关闭中的是否完整观看等参数
 @param placementId 广告位Id
 */
- (void)onVideoAdClosedWithInfo:(WindRewardInfo * _Nullable)info placementId:(NSString * _Nullable)placementId{
    NSLog(@"sigmob激励视频广告关闭");
    [self.delegate BUADVideoFinish:info withVideoModel:self.videomodel withType:self.rewardeType];
}


/**
 激励视频广告发生错误

 @param error 发生错误时会有相应的code和message
 @param placementId 广告位Id
 */
-(void)onVideoError:(NSError *)error placementId:(NSString * _Nullable)placementId{
    NSLog(@"sigmob激励视频广告发生错误");
    [MBProgressHUD hideHUDForView:self.viewController.view];
}


/**
 激励视频广告调用播放时发生错误

 @param error 发生错误时会有相应的code和message
 @param placementId 广告位Id
 */
-(void)onVideoAdPlayError:(NSError *)error placementId:(NSString * _Nullable)placementId{
    
}

@end
