//
//  SystemContentView.m
//  wangcao
//
//  Created by EDZ on 2020/5/30.
//  Copyright © 2020 andy. All rights reserved.
//

#import "SystemContentView.h"

@interface SystemContentView()

@property (nonatomic,strong) UIView *sysView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIButton *commitBtn;
@property (nonatomic,strong) UIScrollView *contentScroll;
@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation SystemContentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubview];
    }
    return self;
}

- (void)setSubview{
    self.sysView = [[UIView alloc] init];
    [self addSubview:self.sysView];
    [self.sysView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(spaceHeight(350));
        make.width.mas_equalTo(ANDY_Adapta(620));
        make.height.mas_equalTo(ANDY_Adapta(750));
    }];
    
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.sysView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.sysView);
        make.height.mas_equalTo(ANDY_Adapta(585));
    }];
    
    self.headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_head"]];
    [self.sysView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.sysView);
        make.width.mas_equalTo(ANDY_Adapta(474));
        make.height.mas_equalTo(ANDY_Adapta(228));
    }];
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:[UIColor whiteColor] text:@"系统公告" Radius:0];
    [self.sysView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImg.mas_bottom).offset(-ANDY_Adapta(32));
        make.centerX.mas_equalTo(self.headImg);
        make.height.mas_equalTo(ANDY_Adapta(85));
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.sysView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(self.sysView);
    }];
    
    self.commitBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"朕知道了" click:^(id  _Nonnull x) {
        [self closeAction];
    }];
    [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
    [whiteView addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView);
        make.bottom.mas_equalTo(whiteView.mas_bottom).offset(-ANDY_Adapta(50));
    }];
    
    UIScrollView *contentscroll = [[UIScrollView alloc] init];
    contentscroll.bounces = NO;
    contentscroll.showsVerticalScrollIndicator = NO;
    [whiteView addSubview:contentscroll];
    [contentscroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(ANDY_Adapta(50));
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(580));
        make.bottom.mas_equalTo(self.commitBtn.mas_top).offset(-ANDY_Adapta(15));
    }];
    self.contentScroll = contentscroll;
    
    self.contentLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:Font_(14) textColor:TitleColor text:@"" Radius:0];
    [self.contentScroll addSubview:self.contentLabel];
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.mas_equalTo(self.headImg.mas_bottom).offset(ANDY_Adapta(50));
////        make.centerX.mas_equalTo(whiteView);
////        make.width.mas_equalTo(ANDY_Adapta(580));
//        make.left.and.right.and.top.and.bottom.mas_equalTo(self.contentScroll);
//    }];
}

- (void)setContent:(NSString *)contentStr{
    self.contentLabel.text = contentStr;
    CGFloat textHeight = [contentStr boundingRectWithSize:CGSizeMake(ANDY_Adapta(580), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font_(14)} context:nil].size.height;
    self.contentScroll.contentSize = CGSizeMake(ANDY_Adapta(580), textHeight);
    self.contentLabel.frame = CGRectMake(0, 0, ANDY_Adapta(580), textHeight);
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
    [self showWithAlert:self.sysView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:self];
    [ViewController.tabBarController.view addSubview:self];
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
