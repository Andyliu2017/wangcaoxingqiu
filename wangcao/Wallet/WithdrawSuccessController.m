//
//  WithdrawSuccessController.m
//  wangcao
//
//  Created by EDZ on 2020/6/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WithdrawSuccessController.h"

@interface WithdrawSuccessController ()

@end

@implementation WithdrawSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现结果";
    self.view.backgroundColor = RGBA(247, 247, 247, 1);
    
    [self createUI];
}

- (void)createUI{
    UIView *topView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(410));
    }];
    
    UIImageView *successImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_success"]];
    [topView addSubview:successImg];
    [successImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topView);
        make.top.mas_equalTo(ANDY_Adapta(70));
        make.width.and.height.mas_equalTo(ANDY_Adapta(158));
    }];
    
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(15) textColor:TitleColor text:@"提现申请已提交" Radius:0];
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successImg.mas_bottom).offset(ANDY_Adapta(40));
        make.centerX.mas_equalTo(topView);
    }];
    
    UILabel *descLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(11) textColor:GrayColor text:@"预计三个工作日到账，请注意查收！" Radius:0];
    [topView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(topView);
    }];
    
    UIView *amountView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:amountView];
    [amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(topView.mas_bottom).offset(ANDY_Adapta(20));
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    
    UILabel *amountLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"提现金额" Radius:0];
    [amountView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(amountView);
    }];
    UILabel *amountLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    if (self.amount == (int)self.amount) {
        amountLabel1.text = [NSString stringWithFormat:@"%.0f",self.amount];
    }else{
        amountLabel1.text = [NSString stringWithFormat:@"%.2f",self.amount];
    }
    [amountView addSubview:amountLabel1];
    [amountLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(amountView.mas_right).offset(-ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(amountView);
    }];
    UIImageView *lineImg1 = [[UIImageView alloc] init];
    lineImg1.backgroundColor = LineColor;
    [self.view addSubview:lineImg1];
    [lineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(amountView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    //手续费
    UIView *shouxuView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:shouxuView];
    [shouxuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(lineImg1.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    UILabel *shouxuLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"手续费" Radius:0];
    [shouxuView addSubview:shouxuLabel];
    [shouxuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(shouxuView);
    }];
    UILabel *shouxuLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    if (self.shouxuAmount == (int)self.shouxuAmount) {  //整数
        shouxuLabel1.text = [NSString stringWithFormat:@"%.0f",self.shouxuAmount];
    }else{
        shouxuLabel1.text = [NSString stringWithFormat:@"%.2f",self.shouxuAmount];
    }
    [shouxuView addSubview:shouxuLabel1];
    [shouxuLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(shouxuView.mas_right).offset(-ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(shouxuView);
    }];
    UIImageView *lineImg2 = [[UIImageView alloc] init];
    lineImg2.backgroundColor = GrayColor;
    [self.view addSubview:lineImg2];
    [lineImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(shouxuView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    //账户
    UIView *accountView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:accountView];
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(lineImg2.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    UILabel *accountLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"提现至账户" Radius:0];
    [accountView addSubview:accountLabel];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(accountView);
    }];
    UILabel *accountLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(14) textColor:TitleColor text:@"支付宝" Radius:0];
    [accountView addSubview:accountLabel1];
    [accountLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(accountView.mas_right).offset(-ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(accountView);
    }];
    
    UIButton *btn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"完成" click:^(id  _Nonnull x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btn setBackgroundImage:[UIImage imageNamed:@"rank_invite"] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, ANDY_Adapta(10), 0)];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-ANDY_Adapta(100));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(642));
        make.height.mas_equalTo(ANDY_Adapta(110));
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:WITHDRAWSUCCESS object:self userInfo:nil];
}

@end
