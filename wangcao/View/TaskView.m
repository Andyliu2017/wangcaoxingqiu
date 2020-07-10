//
//  TaskView.m
//  wangcao
//
//  Created by EDZ on 2020/5/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TaskView.h"

@interface TaskView()

@property (nonatomic,strong) UIImageView *bgImg;

@end

@implementation TaskView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self setSubView];
    }
    return self;
}
- (void)setSubView{
    self.bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"task_bg"]];
    self.bgImg.userInteractionEnabled = YES;
    [self addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-ANDY_Adapta(150));
        make.width.mas_equalTo(ANDY_Adapta(660));
        make.height.mas_equalTo(ANDY_Adapta(728));
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"signin_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImg).offset(-ANDY_Adapta(26));
        make.right.mas_equalTo(self.bgImg).offset(-ANDY_Adapta(11));
        make.width.and.height.mas_equalTo(ANDY_Adapta(53));
    }];
}
- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.bgImg];
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
