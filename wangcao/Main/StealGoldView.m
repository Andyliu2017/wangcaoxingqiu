//
//  StealGoldView.m
//  wangcao
//
//  Created by EDZ on 2020/6/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import "StealGoldView.h"

@interface StealGoldView()

@property (nonatomic,strong) UIView *stealGoldView;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *commitBtn;
@property (nonatomic,strong) UILabel *goldLabel;

@end

@implementation StealGoldView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    self.stealGoldView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:self.stealGoldView];
    [self.stealGoldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(spaceHeight(350));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(642));
    }];
    
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.stealGoldView addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(ANDY_Adapta(175));
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(467));
    }];
    self.whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.stealGoldView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(165));
        make.left.and.width.and.height.mas_equalTo(blackView);
    }];
    
    self.headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_head"]];
    [self.stealGoldView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.stealGoldView);
        make.width.mas_equalTo(ANDY_Adapta(474));
        make.height.mas_equalTo(ANDY_Adapta(228));
    }];
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:[UIColor whiteColor] text:@"获得金币" Radius:0];
    [self.stealGoldView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImg.mas_bottom).offset(-ANDY_Adapta(32));
        make.centerX.mas_equalTo(self.headImg);
        make.height.mas_equalTo(ANDY_Adapta(85));
    }];
    
    self.commitBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"朕知道了" click:nil];
    [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
    [self.commitBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commitBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, ANDY_Adapta(10), 0)];
    [self.whiteView addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.bottom.mas_equalTo(self.whiteView.mas_bottom).offset(-ANDY_Adapta(70)); //61
    }];
    self.commitBtn.enabled = NO;
    
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_offline_gold"]];
    [self.whiteView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(120));
        make.bottom.mas_equalTo(self.commitBtn.mas_top).offset(-ANDY_Adapta(40));
        make.width.and.height.mas_equalTo(ANDY_Adapta(100));
    }];
    
    self.goldLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(30) textColor:RGBA(254, 172, 56, 1) text:@"" Radius:0];
    [self.whiteView addSubview:self.goldLabel];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconImg);
        make.left.mas_equalTo(iconImg.mas_right).offset(ANDY_Adapta(15));
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.hidden = YES;
    [self.stealGoldView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(self.stealGoldView);
    }];
}

- (void)setData:(NSInteger)goldNum{
    self.goldLabel.text = [NSString stringWithFormat:@"+%ld金币",goldNum];
}

- (void)setViewBtnStatus{
    self.commitBtn.enabled = YES;
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
        [self removeFromSuperview];
    }];
}
- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.stealGoldView];
    [ViewController.view addSubview:self];
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
