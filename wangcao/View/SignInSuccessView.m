//
//  SignInSuccessView.m
//  wangcao
//
//  Created by EDZ on 2020/5/21.
//  Copyright © 2020 andy. All rights reserved.
//

#import "SignInSuccessView.h"

@interface SignInSuccessView()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *signLabel1;
@property (nonatomic,strong) UILabel *signLabel2;

@end

@implementation SignInSuccessView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubView];
    }
    return self;
}
- (void)setSubView{
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(spaceHeight(237));
        make.top.mas_equalTo(spaceHeight(350));
        make.left.mas_equalTo(ANDY_Adapta(105));
        make.width.mas_equalTo(ANDY_Adapta(587));
        make.height.mas_equalTo(ANDY_Adapta(651));
    }];
    
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.contentView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(ANDY_Adapta(540));
        make.height.mas_equalTo(ANDY_Adapta(480));
    }];
    
    UIImageView *headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_success_head"]];
    [self.contentView addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(54));
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(412));
        make.height.mas_equalTo(ANDY_Adapta(295));
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"signin_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.mas_equalTo(self.contentView);
        make.width.and.height.mas_equalTo(ANDY_Adapta(53));
    }];
    
    self.signLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(14) textColor:MessageColor text:@"" Radius:0];
    [whiteView addSubview:self.signLabel1];
    [self.signLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImg.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(whiteView);
        make.height.mas_equalTo(ANDY_Adapta(53));
    }];
    
    self.signLabel2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(16) textColor:TitleColor text:@"恭喜你，获得" Radius:0];
    [whiteView addSubview:self.signLabel2];
    [self.signLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signLabel1.mas_bottom);
        make.centerX.mas_equalTo(whiteView);
        make.height.mas_equalTo(ANDY_Adapta(59));
    }];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"signin_success_btn"] forState:UIControlStateNormal];
    [commitBtn setTitle:@"朕知道了" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.titleLabel.font = FontBold_(16);
    [whiteView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signLabel2.mas_bottom).offset(ANDY_Adapta(25));
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(340));
        make.height.mas_equalTo(ANDY_Adapta(100));
    }];
}

- (void)setDataContinuNum:(NSInteger)continuNum reward:(NSInteger)reward rewardType:(NSString *)rewardType{
    self.signLabel1.text = [NSString stringWithFormat:@"已成功签到%ld天",continuNum];
    self.signLabel2.text = [NSString stringWithFormat:@"恭喜你，获得%ld%@",reward,rewardType];
}

- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.contentView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
//    [ViewController.view addSubview:self];
    
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
//关闭弹窗
- (void)closeAction{
    
    [UIView animateWithDuration:0.6f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
}

@end
