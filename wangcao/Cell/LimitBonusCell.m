//
//  LimitBonusCell.m
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import "LimitBonusCell.h"

@interface LimitBonusCell()

@property (nonatomic,strong) UIButton *limitBtn;
@property (nonatomic,strong) UILabel *limitLabel;
//剩余分红时长
@property (nonatomic,assign) NSInteger seconds;
@property (nonatomic ,strong) dispatch_source_t s_timer;

@end

@implementation LimitBonusCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(ANDY_Adapta(10));
        make.width.mas_equalTo(ANDY_Adapta(227));
        make.height.mas_equalTo(ANDY_Adapta(260));
    }];
    
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.centerX.mas_equalTo(self);
        make.width.and.height.mas_equalTo(blackView);
    }];
    
    UIImageView *labelBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_goods_bg"]];
    [whiteView addSubview:labelBg];
    [labelBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView);
        make.top.mas_equalTo(ANDY_Adapta(16));
        make.width.mas_equalTo(ANDY_Adapta(157));
        make.height.mas_equalTo(ANDY_Adapta(35));
    }];
    self.limitLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"" Radius:0];
    self.limitLabel.adjustsFontSizeToFitWidth = YES;
    [labelBg addSubview:self.limitLabel];
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(labelBg);
    }];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_yuxi"]];
    [whiteView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labelBg.mas_bottom).offset(ANDY_Adapta(30));
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(139));
        make.height.mas_equalTo(ANDY_Adapta(139));
    }];
    
    self.limitBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(16) normalColor:[UIColor whiteColor] normalText:@"" click:^(id  _Nonnull x) {
//        [self exchangeAction];
    }];
    [self.limitBtn setBackgroundImage:[UIImage imageNamed:@"my_goods_btn"] forState:UIControlStateNormal];
    self.limitBtn.userInteractionEnabled = NO;
    [self addSubview:self.limitBtn];
    [self.limitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(217));
        make.height.mas_equalTo(ANDY_Adapta(61));
    }];
}

- (void)setCellData:(FotonExchangeModel *)model{
    self.limitLabel.text = model.desc;
    @weakify(self);
    self.seconds = model.surplusProfitTime;
    dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
    self.s_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.s_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.s_timer, ^{
        @strongify(self);
        self.seconds--;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.seconds > 0)
            {
                [self.limitBtn setTitle:[NSString stringWithFormat:@"剩余%@",[GGUI timeFormatted:self.seconds type:0]] forState:UIControlStateNormal];
            }
            else
            {
                if (self.seconds >= 0) {
                    [self.limitBtn setTitle:[NSString stringWithFormat:@"剩余%@",[GGUI timeFormatted:self.seconds type:0]] forState:UIControlStateNormal];
                }
                dispatch_source_cancel(self.s_timer);
                self.s_timer = nil;
                self.exblock(model);
            }
        });
    });
    dispatch_resume(self.s_timer);
}

@end
