//
//  BindPhoneController.m
//  wangcao
//
//  Created by EDZ on 2020/6/2.
//  Copyright © 2020 andy. All rights reserved.
//

#import "BindPhoneController.h"

@interface BindPhoneController ()

@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *codeTextField;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) UIButton *comfirButton;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation BindPhoneController
{
    NSInteger countDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"绑定手机号";
    countDown = 60;
    [self createUI];
}

- (void)createUI{
    UILabel *phoneLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"手机号" Radius:0];
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(150));
        make.width.mas_equalTo(ANDY_Adapta(120));
    }];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.textColor = TitleColor;
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_right).offset(ANDY_Adapta(15));
        make.top.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(150));
    }];
    [Tools setTextFiledPlaceholder:@"请输入您的手机号" font:FontBold_(15) color:GrayColor textFiled:self.phoneTextField];
    
    UIImageView *lineImg1 = [[UIImageView alloc] init];
    lineImg1.backgroundColor = LineColor;
    [self.view addSubview:lineImg1];
    [lineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(60));
        make.top.mas_equalTo(self.phoneTextField.mas_bottom);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UILabel *codeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"验证码" Radius:0];
    [self.view addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_left);
        make.top.mas_equalTo(lineImg1.mas_bottom);
        make.height.mas_equalTo(phoneLabel.mas_height);
    }];
    
    self.codeTextField = [[UITextField alloc] init];
    [self.view addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.height.mas_equalTo(self.phoneTextField);
        make.top.mas_equalTo(lineImg1.mas_bottom);
    }];
    [Tools setTextFiledPlaceholder:@"请输入验证码" font:FontBold_(15) color:GrayColor textFiled:self.codeTextField];
    
    UIImageView *lineImg2 = [[UIImageView alloc] init];
    lineImg2.backgroundColor = LineColor;
    [self.view addSubview:lineImg2];
    [lineImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.height.mas_equalTo(lineImg1);
        make.top.mas_equalTo(self.codeTextField.mas_bottom);
    }];
    
    self.sendButton = [[UIButton alloc] init];
    [self.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTitleColor:RGBA(254, 172, 56, 1) forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = Font_(13);
    [self.view addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).inset(ANDY_Adapta(20));
        make.centerY.equalTo(self.codeTextField);
    }];
    
    self.comfirButton = [[UIButton alloc] init];
    [self.comfirButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.comfirButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.comfirButton setBackgroundImage:[UIImage imageNamed:@"login_phonebg"] forState:UIControlStateNormal];
    self.comfirButton.titleLabel.font = Font_(15);
    self.comfirButton.layer.cornerRadius = ANDY_Adapta(48);
    [self.comfirButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.comfirButton addTarget:self action:@selector(comfirAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.comfirButton];
    [self.comfirButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineImg2.mas_bottom).offset(ANDY_Adapta(100));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
}

- (void)getVerifyCode{
    if (![self.phoneTextField.text isNotBlank]) {
        [MBProgressHUD showText:@"请输入您的手机号码" toView:self.view afterDelay:2.0];
        return;
    }
    if (self.phoneTextField.text.length != 11) {
        [MBProgressHUD showText:@"您的手机号码不正确" toView:self.view afterDelay:2.0];
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES];
    self.sendButton.enabled = NO;
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiSendVerifyCodeWithMobile:self.phoneTextField.text] subscribeNext:^(id  _Nullable x) {
        //发送验证码成功
    } error:^(NSError * _Nullable error) {
        self.sendButton.enabled = YES;
    }];
}
//获取验证码倒计时
- (void)countDownAction:(NSTimer *)time{
    countDown--;
    [self.sendButton setTitle:[NSString stringWithFormat:@"%lds",countDown] forState:UIControlStateNormal];
    if (countDown == 0) {
        countDown = 60;
        [self.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.sendButton.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)comfirAction{
    if (![self.phoneTextField.text isNotBlank]) {
        [MBProgressHUD showText:@"手机号不能为空" toView:[UIApplication sharedApplication].keyWindow afterDelay:2.0];
        return;
    }
    if (![self.codeTextField.text isNotBlank]) {
        [MBProgressHUD showText:@"验证码不能为空" toView:[UIApplication sharedApplication].keyWindow afterDelay:2.0];
        return;
    }
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUpdateMobilePhone:self.phoneTextField.text code:self.codeTextField.text] subscribeNext:^(id  _Nullable x) {
        //绑定成功
        [PBCache shared].userModel.phone = self.phoneTextField.text;
        [MBProgressHUD showText:@"绑定成功" toView:[UIApplication sharedApplication].keyWindow afterDelay:2.0];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError * _Nullable error) {
        
    }];
}

@end
