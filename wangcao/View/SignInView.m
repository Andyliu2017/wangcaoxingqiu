//
//  SignInView.m
//  wangcao
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import "SignInView.h"
#import "SignInConfigModel.h"

#define SignInColor1 RGBA(254, 172, 56, 1)
#define SignInColor2 RGBA(153, 58, 20, 1)

@interface SignInView()

@property (nonatomic,strong) UIImageView *bgImg;
//第一天到第七天的背景
@property (nonatomic,strong) UIImageView *dayOneBg;
@property (nonatomic,strong) UIImageView *dayTwoBg;
@property (nonatomic,strong) UIImageView *dayThreeBg;
@property (nonatomic,strong) UIImageView *dayFourBg;
@property (nonatomic,strong) UIImageView *dayFiveBg;
@property (nonatomic,strong) UIImageView *daySixBg;
@property (nonatomic,strong) UIImageView *daySevenBg;
@property (nonatomic,strong) UIButton *signInBtn;  //签到按钮

@end

@implementation SignInView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubView];
    }
    return self;
}
- (void)setSubView{
    self.bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_bg"]];
    self.bgImg.userInteractionEnabled = YES;
    [self addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
//        make.centerY.mas_equalTo(self).offset(-ANDY_Adapta(150));
        make.top.mas_equalTo(self.mas_top).offset(spaceHeight(350));
        make.width.mas_equalTo(ANDY_Adapta(660));
        make.height.mas_equalTo(ANDY_Adapta(728));
    }];
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"signin_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.hidden = YES;
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImg).offset(-ANDY_Adapta(26));
        make.right.mas_equalTo(self.bgImg).offset(-ANDY_Adapta(11));
        make.width.and.height.mas_equalTo(ANDY_Adapta(53));
    }];
    self.dayOneBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_bg1"]];
    self.dayTwoBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_bg1"]];
    self.dayThreeBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_bg1"]];
    self.dayFourBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_bg1"]];
    self.dayFiveBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_bg1"]];
    self.daySixBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_bg1"]];
    self.daySevenBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_bg2"]];
    //第一天 到 第七天
    NSArray *array1 = @[self.dayOneBg,self.dayTwoBg,self.dayThreeBg,self.dayFourBg,self.dayFiveBg,self.daySixBg,self.daySevenBg];
    NSArray *titleArr = @[@"第一天",@"第二天",@"第三天",@"第四天",@"第五天",@"第六天",@"第七天"];
    NSArray *iconArr = @[@"signin_little",@"signin_mediue",@"signin_card",@"signin_big",@"signin_card",@"signin_more",@"signin_card"];
    for (int i = 0; i < 7; i++) {
        NSInteger num = i / 4;
        NSInteger yushu = i % 4;
        UIImageView *image = array1[i];
        [self.bgImg addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ANDY_Adapta(47)+ANDY_Adapta(145)*yushu);
            make.top.mas_equalTo(ANDY_Adapta(151)+ANDY_Adapta(190)*num);
            make.height.mas_equalTo(ANDY_Adapta(170));
            if (i == 6) {
                make.width.mas_equalTo(ANDY_Adapta(280));
            }else{
                make.width.mas_equalTo(ANDY_Adapta(135));
            }
        }];
        UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(11) textColor:SignInColor1 text:titleArr[i] Radius:0];
        [image addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ANDY_Adapta(8));
            make.left.and.right.mas_equalTo(image);
            make.height.mas_equalTo(ANDY_Adapta(31));
        }];
        //签到奖励icon
        UIImageView *signinIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconArr[i]]];
//        signinIcon.tag = 10+i;
        [image addSubview:signinIcon];
        [signinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(image);
            make.top.mas_equalTo(titleLabel.mas_bottom);
            make.width.and.height.mas_equalTo(ANDY_Adapta(83));
        }];
        UILabel *signinLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(11) textColor:SignInColor2 text:@"" Radius:0];
        signinLabel.tag = 20 + i;
        [image addSubview:signinLabel];
        [signinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.width.mas_equalTo(image);
            make.bottom.mas_equalTo(image.mas_bottom).inset(ANDY_Adapta(2));
            make.height.mas_equalTo(ANDY_Adapta(44));
        }];
        UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(0, 0, 0, 0.35) alpha:1.0 cornerRadius:ANDY_Adapta(13) borderWidth:0 borderColor:[UIColor clearColor]];
        blackView.tag = 100+i;
        blackView.hidden = YES;
        [image addSubview:blackView];
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.and.bottom.mas_equalTo(image);
        }];
        UIImageView *alerdyImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_already"]];
        [blackView addSubview:alerdyImg];
        [alerdyImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.mas_equalTo(signinIcon);
            make.width.and.height.mas_equalTo(ANDY_Adapta(76));
        }];
    }
    //签到按钮
    self.signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signInBtn setBackgroundImage:[UIImage imageNamed:@"signin_btn"] forState:UIControlStateNormal];
    [self.signInBtn addTarget:self action:@selector(signInAction) forControlEvents:UIControlEventTouchUpInside];
    [self.signInBtn setImage:[UIImage imageNamed:@"signin_video"] forState:UIControlStateNormal];
    [self.signInBtn setTitle:@"看视频签到" forState:UIControlStateNormal];
    [self.bgImg addSubview:self.signInBtn];
    [self.signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(ANDY_Adapta(542));
        make.width.mas_equalTo(ANDY_Adapta(456));
        make.height.mas_equalTo(ANDY_Adapta(116));
    }];
}
- (void)initSignInUI{
    if (_isSignIn) {
        [self.signInBtn setTitle:@"今日已签到" forState:UIControlStateNormal];
        [self.signInBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else{
//        if ([PBCache shared].memberModel.userType == 2) {
//            [self.signInBtn setTitle:@"点击签到" forState:UIControlStateNormal];
//            [self.signInBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        }else{
            self.signInBtn.enabled = NO;
            [self.signInBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(10))];
            [self.signInBtn setImage:[UIImage imageNamed:@"signin_video"] forState:UIControlStateNormal];
            [self.signInBtn setTitle:@"看视频签到" forState:UIControlStateNormal];
//        }
    }
    for (int i = 0; i < self.dataArr.count; i++) {
        SignInConfigModel *model = self.dataArr[i];
        UILabel *signinLabel = [self.bgImg viewWithTag:20+i];
        signinLabel.text = [NSString stringWithFormat:@"%@X%ld",[self signInName:model.rewardType],model.reward];
        if (self.continuNum > i) {
            UIView *blackView = [self viewWithTag:100+i];
            blackView.hidden = NO;
        }
    }
}
- (void)setIsSignIn:(BOOL)isSignIn{
    _isSignIn = isSignIn;
}
- (void)setContinuNum:(NSInteger)continuNum{
    _continuNum = continuNum;
}
- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    if (_dataArr.count) {
        [self initSignInUI];
    }
}

- (void)setViewBtnStatus{
    self.signInBtn.enabled = YES;
}

- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.bgImg];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
//    [ViewController.view addSubview:self];
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
//签到
- (void)signInAction{
    if (_isSignIn) {
        return;
    }
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiSignIn] subscribeNext:^(VideoModel *model) {        
//        if ([PBCache shared].memberModel.userType == 2) {
//            [self.delegate SingInNotVideo:model];
//        }else{
            [self.delegate SingInActionBack:model];
//        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
//关闭弹窗
- (void)closeAction{
    if (self.adTimer) {
        dispatch_source_cancel(self.adTimer);
        self.adTimer = nil;
    }
    [UIView animateWithDuration:0.6f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
//签到奖励名字配置  GOLD:金币，REBIRTH_CARD:复活卡，BLESS_BEAN:福豆
- (NSString *)signInName:(NSString *)keyStr{
    if ([keyStr isEqualToString:@"GOLD"]) {
        return @"金币";
    }
    if ([keyStr isEqualToString:@"REBIRTH_CARD"]) {
        return @"复活卡";
    }
    if ([keyStr isEqualToString:@"BLESS_BEAN"]) {
        return @"福豆";
    }
    return @"";
}
- (NSString *)signInIcon:(NSString *)keyStr{
    if ([keyStr isEqualToString:@"GOLD"]) {
        return @"金币";
    }
    if ([keyStr isEqualToString:@"REBIRTH_CARD"]) {
        return @"复活卡";
    }
    if ([keyStr isEqualToString:@"BLESS_BEAN"]) {
        return @"福豆";
    }
    return @"";
}

@end
