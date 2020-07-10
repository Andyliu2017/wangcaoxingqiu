//
//  WatchVideoBattleView.m
//  wangcao
//
//  Created by EDZ on 2020/5/26.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WatchVideoBattleView.h"

@interface WatchVideoBattleView()

@property (nonatomic,strong) UIView *videoView;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIButton *commitBtn;
//广告流水字段
@property (nonatomic,copy) NSString *videoId;

@property (nonatomic,strong) VideoModel *vModel;

@end

@implementation WatchVideoBattleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    self.videoView = [[UIView alloc] init];
    [self addSubview:self.videoView];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(spaceHeight(350));
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(610));
    }];
    
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.videoView addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(ANDY_Adapta(175));
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(440));
    }];
    self.whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.videoView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(165));
        make.left.and.width.and.height.mas_equalTo(blackView);
    }];
    
    self.headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_head"]];
    [self.videoView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.videoView);
        make.width.mas_equalTo(ANDY_Adapta(474));
        make.height.mas_equalTo(ANDY_Adapta(228));
    }];
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:[UIColor whiteColor] text:@"温馨提示" Radius:0];
    [self.videoView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImg.mas_bottom).offset(-ANDY_Adapta(32));
        make.centerX.mas_equalTo(self.headImg);
        make.height.mas_equalTo(ANDY_Adapta(85));
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(self.videoView);
    }];
    
    
    self.commitBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"看视频" click:nil];
    [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
//    if ([PBCache shared].memberModel.userType == 2) {
//        [self.commitBtn setTitle:@"继续" forState:UIControlStateNormal];
//    }else{
        self.commitBtn.enabled = NO;
        [self.commitBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(10))];
        [self.commitBtn setTitle:@"看视频" forState:UIControlStateNormal];
        [self.commitBtn setImage:[UIImage imageNamed:@"pop_videoicon"] forState:UIControlStateNormal];
//    }
    [self.commitBtn addTarget:self action:@selector(watchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.bottom.mas_equalTo(self.whiteView.mas_bottom).offset(-ANDY_Adapta(61));
    }];
    
    UILabel *descLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentCenter font:FontBold_(15) textColor:TitleColor text:@"今日免费入场次数已用完看视频可继续入场" Radius:0];
//    if ([PBCache shared].memberModel.userType == 2) {
//        descLabel.text = @"今日免费入场次数已用完是否继续入场";
//    }else{
        descLabel.text = @"今日免费入场次数已用完看视频可继续入场";
//    }
    [self.whiteView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.width.mas_equalTo(ANDY_Adapta(400));
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(ANDY_Adapta(60));
    }];
}
- (void)setVideoIdData:(VideoModel *)model{
    self.videoId = model.videoId;
    self.vModel = model;
}
- (void)watchAction{
//    if ([PBCache shared].memberModel.userType == 2) {
//        [self.delegate noVideoBattleViewBack:self.vModel];
//    }else{
        [self.delegate WatchVideoBattleViewBack:self.vModel];
//    }
}

- (void)setViewBtnStatus{
    //信息流没加载出来之前不能点击激励视频 否则奔溃
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
    [self showWithAlert:self.videoView];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
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
