//
//  BindInvitaView.m
//  wangcao
//
//  Created by EDZ on 2020/5/25.
//  Copyright © 2020 andy. All rights reserved.
//

#import "BindInvitaView.h"

@interface BindInvitaView()

@property (nonatomic,strong) UIView *bindView;
@property (nonatomic,strong) UITextField *bindTextField;

@end

@implementation BindInvitaView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubView];
    }
    return self;
}
- (void)setSubView{
    self.bindView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:self.bindView];
    [self.bindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(spaceHeight(350));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(620));
        make.height.mas_equalTo(ANDY_Adapta(523));
    }];
    UIView *bgView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(254, 172, 56, 1) alpha:1.0 cornerRadius:ANDY_Adapta(13) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.bindView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.bindView);
        make.height.mas_equalTo(ANDY_Adapta(450));
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bindView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(self.bindView);
    }];
    
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(13) borderWidth:ANDY_Adapta(3) borderColor:RGBA(196, 115, 42, 1)];
    [bgView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(bgView);
        make.width.mas_equalTo(ANDY_Adapta(580));
        make.height.mas_equalTo(ANDY_Adapta(410));
    }];
    
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(20) textColor:TitleColor text:@"绑定邀请码" Radius:0];
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(50));
        make.centerX.mas_equalTo(whiteView);
    }];
    
    self.bindTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.bindTextField.placeholder = @"请输入您的邀请码";
    self.bindTextField.textColor = TitleColor;
    self.bindTextField.font = FontBold_(14);
    [whiteView addSubview:self.bindTextField];
    [self.bindTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(ANDY_Adapta(50));
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(500));
        make.height.mas_equalTo(ANDY_Adapta(40));
    }];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = LineColor;
    [whiteView addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.bindTextField);
        make.top.mas_equalTo(self.bindTextField.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn addTarget:self action:@selector(bindAction) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = FontBold_(17);
    [whiteView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView);
        make.top.mas_equalTo(lineImg.mas_bottom).offset(ANDY_Adapta(50));
    }];
}
//绑定邀请码
- (void)bindAction{
    if (![self.bindTextField.text isNotBlank]) {
        [MBProgressHUD showText:@"请输入您的邀请码" toView:self afterDelay:2.0];
        return;
    }
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiBindInviteCode:self.bindTextField.text] subscribeNext:^(id  _Nullable x) {
        //绑定成功  刷新战队页面
        self.bindblock();
        [self closeAction];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)closeAction{
    [UIView animateWithDuration:0.6f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.bindView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
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
