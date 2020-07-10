//
//  DrowPopView.m
//  wangcao
//
//  Created by EDZ on 2020/5/26.
//  Copyright © 2020 andy. All rights reserved.
//

#import "DrowPopView.h"

@interface DrowPopView()

@property (nonatomic,strong) UIView *drowPopView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIButton *commitBtn;
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *drowLabel1;
@property (nonatomic,strong) UILabel *drowLabel2;

@property (nonatomic,strong) WinLotteryModel *winModel;

@end

@implementation DrowPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    self.drowPopView = [[UIView alloc] init];
    [self addSubview:self.drowPopView];
    [self.drowPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(spaceHeight(350));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(698));
    }];
    
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.drowPopView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.drowPopView);
        make.height.mas_equalTo(ANDY_Adapta(533));
    }];
    
    self.headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_head"]];
    [self.drowPopView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.drowPopView);
        make.width.mas_equalTo(ANDY_Adapta(474));
        make.height.mas_equalTo(ANDY_Adapta(228));
    }];
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.drowPopView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImg.mas_bottom).offset(-ANDY_Adapta(32));
        make.centerX.mas_equalTo(self.headImg);
        make.height.mas_equalTo(ANDY_Adapta(85));
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.drowPopView addSubview:self.closeBtn];
    self.closeBtn.hidden = YES;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(self.drowPopView);
    }];
    
    self.commitBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"朕知道了" click:nil];
    [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
    [self.commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView);
        make.bottom.mas_equalTo(whiteView.mas_bottom).offset(-ANDY_Adapta(104));
    }];
    //恭喜您获得宝箱！
    self.drowLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [whiteView addSubview:self.drowLabel1];
    [self.drowLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_bottom);
        make.centerX.mas_equalTo(whiteView);
    }];
    
    self.iconImg = [[UIImageView alloc] init];
    [whiteView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView);
        make.top.mas_equalTo(self.drowLabel1.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(194));
        make.height.mas_equalTo(ANDY_Adapta(192));
    }];
    
    self.drowLabel2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:RGBA(254, 172, 56, 1) text:@"" Radius:0];
    [whiteView addSubview:self.drowLabel2];
    [self.drowLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView);
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(ANDY_Adapta(10));
    }];
}

- (void)setDrowPopViewData:(WinLotteryModel *)model array:(NSArray *)imageArr{
    self.winModel = model;
    if (model.type == 0) {
        self.titleLabel.text = @"获得金币";
        [self.commitBtn setTitle:@"朕知道了" forState:UIControlStateNormal];
        self.drowLabel2.text = [NSString stringWithFormat:@"+%@金币",model.goldCoins];
    }else if (model.type == 1){
        self.titleLabel.text = @"获得宝箱";
//        if ([PBCache shared].memberModel.userType == 2) {
//            [self.commitBtn setTitle:@"朕知道了" forState:UIControlStateNormal];
//        }else{
            [self.commitBtn setImage:[UIImage imageNamed:@"pop_videoicon"] forState:UIControlStateNormal];
            [self.commitBtn setTitle:@"看视频翻倍" forState:UIControlStateNormal];
            [self.commitBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(15))];
            self.commitBtn.enabled = NO;
//        }
        self.drowLabel2.text = model.name;
    }else if (model.type == 2){
        self.titleLabel.text = @"获得福豆";
        [self.commitBtn setTitle:@"朕知道了" forState:UIControlStateNormal];
        self.drowLabel2.text = [NSString stringWithFormat:@"+%ld福豆",model.blessBean];
    }
    for (int i = 0; i < imageArr.count; i++) {
        WinContentModel *contentModel = [WinContentModel mj_objectWithKeyValues:imageArr[i]];
        if (model.winId == contentModel.luck_Id) {
            [self.iconImg setImageURL:[NSURL URLWithString:contentModel.icon]];
            continue;
        }
    }
}

- (void)commitAction{
    if (self.winModel.type == 1) {
//        if ([PBCache shared].memberModel.userType == 2) {
//            //跳过广告
//            [self.delegate drowPopNoVideoBack:self.winModel];
//        }else{
            [self.delegate drowPopWatchVideoBack:self.winModel];
//        }
    }else{
        [self closeAction];
    }
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
    [self showWithAlert:self.drowPopView];
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
