//
//  LimitBonusView.m
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import "LimitBonusView.h"

@interface LimitBonusView()

@property (nonatomic,strong) UIView *limitView;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *closeBtn;
//玉玺、红包
@property(nonatomic,strong) UIImageView *iconImg;

//时间、倒计时
@property (nonatomic,strong) UILabel *timeLabel;
//可体验多长时间分红
@property (nonatomic,strong) UILabel *timeLabel1;

//确定
@property (nonatomic,strong) UIButton *commitBtn;

@property (nonatomic,strong) FotonModel *ftModel;

@end

@implementation LimitBonusView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setLimitViewUI];
    }
    return self;
}

- (void)setLimitViewUI{
    self.limitView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:self.limitView];
    [self.limitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(spaceHeight(350));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(815));
    }];
    
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.limitView addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(ANDY_Adapta(175));
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(640));
    }];
    self.whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.limitView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(165));
        make.left.and.width.and.height.mas_equalTo(blackView);
    }];
    
    self.headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_head"]];
    [self.limitView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.limitView);
        make.width.mas_equalTo(ANDY_Adapta(474));
        make.height.mas_equalTo(ANDY_Adapta(228));
    }];
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.headImg addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImg.mas_bottom).offset(-ANDY_Adapta(32));
        make.centerX.mas_equalTo(self.headImg);
        make.height.mas_equalTo(ANDY_Adapta(85));
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.limitView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(self.limitView);
    }];
    
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.whiteView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.limitView).offset(ANDY_Adapta(210));
        make.centerX.mas_equalTo(self.limitView);
        make.width.and.height.mas_equalTo(ANDY_Adapta(267));
    }];
}
#pragma mark 限时分红
- (void)limitBonusView{
    UIView *limitTimeView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(234, 234, 234, 1) alpha:1.0 cornerRadius:ANDY_Adapta(7) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.whiteView addSubview:limitTimeView];
    [limitTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self.iconImg);
        make.height.mas_equalTo(ANDY_Adapta(40));
        make.width.mas_equalTo(ANDY_Adapta(133));
    }];
    UIImageView *timeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_time"]];
    [limitTimeView addSubview:timeImg];
    [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(22));
        make.centerY.mas_equalTo(limitTimeView);
        make.width.and.height.mas_equalTo(ANDY_Adapta(20));
    }];
    self.timeLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:Font_(11) textColor:MessageColor text:@"" Radius:0];
    [limitTimeView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeImg.mas_right).offset(ANDY_Adapta(10));
        make.centerY.mas_equalTo(timeImg);
    }];
    
    UILabel *limitTimeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(16) textColor:TitleColor text:@"恭喜获得限时分红玉玺" Radius:0];
    [Tools setTextColor1:limitTimeLabel FontNumber:FontBold_(16) AndRange:NSMakeRange(0, 4) AndAnotherRange:NSMakeRange(3, 6) AndColor1:TitleColor AndColor2:MoneyColor];
    [self.whiteView addSubview:limitTimeLabel];
    [limitTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(ANDY_Adapta(30));
    }];
    //可体验5分钟分红玉玺
    self.timeLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:GrayColor text:@"" Radius:0];
    [self.whiteView addSubview:self.timeLabel1];
    [self.timeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(limitTimeLabel.mas_bottom).offset(ANDY_Adapta(15));
    }];
    
    self.commitBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"确定" click:^(id  _Nonnull x) {
        [self closeAction];
    }];
    [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
    [self.whiteView addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel1.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(self.whiteView);
//        make.width.mas_equalTo(ANDY_Adapta(<#width#>))
    }];
    UILabel *descLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:GrayColor text:@"集齐所有典故卡可获得永久分红" Radius:0];
    [self.whiteView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.commitBtn.mas_bottom).offset(ANDY_Adapta(20));
    }];
}
- (void)setLimitBonusData:(FotonExchangeModel *)model withType:(int)type{
    self.titleLabel.text = @"限时分红";
    self.iconImg.image = [UIImage imageNamed:@"pop_yuxi"];
    self.timeLabel1.text = [NSString stringWithFormat:@"可体验%ld分钟分红玉玺",model.profitTime/60];
    self.timeLabel.text = [GGUI timeFormatted:model.profitTime type:type];
}
#pragma mark 限时分红结束弹窗
- (void)expireBonusView{
    //恭喜获得1分钟广告分红
    self.timeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.bottom.mas_equalTo(self.iconImg.mas_bottom);
    }];
    //¥1.54
    self.timeLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(30) textColor:MoneyColor text:@"" Radius:0];
    [self.whiteView addSubview:self.timeLabel1];
    [self.timeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(ANDY_Adapta(39));
    }];
    //确定
    self.commitBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"确定" click:^(id  _Nonnull x) {
            [self closeAction];
        }];
        [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
        [self.whiteView addSubview:self.commitBtn];
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel1.mas_bottom).offset(ANDY_Adapta(20));
            make.centerX.mas_equalTo(self.whiteView);
        }];
        UILabel *descLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:GrayColor text:@"集齐所有典故卡可获得永久分红" Radius:0];
        [self.whiteView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.whiteView);
            make.top.mas_equalTo(self.commitBtn.mas_bottom).offset(ANDY_Adapta(20));
        }];
}
- (void)setExpireBonusData:(FotonExchangeModel *)model{
    self.titleLabel.text = @"限时分红";
    self.iconImg.image = [UIImage imageNamed:@"pop_yuxi"];
    self.timeLabel.text = [NSString stringWithFormat:@"恭喜获得%ld分钟广告分红",model.profitTime/60];
    self.timeLabel1.text = [NSString stringWithFormat:@"￥%.2f",model.totalProfit];
}
#pragma mark 现金红包
- (void)cashBonusView{
    //恭喜获得1分钟广告分红
    self.timeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.bottom.mas_equalTo(self.iconImg.mas_bottom);
    }];
    //¥1.54
    self.timeLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(30) textColor:MoneyColor text:@"" Radius:0];
    [self.whiteView addSubview:self.timeLabel1];
    [self.timeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(ANDY_Adapta(39));
    }];
    //确定
    self.commitBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"确定" click:^(id  _Nonnull x) {
        [self closeAction];
        [self commitAction];
    }];
    [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
    [self.whiteView addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel1.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(self.whiteView);
    }];
}
- (void)setCashBonusData:(FotonModel *)model{
    self.ftModel = model;
    self.titleLabel.text = @"现金红包";
    self.iconImg.image = [UIImage imageNamed:@"pop_redpackage"];
    self.timeLabel.text = @"恭喜获得现金红包";
    self.timeLabel1.text = [NSString stringWithFormat:@"￥%.2f",model.money];
}
- (void)commitAction{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiReceiveCashBonusWithCashId:self.ftModel.foton_id] subscribeNext:^(id  _Nullable x) {
        [MBProgressHUD showText:@"领取成功" toView:[UIApplication sharedApplication].keyWindow afterDelay:1.0];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)closeAction{
    [UIView animateWithDuration:0.6f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
}
- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.limitView];
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

- (void)outCloseAction{
    [UIView animateWithDuration:0.6f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
}

@end
