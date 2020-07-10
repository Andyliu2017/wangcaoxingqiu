//
//  ReferView.m
//  wangcao
//
//  Created by EDZ on 2020/5/27.
//  Copyright © 2020 andy. All rights reserved.
//

#import "ReferView.h"

@interface ReferView()

@property (nonatomic,strong) UIView *referView;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UIImageView *headImg;  //头像
@property (nonatomic,strong) UILabel *nickNameLabel;   //昵称
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *wechatLabel;
@property (nonatomic,strong) UILabel *qqLabel;
//直邀好友
@property (nonatomic,strong) UILabel *zhiyaoLabel;
//扩散好友
@property (nonatomic,strong) UILabel *kuosanLabel;

@end

@implementation ReferView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubview];
    }
    return self;
}

- (void)setSubview{
    self.referView = [[UIView alloc] init];
    [self addSubview:self.referView];
    [self.referView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(ANDY_Adapta(350));
        make.width.mas_equalTo(ANDY_Adapta(620));
        make.height.mas_equalTo(ANDY_Adapta(705));
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.referView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(self.referView);
    }];
    
    UIView *yellowView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(254, 172, 56, 1) alpha:1.0 cornerRadius:ANDY_Adapta(13) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.referView addSubview:yellowView];
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.referView);
        make.height.mas_equalTo(ANDY_Adapta(632));
    }];
    
    self.whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(13) borderWidth:0 borderColor:[UIColor clearColor]];
    [yellowView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(yellowView);
        make.width.mas_equalTo(ANDY_Adapta(580));
        make.height.mas_equalTo(ANDY_Adapta(590));
    }];
    
}
#pragma mark 我的邀请人
- (void)setRefreUserView{
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(16) textColor:TitleColor text:@"我的邀请人" Radius:0];
    [self.whiteView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(ANDY_Adapta(43));
    }];
    
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.cornerRadius = ANDY_Adapta(60);
    self.headImg.layer.masksToBounds = YES;
    [self.whiteView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(ANDY_Adapta(20));
        make.width.and.height.mas_equalTo(ANDY_Adapta(120));
    }];
    
    self.nickNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(ANDY_Adapta(25));
    }];
    
    UIImageView *wechatImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_wechat"]];
    [self.whiteView addSubview:wechatImg];
    [wechatImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(50));
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).offset(ANDY_Adapta(30));
    }];
    
    UIButton *wechatBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(12) normalColor:[UIColor whiteColor] normalText:@"复制" click:^(id  _Nonnull x) {
        [self pasteWechat];
    }];
    [wechatBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    wechatBtn.layer.cornerRadius = ANDY_Adapta(24);
    wechatBtn.layer.masksToBounds = YES;
    [self.whiteView addSubview:wechatBtn];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.whiteView.mas_right).offset(-ANDY_Adapta(40));
        make.centerY.mas_equalTo(wechatImg);
        make.width.mas_equalTo(ANDY_Adapta(107));
        make.height.mas_equalTo(ANDY_Adapta(48));
    }];
    
    self.wechatLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView addSubview:self.wechatLabel];
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wechatImg.mas_left).offset(ANDY_Adapta(20));
        make.centerY.mas_equalTo(wechatImg);
    }];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = RGBA(238, 238, 238, 1);
    [self.whiteView addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(wechatImg.mas_bottom).offset(ANDY_Adapta(35));
        make.width.mas_equalTo(ANDY_Adapta(500));
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UIImageView *qqImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_qq"]];
    [self.whiteView addSubview:qqImg];
    [qqImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(wechatImg);
        make.top.mas_equalTo(lineImg.mas_bottom).offset(ANDY_Adapta(35));
    }];
    UIButton *qqBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(12) normalColor:[UIColor whiteColor] normalText:@"复制" click:^(id  _Nonnull x) {
        [self pasteQQ];
    }];
    [qqBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    qqBtn.layer.cornerRadius = ANDY_Adapta(24);
    qqBtn.layer.masksToBounds = YES;
    [self.whiteView addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(qqImg);
        make.centerX.and.width.and.height.mas_equalTo(wechatBtn);
        make.width.mas_equalTo(ANDY_Adapta(107));
        make.height.mas_equalTo(ANDY_Adapta(48));
    }];
    self.qqLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView addSubview:self.qqLabel];
    [self.qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wechatLabel.mas_left);
        make.centerY.mas_equalTo(qqImg);
    }];
}
- (void)setRefreUserData:(UserTeamModel *)model{
    [self.headImg setImageWithURL:[NSURL URLWithString:model.referUser.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.nickNameLabel.text = model.referUser.nickName;
    self.wechatLabel.text = model.referUser.wx;
    self.qqLabel.text = model.referUser.qq;
}


#pragma mark 我的好友
- (void)setFriendView{
    UIImageView *titleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_friend"]];
    [self.whiteView addSubview:titleImg];
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(ANDY_Adapta(43));
    }];
    
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.cornerRadius = ANDY_Adapta(60);
    self.headImg.layer.masksToBounds = YES;
    [self.whiteView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(titleImg.mas_bottom).offset(ANDY_Adapta(20));
        make.width.and.height.mas_equalTo(ANDY_Adapta(120));
    }];
    
    self.nickNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(ANDY_Adapta(25));
    }];
    
    UIImageView *wechatImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_wechat"]];
    [self.whiteView addSubview:wechatImg];
    [wechatImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(50));
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).offset(ANDY_Adapta(30));
    }];
    
    UIButton *wechatBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(12) normalColor:[UIColor whiteColor] normalText:@"复制" click:^(id  _Nonnull x) {
        [self pasteWechat];
    }];
    [wechatBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    wechatBtn.layer.cornerRadius = ANDY_Adapta(24);
    wechatBtn.layer.masksToBounds = YES;
    [self.whiteView addSubview:wechatBtn];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.whiteView.mas_right).offset(-ANDY_Adapta(40));
        make.centerY.mas_equalTo(wechatImg);
        make.width.mas_equalTo(ANDY_Adapta(107));
        make.height.mas_equalTo(ANDY_Adapta(48));
    }];
    
    self.wechatLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView addSubview:self.wechatLabel];
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wechatImg.mas_right).offset(ANDY_Adapta(20));
        make.centerY.mas_equalTo(wechatImg);
    }];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = RGBA(238, 238, 238, 1);
    [self.whiteView addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(wechatImg.mas_bottom).offset(ANDY_Adapta(25));
        make.width.mas_equalTo(ANDY_Adapta(500));
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UIImageView *qqImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_qq"]];
    [self.whiteView addSubview:qqImg];
    [qqImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(wechatImg);
        make.top.mas_equalTo(lineImg.mas_bottom).offset(ANDY_Adapta(25));
    }];
    UIButton *qqBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(12) normalColor:[UIColor whiteColor] normalText:@"复制" click:^(id  _Nonnull x) {
        [self pasteQQ];
    }];
    [qqBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    qqBtn.layer.cornerRadius = ANDY_Adapta(24);
    qqBtn.layer.masksToBounds = YES;
    [self.whiteView addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(qqImg);
        make.centerX.and.width.and.height.mas_equalTo(wechatBtn);
        make.width.mas_equalTo(ANDY_Adapta(107));
        make.height.mas_equalTo(ANDY_Adapta(48));
    }];
    
    self.qqLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView addSubview:self.qqLabel];
    [self.qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wechatLabel.mas_left);
        make.centerY.mas_equalTo(qqImg);
    }];
    
    self.zhiyaoLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:GrayColor text:@"直邀好友：" Radius:0];
    [self.whiteView addSubview:self.zhiyaoLabel];
    [self.zhiyaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(qqImg.mas_left);
        make.top.mas_equalTo(qqImg.mas_bottom).offset(ANDY_Adapta(45));
    }];
    
    self.kuosanLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:GrayColor text:@"扩散好友：" Radius:0];
    [self.whiteView addSubview:self.kuosanLabel];
    [self.kuosanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(qqBtn.mas_right);
        make.top.mas_equalTo(self.zhiyaoLabel.mas_top);
    }];
}
- (void)setFriendData:(TeamNumberModel *)model{
    self.nickNameLabel.text = model.nickName;
    [self.headImg setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.wechatLabel.text = model.wx;
    self.qqLabel.text = model.qq;
    self.zhiyaoLabel.text = [NSString stringWithFormat:@"直邀好友：%ld",model.directCount];
    self.kuosanLabel.text = [NSString stringWithFormat:@"扩散好友：%ld",model.indirectCount];
}

#pragma mark 复制方法
- (void)pasteWechat{
    if ([self.wechatLabel.text isNotBlank]) {
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = self.wechatLabel.text;
        [MBProgressHUD showText:@"复制微信号成功" toView:[UIApplication sharedApplication].keyWindow afterDelay:1.0];
    }
}
- (void)pasteQQ{
    if ([self.qqLabel.text isNotBlank]) {
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = self.qqLabel.text;
        [MBProgressHUD showText:@"复制QQ号成功" toView:[UIApplication sharedApplication].keyWindow afterDelay:1.0];
    }
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
    [self showWithAlert:self.referView];
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
