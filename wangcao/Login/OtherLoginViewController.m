//
//  OtherLoginViewController.m
//  wangcao
//
//  Created by EDZ on 2020/5/6.
//  Copyright © 2020 andy. All rights reserved.
//

#import "OtherLoginViewController.h"
#import "MainViewController.h"
#import "TabbarViewController.h"

@interface OtherLoginViewController ()

@property (nonatomic,strong) UIButton *phoneDeleteBtn;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *codeTextField;
@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation OtherLoginViewController
{
    NSInteger countDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"pk_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(23));
        make.top.mas_equalTo(ANDY_Adapta(88));
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    countDown = 60;
    [self createUI];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI{
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(25) textColor:RGBA(42, 42, 42, 1) text:@"手机号登录" Radius:0];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(55*wc_scale);
        make.top.mas_equalTo(211*wc_scale);
        make.width.mas_equalTo(400*wc_scale);
        make.height.mas_equalTo(47*wc_scale);
    }];
    
    //手机号
    UIView *phoneView = [[UIView alloc] init];
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(ANDY_Adapta(76));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(90));
        make.width.mas_equalTo(ANDY_Adapta(646));
    }];
    
    UIImage *phoneImage = [UIImage imageNamed:@"login_phone_icon"];
    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:phoneImage];
    [phoneView addSubview:phoneImageView];
    [phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneView);
        make.left.equalTo(phoneView).offset(ANDY_Adapta(4));
        make.size.mas_equalTo(phoneImage.size);
    }];
    
    self.phoneTextField = [GGUI ui_textField:CGRectZero textColor:[UIColor blackColor] backColor:[UIColor clearColor] font:Font_(14) maxTextNum:20 placeholderColor:RGBA(170, 170, 170, 1) placeholder:@"请输入您的手机号码" toMaxNum:^(UITextField * _Nonnull textField) {
        
    } change:^(UITextField * _Nonnull textField) {
//        [self canClickLoginBtn];
        if (textField.text.length > 0) {
            self.phoneDeleteBtn.hidden = NO;
        }else {
            self.phoneDeleteBtn.hidden = YES;
        }
    }];
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.delegate = self;
    [phoneView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneImageView.mas_right).offset(ANDY_Adapta(31));
        make.right.equalTo(phoneView).inset(ANDY_Adapta(24));
        make.top.and.height.equalTo(phoneView);
    }];
    
    UIImageView *phoneLineView = [[UIImageView alloc] init];
    phoneLineView.backgroundColor = RGBA(221, 221, 221, 1);
    [self.view addSubview:phoneLineView];
    [phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(phoneView);
        make.top.mas_equalTo(phoneView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(2));
    }];
    [self.view addSubview:phoneLineView];
    
    self.phoneDeleteBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(0) normalColor:[UIColor clearColor] normalText:@"" click:^(UIButton * x) {
        self.phoneTextField.text = @"";
        x.hidden = YES;
    }];
    self.phoneDeleteBtn.hidden = YES;
    [self.phoneDeleteBtn setImage:[UIImage imageNamed:@"login_deleteBtn"] forState:UIControlStateNormal];
    [phoneView addSubview:self.phoneDeleteBtn];
    [self.phoneDeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(phoneView.mas_height);
        make.width.mas_equalTo(17);
        make.centerY.mas_equalTo(phoneView);
        make.right.mas_equalTo(phoneLineView);
    }];
    
    //验证码
    UIView *codeView = [[UIView alloc] init];
    //self.codeView.hidden = YES;
//    self.codeView = codeView;
    [self.view addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLineView.mas_bottom).inset(ANDY_Adapta(48));
        make.left.and.width.and.height.equalTo(phoneView);
    }];
    
    UIImage *codeImage = [UIImage imageNamed:@"login_code_icon"];
    UIImageView *codeImageView = [[UIImageView alloc] initWithImage:codeImage];
    [codeView addSubview:codeImageView];
    [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(codeView);
        make.left.equalTo(codeView).offset(ANDY_Adapta(4));
        make.size.mas_equalTo(codeImage.size);
    }];
    
    self.sendButton = [[UIButton alloc] init];
    [self.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTitleColor:RGBA(254, 172, 56, 1) forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = Font_(13);
    [codeView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeView).inset(ANDY_Adapta(20));
        make.centerY.equalTo(codeView);
        make.width.mas_equalTo(ANDY_Adapta(130));
        make.height.mas_equalTo(ANDY_Adapta(25));
    }];
    //[sendButton buttonColor];
    
    self.codeTextField = [GGUI ui_textField:CGRectZero textColor:[UIColor blackColor] backColor:[UIColor clearColor] font:Font_(14) maxTextNum:6 placeholderColor:RGBA(170, 170, 170, 1) placeholder:@"请输入验证码" toMaxNum:^(UITextField * _Nonnull textField) {
        
    } change:^(UITextField * _Nonnull textField) {
//        [self canClickLoginBtn];
    }];
    self.codeTextField.delegate = self;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [codeView addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeImageView.mas_right).offset(ANDY_Adapta(31));
        make.right.equalTo(self.sendButton.mas_left);
        make.top.and.height.equalTo(codeView);
    }];
    
    UIImageView *codeLineView = [[UIImageView alloc] init];
    codeLineView.backgroundColor = RGBA(221, 221, 221, 1);
    [codeView addSubview:codeLineView];
    [codeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(codeView);
        make.top.equalTo(codeView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(2));
    }];
    
    
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_phonebg"] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = Font_(15);
    self.loginButton.layer.cornerRadius = ANDY_Adapta(48);
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:RGBA(172, 137, 219, 1)];
    self.loginButton.layer.cornerRadius = ANDY_Adapta(96) / 2.0;
    self.loginButton.layer.masksToBounds = YES;
    //loginButton.clipsToBounds = YES;
//    loginButton.layer.shadowOffset =  CGSizeMake(0, 4);    //阴影的偏移量
//    loginButton.layer.shadowOpacity = 0.8;                        //阴影的不透明度
//    loginButton.layer.shadowColor = KKMainSubColor.CGColor;//阴影的颜色
//    [loginButton setBackgroundColor:KKMainSubColor];
//    self.loginButton = loginButton;
    [self.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_bottom).offset(ANDY_Adapta(100));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
}
#pragma mark 获取验证码
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

- (void)loginAction{
    if (![self.phoneTextField.text isNotBlank]) {
        [MBProgressHUD showText:@"请输入您的手机号码" toView:self.view afterDelay:2.0];
        return;
    }
    if (self.phoneTextField.text.length != 11) {
        [MBProgressHUD showText:@"手机号码不正确" toView:self.view afterDelay:2.0];
        return;
    }
    if (![self.codeTextField.text isNotBlank]) {
        [MBProgressHUD showText:@"请输入您的验证码" toView:self.view afterDelay:2.0];
        return;
    }
    
    WCApiManager *apiManager = [WCApiManager sharedManager];
    apiManager.cachePloy = APICachePloy_Server;
    [[apiManager loginWithMobile:self.phoneTextField.text invitecode:@"" verifycode:self.codeTextField.text wxLoginId:@""] subscribeNext:^(WCLoginModel *loginModel) {
        [[PBCache shared] setMemberModel:loginModel];
        [[NSUserDefaults standardUserDefaults] setObject:loginModel.token forKey:@"LoginTokenTmp"];
        [[NSUserDefaults standardUserDefaults] setObject:@(loginModel.userId) forKey:@"LoginUseridTmp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"登录成功");
//        [self getUserInfo:loginModel.userId];
        TabbarViewController *tabbarVc = [[TabbarViewController alloc] init];
        tabbarVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController pushViewController:tabbarVc animated:YES];
    } error:^(NSError * _Nullable error) {
        
    }];
}
//获取用户信息
- (void)getUserInfo:(NSInteger)userid{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserInfo:userid] subscribeNext:^(UserModel *model) {
        [PBCache shared].userModel = model;
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField isEqual:self.phoneTextField])
    {
        if (toBeString.length <= 11)
        {
            return YES;
        }
        return NO;
    }
    if ([textField isEqual:self.codeTextField])
    {
        if (toBeString.length <= 6)
        {
            return YES;
        }
        return NO;
    }
    return YES;
}
- (UITextField *)createTextFieldWithPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] init];
    NSDictionary *parameters = @{
                                 NSFontAttributeName : Font_(14),
                                 NSForegroundColorAttributeName : RGBA(170, 170, 170, 1)
                                 };
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:parameters];
    textField.attributedPlaceholder = attributedPlaceholder;
    textField.font = Font_(14);
    return textField;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
