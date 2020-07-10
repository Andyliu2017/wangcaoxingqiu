//
//  ShiMingView.m
//  wangcao
//
//  Created by EDZ on 2020/6/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import "ShiMingView.h"

@interface ShiMingView()

@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UILabel *realNameLabel;
@property (nonatomic,strong) UILabel *idCardLabel;
@property (nonatomic,strong) UILabel *alipayLabel;

@end

@implementation ShiMingView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubview];
    }
    return self;
}

- (void)setSubview{
    self.whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView.clipsToBounds = YES;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(400));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(620));
        make.height.mas_equalTo(ANDY_Adapta(436));
    }];
    
    UILabel *realName = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:RGBA(101, 101, 101, 1) text:@"真实姓名：" Radius:0];
    [self.whiteView addSubview:realName];
    [realName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(80));
        make.top.mas_equalTo(ANDY_Adapta(80));
        make.height.mas_equalTo(ANDY_Adapta(40));
    }];
    self.realNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:RGBA(101, 101, 101, 1) text:@"" Radius:0];
    [self.whiteView addSubview:self.realNameLabel];
    [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(realName.mas_right);
        make.top.and.height.mas_equalTo(realName);
    }];
    
    UILabel *idCard = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:RGBA(101, 101, 101, 1) text:@"身份证号：" Radius:0];
    [self.whiteView addSubview:idCard];
    [idCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.height.mas_equalTo(realName);
        make.top.mas_equalTo(realName.mas_bottom).offset(ANDY_Adapta(35));
    }];
    self.idCardLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:RGBA(101, 101, 101, 1) text:@"" Radius:0];
    [self.whiteView addSubview:self.idCardLabel];
    [self.idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.height.mas_equalTo(self.realNameLabel);
        make.top.mas_equalTo(idCard.mas_top);
    }];
    
    UILabel *alipay = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:RGBA(101, 101, 101, 1) text:@"支付宝账号：" Radius:0];
    [self.whiteView addSubview:alipay];
    [alipay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.height.mas_equalTo(idCard);
        make.top.mas_equalTo(idCard.mas_bottom).offset(ANDY_Adapta(35));
    }];
    
    self.alipayLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:RGBA(101, 101, 101, 1) text:@"" Radius:0];
    [self.whiteView addSubview:self.alipayLabel];
    [self.alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.height.mas_equalTo(self.idCardLabel);
        make.top.mas_equalTo(alipay.mas_top);
    }];
    
    UIButton *cancelBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(16) normalColor:RGBA(101, 101, 101, 1) normalText:@"取消" click:^(id  _Nonnull x) {
        [self.delegate cancelAction];
    }];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [self.whiteView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(self.whiteView);
        make.width.mas_equalTo(ANDY_Adapta(310));
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    
    UIButton *comfireBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(16) normalColor:[UIColor whiteColor] normalText:@"确定" click:^(id  _Nonnull x) {
        [self.delegate comfireAction:self.realNameLabel.text idcard:self.idCardLabel.text alipay:self.alipayLabel.text];
    }];
    [comfireBtn setBackgroundColor:RGBA(253, 171, 55, 1)];
    [self.whiteView addSubview:comfireBtn];
    [comfireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancelBtn.mas_right);
        make.bottom.and.right.mas_equalTo(self.whiteView);
        make.height.mas_equalTo(cancelBtn);
    }];
}

- (void)setData:(NSString *)name idcard:(NSString *)idcard alipaystr:(NSString *)alipay{
    self.realNameLabel.text = name;
    self.idCardLabel.text = idcard;
    self.alipayLabel.text = alipay;
}

- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.whiteView];
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
