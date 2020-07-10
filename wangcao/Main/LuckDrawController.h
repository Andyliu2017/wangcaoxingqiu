//
//  LuckDrawController.h
//  wangcao
//
//  Created by EDZ on 2020/5/9.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NetworkStatus) {
    NetworkStatusUnknown = -1, //未知网络
    NetworkStatusNotReachable = 0, //无网络
    NetworkStatusReachableViaWWAN = 1, //运营商网络
    NetworkStatusReachableViaWiFi = 2, //无线网络

};

@interface LuckDrawController : UIViewController

/**
 * 网络状态，无网络直接提示相应信息
 */
@property (assign, nonatomic) NetworkStatus networkStatus;

/**
 * 图片地址，网络获取
 */
@property (strong, nonatomic) NSMutableArray *urlImageArray;
/**
 * 本地图片数组
 */
@property (strong, nonatomic) NSMutableArray *localImageArray;
/**
 * 停止位置，默认第一个
 */
@property (assign, nonatomic) NSInteger stopCount;
/**
 * 抽奖视图超时时间,默认10秒（以网络请求的超时为主，超时间默认加2以上，用于选中之后的延时弹出提示框带来的影响）
 */
@property (assign, nonatomic) NSInteger timeoutInterval;


//@property (assign, nonatomic) id<DrawPopViewDelegate> delegate;
/**
 * 抽奖次数
 */
@property (assign, nonatomic) NSInteger lotteryNumber;

/**
 * 抽奖失败后提示信息
 */
@property (copy, nonatomic) NSString *failureMessage;

/**
 *抽奖结果提示
 */
- (void)showLotteryResults:(void(^)(NSInteger remainTime))clickSure;

                           
@property (nonatomic,copy) void(^endLotteryResults)(void);

/**
 *视图消失时，清除NSTimer,提前返回时一定要调用
 */
- (void)dismissNSTimer;

@end

NS_ASSUME_NONNULL_END
