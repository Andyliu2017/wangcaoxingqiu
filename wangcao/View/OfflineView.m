//
//  OfflineView.m
//  wangcao
//
//  Created by EDZ on 2020/5/25.
//  Copyright © 2020 andy. All rights reserved.
//

#import "OfflineView.h"

@interface OfflineView()

@property (nonatomic,strong) UIView *offlineView;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UILabel *fotonLabel;
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *goldLabel;
@property (nonatomic,strong) UIButton *commitBtn;

@property (nonatomic,strong) VideoModel *model;
@property (nonatomic,strong) FotonModel *ftModel;
//剩余看视频次数
@property (nonatomic,strong) UILabel *remainNumLabel;

@end

@implementation OfflineView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    self.offlineView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:self.offlineView];
    [self.offlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(spaceHeight(350));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(642));
    }];
    
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.offlineView addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(ANDY_Adapta(175));
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(467));
    }];
    self.whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.offlineView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(165));
        make.left.and.width.and.height.mas_equalTo(blackView);
    }];
    
    self.headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_head"]];
    [self.offlineView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.offlineView);
        make.width.mas_equalTo(ANDY_Adapta(474));
        make.height.mas_equalTo(ANDY_Adapta(228));
    }];
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.offlineView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImg.mas_bottom).offset(-ANDY_Adapta(32));
        make.centerX.mas_equalTo(self.headImg);
        make.height.mas_equalTo(ANDY_Adapta(85));
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.hidden = YES;
    [self.offlineView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(self.offlineView);
    }];
    
    self.commitBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"" click:nil];
    [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
    [self.whiteView addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.bottom.mas_equalTo(self.whiteView.mas_bottom).offset(-ANDY_Adapta(70)); //61
    }];
}
#pragma mark 获取福豆
- (void)setFutonView{
    self.fotonLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(14) textColor:TitleColor text:@"恭喜您获得福豆！" Radius:0];
    [self.whiteView addSubview:self.fotonLabel];
    [self.fotonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(ANDY_Adapta(109));
    }];
    
    self.iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self.whiteView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(181));
        make.top.mas_equalTo(self.fotonLabel.mas_bottom).offset(ANDY_Adapta(45));
    }];
    
    self.goldLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(20) textColor:RGBA(254, 172, 56, 1) text:@"" Radius:0];
    [self.whiteView addSubview:self.goldLabel];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImg);
        make.left.mas_equalTo(self.iconImg.mas_right).offset(ANDY_Adapta(15));
    }];
}
- (void)setFotonData:(FotonModel *)model{
    self.ftModel = model;
    self.titleLabel.text = @"获取福豆";
    self.iconImg.image = [UIImage imageNamed:@"pop_offline_foton"];
    self.goldLabel.text = [NSString stringWithFormat:@"+%ld",model.blessBean];
    [self.commitBtn setTitle:@"朕知道了" forState:UIControlStateNormal];
    [self.commitBtn addTarget:self action:@selector(recevieFoton) forControlEvents:UIControlEventTouchUpInside];
}
//领取福豆
- (void)recevieFoton{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiReceiveFotonWithFotonId:self.ftModel.foton_id] subscribeNext:^(id  _Nullable x) {
        [MBProgressHUD showText:@"福豆领取成功" toView:self.viewController.view afterDelay:1.0];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHGOLDCOINS object:self userInfo:nil];
        [self closeAction];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 离线收益
- (void)setOfflineView{
    self.iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_offline_gold"]];
    [self.whiteView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(181));
        make.bottom.mas_equalTo(self.commitBtn.mas_top).offset(-ANDY_Adapta(72));
        make.width.and.height.mas_equalTo(ANDY_Adapta(100));
    }];
    
    self.goldLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(20) textColor:RGBA(254, 172, 56, 1) text:@"" Radius:0];
    [self.whiteView addSubview:self.goldLabel];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImg);
        make.left.mas_equalTo(self.iconImg.mas_right).offset(ANDY_Adapta(15));
    }];
}
- (void)setOfflineData:(OfflineProfitModel *)model{
    self.model = model.videoAd;
    self.titleLabel.text = @"离线收益";
    NSLog(@"离线收益:%ld",model.videoAdDouble);
    if (model.videoAdDouble > 0) {
//        if ([PBCache shared].memberModel.userType == 2) {
//            [self.commitBtn setTitle:@"朕知道了" forState:UIControlStateNormal];
//            [self.commitBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
//        }else{
            [self.commitBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(10))];
            [self.commitBtn setImage:[UIImage imageNamed:@"signin_video"] forState:UIControlStateNormal];
            [self.commitBtn setTitle:@"看视频奖励翻倍" forState:UIControlStateNormal];
            [self.commitBtn addTarget:self action:@selector(recevieDoubleGold) forControlEvents:UIControlEventTouchUpInside];
            self.commitBtn.enabled = NO;
//        }
    }else{
        [self.commitBtn setTitle:@"朕知道了" forState:UIControlStateNormal];
        [self.commitBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    self.iconImg.image = [UIImage imageNamed:@"sy_offline_gold"];
    self.goldLabel.text = [NSString stringWithFormat:@"+%.0f",model.goldCoin];
}
//看视频领取金币
- (void)recevieDoubleGold{
    [self.delegate offlineGoldDoubleWithVideo:self.model];
}

#pragma mark 金币不足
- (void)setGoldEnoughView{
    self.titleLabel.text = @"金币不足";
    UILabel *label = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(16) textColor:TitleColor text:@"看视频可获取金币" Radius:0];
    [self.whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(ANDY_Adapta(30));
    }];
    self.iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_offline_gold"]];
    [self.whiteView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(181));
        make.bottom.mas_equalTo(self.commitBtn.mas_top).offset(-ANDY_Adapta(40));
        make.width.and.height.mas_equalTo(ANDY_Adapta(100));
    }];
    
    self.goldLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(30) textColor:RGBA(254, 172, 56, 1) text:@"" Radius:0];
    [self.whiteView addSubview:self.goldLabel];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImg);
        make.left.mas_equalTo(self.iconImg.mas_right).offset(ANDY_Adapta(15));
    }];
    
    [self.commitBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(10))];
    [self.commitBtn setImage:[UIImage imageNamed:@"signin_video"] forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
    [self.commitBtn setTitle:@"获取金币" forState:UIControlStateNormal];
    [self.commitBtn addTarget:self action:@selector(watchVideoGetGold) forControlEvents:UIControlEventTouchUpInside];
    self.remainNumLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:GrayColor text:@"每天凌晨/中午12点重置广告次数(剩余次)" Radius:0];
    [self.whiteView addSubview:self.remainNumLabel];
    [self.remainNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commitBtn.mas_bottom).offset(ANDY_Adapta(10));
        make.centerX.mas_equalTo(self.whiteView);
    }];
}
- (void)setgoldEnoughData:(VideoModel *)model{
    self.model = model;
    self.goldLabel.text = model.award;
    self.remainNumLabel.text = [NSString stringWithFormat:@"每天凌晨/中午12点重置广告次数(剩余%ld次)",model.remainNum];
    self.commitBtn.enabled = NO;
}
//看视频获取金币
- (void)watchVideoGetGold{
    [self closeAction];
    [self.delegate goldNotEnoughBack:self.model];
}

#pragma mark 偷取金币弹窗


- (void)setViewBtnStatus{
    if ([self.titleLabel.text isEqualToString:@"金币不足"]) {
        //金币不足弹窗 还有看视频次数
        if (self.model.remainNum > 0) {
            self.commitBtn.enabled = YES;
        }
    }else{
        self.commitBtn.enabled = YES;
    }
}

- (void)closeAction{
    if (self.adTimer) {
        dispatch_source_cancel(self.adTimer);
        self.adTimer = nil;
    }
    [UIView animateWithDuration:0.6f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        if (![self.titleLabel.text isEqualToString:@"获取福豆"]) {
            //给主页一个回调，保证金币不足view被清除干净，否则第二次无金币不足弹窗出现
            [self.delegate offlineViewClose];
        }
        [self removeFromSuperview];
    }];
}
- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.offlineView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [ViewController.view addSubview:self];
    [ViewController.tabBarController.view addSubview:self];
    [self CreateSlotView:ViewController];
}
/**
 添加Alert入场动画
 @param alert 添加动画的View
 */
- (void)showWithAlert:(UIView*)alert
{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.6;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

@end
