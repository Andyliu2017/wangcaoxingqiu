//
//  QQWechatView.m
//  wangcao
//
//  Created by EDZ on 2020/5/27.
//  Copyright © 2020 andy. All rights reserved.
//

#import "QQWechatView.h"

@interface QQWechatView()

@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UITextField *wechatField;
@property (nonatomic,strong) UITextField *qqField;

@end

@implementation QQWechatView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(ANDY_Adapta(350));
        make.width.mas_equalTo(ANDY_Adapta(620));
        make.height.mas_equalTo(ANDY_Adapta(503));
    }];
    
    UILabel *title = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:TitleColor text:@"请先填写您的信息" Radius:0];
    [self.whiteView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(ANDY_Adapta(50));
    }];
    
    self.wechatField = [[UITextField alloc] init];
    self.wechatField.textColor = GrayColor;
    self.wechatField.font = Font_(14);
    [self.whiteView addSubview:self.wechatField];
    [self.wechatField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(ANDY_Adapta(50));
        make.right.mas_equalTo(self.whiteView.mas_right).offset(-ANDY_Adapta(13));
        make.width.mas_equalTo(ANDY_Adapta(368));
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
    
    UIImageView *wechatImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_wechat"]];
    [self.whiteView addSubview:wechatImg];
    [wechatImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.wechatField);
        make.left.mas_equalTo(ANDY_Adapta(50));
    }];
    UILabel *wechatLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:TitleColor text:@"微信号" Radius:0];
    [self.whiteView addSubview:wechatLabel];
    [wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.wechatField);
        make.left.mas_equalTo(wechatImg.mas_right).offset(ANDY_Adapta(5));
    }];
    
    self.qqField = [[UITextField alloc] init];
    self.qqField.textColor = GrayColor;
    self.qqField.font = Font_(14);
    [self.whiteView addSubview:self.qqField];
    [self.qqField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.height.mas_equalTo(self.wechatField);
        make.top.mas_equalTo(self.wechatField.mas_bottom).offset(ANDY_Adapta(35));
    }];
    UIImageView *qqImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_qq"]];
    [self.whiteView addSubview:qqImg];
    [qqImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(wechatImg);
        make.centerY.mas_equalTo(self.qqField);
    }];
    UILabel *qqLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:TitleColor text:@"QQ号" Radius:0];
    [self.whiteView addSubview:qqLabel];
    [qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(qqImg);
        make.left.mas_equalTo(wechatLabel.mas_left);
    }];
    
    UILabel *descLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:GrayColor text:@"* 只有准确填写微信或QQ才能查看他人信息。" Radius:0];
    [self.whiteView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(qqImg.mas_left);
        make.top.mas_equalTo(qqImg.mas_bottom).offset(ANDY_Adapta(50));
    }];
    
    UIButton *cancelBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(16) normalColor:GrayColor normalText:@"取消" click:^(id  _Nonnull x) {
        [self closeAction];
    }];
    [self.whiteView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(self.whiteView);
        make.height.mas_equalTo(ANDY_Adapta(90));
        make.width.mas_equalTo(ANDY_Adapta(310));
    }];
    
    UIButton *comfireBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(16) normalColor:[UIColor whiteColor] normalText:@"保存" click:^(id  _Nonnull x) {
        [self baocunAction];
    }];
    [comfireBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    [self.whiteView addSubview:comfireBtn];
    [comfireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(self.whiteView);
        make.left.mas_equalTo(cancelBtn.mas_right);
        make.height.mas_equalTo(cancelBtn.mas_height);
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

- (void)baocunAction{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiModifyUserInfoWithAvatar:nil nickname:nil qq:self.qqField.text weixin:self.wechatField.text] subscribeNext:^(id  _Nullable x) {
        [self refreshUserInfo];
        [MBProgressHUD showText:@"保存成功" toView:[UIApplication sharedApplication].keyWindow afterDelay:1.0];
        [self closeAction];
    } error:^(NSError * _Nullable error) {
        
    }];
}
//保存成功刷新用户信息
- (void)refreshUserInfo{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserInfo:[PBCache shared].userModel.user_id] subscribeNext:^(UserModel *model) {
        [PBCache shared].userModel = model;
    } error:^(NSError * _Nullable error) {
        
    }];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end
