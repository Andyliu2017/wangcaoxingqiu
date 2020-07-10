//
//  GoodsCell.m
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import "GoodsCell.h"

@interface GoodsCell()

@property (nonatomic,strong) UIButton *goodsBtn;
@property (nonatomic,strong) UILabel *goodsLabel;
@property (nonatomic,assign) NSInteger goodsid;
@property (nonatomic,assign) NSInteger goodsPrice;

@end

@implementation GoodsCell

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
        make.width.mas_equalTo(ANDY_Adapta(335));
        make.height.mas_equalTo(ANDY_Adapta(400));
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
        make.top.mas_equalTo(ANDY_Adapta(20));
        make.width.mas_equalTo(ANDY_Adapta(200));
        make.height.mas_equalTo(ANDY_Adapta(53));
    }];
    self.goodsLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [labelBg addSubview:self.goodsLabel];
    [self.goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(labelBg);
    }];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_goods_icon"]];
    [whiteView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labelBg.mas_bottom).offset(ANDY_Adapta(12));
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(250));
        make.height.mas_equalTo(ANDY_Adapta(287));
    }];
    
    self.goodsBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(16) normalColor:[UIColor whiteColor] normalText:@"" click:^(id  _Nonnull x) {
//        self.goodsblock(self.goodsid);
        [self exchangeAction];
    }];
    [self.goodsBtn setBackgroundImage:[UIImage imageNamed:@"my_goods_btn"] forState:UIControlStateNormal];
    [self addSubview:self.goodsBtn];
    [self.goodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(335));
        make.height.mas_equalTo(ANDY_Adapta(95));
    }];
}

- (void)setCellData:(FotonExchangeModel *)model{
    self.goodsLabel.text = [NSString stringWithFormat:@"%ld分钟限时分红",model.time];
    [self.goodsBtn setTitle:[NSString stringWithFormat:@"%ld福豆兑换",model.blessBean] forState:UIControlStateNormal];
    self.goodsid = model.goods_id;
    self.goodsPrice = model.blessBean;
}

- (void)exchangeAction{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiFotonExchangeGoods:self.goodsid] subscribeNext:^(FotonExchangeModel *model) {
        //兑换限时分红成功
        NSLog(@"福豆数量1:%ld",[PBCache shared].goldModel.blessBean);
        [PBCache shared].goldModel.blessBean = [PBCache shared].goldModel.blessBean - self.goodsPrice;
        NSLog(@"福豆数量2:%ld,,,%ld",[PBCache shared].goldModel.blessBean,self.goodsPrice);
        self.goodsblock(model);
    } error:^(NSError * _Nullable error) {
        
    }];
}

@end
