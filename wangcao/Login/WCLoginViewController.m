//
//  WCLoginViewController.m
//  wangcao
//
//  Created by liu dequan on 2020/4/29.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCPublicModel.h"
#import "WCLoginModel.h"
#import "YYCache.h"
#import "OtherLoginViewController.h"
#import "WCApiName.h"
#import "TabbarViewController.h"
#import "YinSiView.h"
#import "APHandleManager.h"
#import <WXApi.h>

@interface WCLoginViewController ()<YinSiViewDelegate>

//选中已阅读按钮
@property (nonatomic,strong) UIButton *radioBtn;

@end

@implementation WCLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createLoginUI];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)createLoginUI{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImage.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UIImageView *titleImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    titleImg.image = [UIImage imageNamed:@"login_title"];
    [self.view addSubview:titleImg];
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(ANDY_Adapta(686));
        make.height.mas_equalTo(ANDY_Adapta(294));
        make.top.mas_equalTo(spaceHeight(264));
//        if (@available(iOS 11.0, *)) {
//            
//        }else{
//            make.top.mas_equalTo(194*wc_scale);
//        }
    }];
    
    UILabel *dibuLabel2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(11) textColor:LoginTitleColor text:@"Copyright 2020 All Rights Resserved" Radius:0];
    [self.view addSubview:dibuLabel2];
    [dibuLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).inset(spaceHeight(94));
        make.centerX.and.width.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(22));
    }];
    
    UILabel *dibuLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(11) textColor:LoginTitleColor text:@"湖南华创通联信息科技有限公司" Radius:0];
    [self.view addSubview:dibuLabel1];
    [dibuLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(dibuLabel2.mas_top).inset(spaceHeight(15));
        make.centerX.and.width.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(22));
    }];
    
    UILabel *yinsiLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:LoginTitleColor text:@"我已阅读同意《用户协议》和《隐私协议》" Radius:0];
    yinsiLabel.userInteractionEnabled = YES;
    yinsiLabel.hidden = YES;
    [self.view addSubview:yinsiLabel];
    [yinsiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(dibuLabel1.mas_top).inset(spaceHeight(137));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(25));
    }];
    
    UILabel *yinsiLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:LoginTitleColor text:@"我已阅读同意" Radius:0];
    [self.view addSubview:yinsiLabel1];
    [yinsiLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yinsiLabel.mas_left);
        make.top.mas_equalTo(yinsiLabel.mas_top);
        make.height.mas_equalTo(ANDY_Adapta(25));
    }];
    
    NSMutableAttributedString *title1 = [[NSMutableAttributedString alloc] initWithString:@"《用户协议》"];
    NSRange titleRange = {0,[title1 length]};
    [title1 addAttribute:NSUnderlineStyleAttributeName
    value:@(NSUnderlineStyleSingle)
    range:titleRange];
    [title1 addAttribute:NSForegroundColorAttributeName value:LoginTitleColor  range:titleRange];
    [title1 addAttribute:NSUnderlineColorAttributeName value:LoginTitleColor range:titleRange];
    [title1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    UIButton *yonghuBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(12) normalColor:LoginTitleColor normalText:@"" click:^(id  _Nonnull x) {
        [self yonghuAction];
    }];
    [yonghuBtn setAttributedTitle:title1 forState:UIControlStateNormal];
    [self.view addSubview:yonghuBtn];
    [yonghuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yinsiLabel1.mas_right);
        make.top.mas_equalTo(yinsiLabel.mas_top);
        make.height.mas_equalTo(ANDY_Adapta(25));
    }];
    
    UILabel *yinsiLabel2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:LoginTitleColor text:@"和" Radius:0];
    [self.view addSubview:yinsiLabel2];
    [yinsiLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yonghuBtn.mas_right);
        make.top.mas_equalTo(yonghuBtn.mas_top);
        make.height.mas_equalTo(ANDY_Adapta(25));
    }];
    
    NSMutableAttributedString *title2 = [[NSMutableAttributedString alloc] initWithString:@"《隐私协议》"];
    NSRange titleRange1 = {0,[title2 length]};
    [title2 addAttribute:NSUnderlineStyleAttributeName
    value:@(NSUnderlineStyleSingle)
    range:titleRange1];
    [title2 addAttribute:NSForegroundColorAttributeName value:LoginTitleColor  range:titleRange1];
    [title2 addAttribute:NSUnderlineColorAttributeName value:LoginTitleColor range:titleRange1];
    [title2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange1];
    UIButton *yinsiBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(12) normalColor:LoginTitleColor normalText:@"" click:^(id  _Nonnull x) {
        [self yinsiAction];
    }];
    [yinsiBtn setAttributedTitle:title2 forState:UIControlStateNormal];
    [self.view addSubview:yinsiBtn];
    [yinsiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yinsiLabel2.mas_right);
        make.top.mas_equalTo(yinsiLabel2.mas_top);
        make.height.mas_equalTo(ANDY_Adapta(25));
    }];
    
    UIImageView *radioBgImg = [[UIImageView alloc] init];
    radioBgImg.layer.cornerRadius = ANDY_Adapta(13);
    radioBgImg.layer.masksToBounds = YES;
    radioBgImg.layer.borderWidth = ANDY_Adapta(1);
    radioBgImg.layer.borderColor = LoginTitleColor.CGColor;
    radioBgImg.userInteractionEnabled = YES;
    [self.view addSubview:radioBgImg];
    [radioBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(yinsiLabel.mas_left).offset(-ANDY_Adapta(10));
        make.centerY.mas_equalTo(yinsiLabel);
        make.width.and.height.mas_equalTo(ANDY_Adapta(26));
    }];
    
    self.radioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.radioBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    选中图片第二次不显示
//    [self.radioBtn setImage:[UIImage imageNamed:@"login_radio"] forState:UIControlStateSelected];
    [self.radioBtn addTarget:self action:@selector(radioAction) forControlEvents:UIControlEventTouchUpInside];
    self.radioBtn.selected = NO;
    [radioBgImg addSubview:self.radioBtn];
    [self.radioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(radioBgImg);
        make.width.and.height.mas_equalTo(ANDY_Adapta(25));
    }];
    
    UIButton *loginBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(13) normalColor:LoginTitleColor normalText:@"使用其他方式登录" click:^(id  _Nonnull x) {
        [self loginAction];
    }];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"使用其他方式登录"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
    value:@(NSUnderlineStyleSingle)
    range:(NSRange){0,[tncString length]}];
    [tncString addAttribute:NSForegroundColorAttributeName value:RGBA(137, 104, 198, 1)  range:NSMakeRange(0,[tncString length])];
    [tncString addAttribute:NSUnderlineColorAttributeName value:RGBA(137, 104, 198, 1) range:(NSRange){0,[tncString length]}];
    [loginBtn setAttributedTitle:tncString forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(yinsiLabel.mas_top).inset(spaceHeight(55));
        make.width.mas_equalTo(ANDY_Adapta(213));
        make.height.mas_equalTo(ANDY_Adapta(28));
    }];
    
    
    UIButton *wxLoginBtn = [GGUI ui_buttonSimple:self.view.bounds font:Font_(17) normalColor:[UIColor whiteColor] normalText:@"微信登录" click:^(id  _Nonnull x) {
        [self wxLoginAction];
    }];
//    wxLoginBtn.backgroundColor = RGBA(56, 195, 89, 1);
    [wxLoginBtn setBackgroundImage:[UIImage imageNamed:@"login_wxbg"] forState:UIControlStateNormal];
//    wxLoginBtn.layer.cornerRadius = ANDY_Adapta(55);
//    wxLoginBtn.layer.masksToBounds = YES;
    [wxLoginBtn setImage:[UIImage imageNamed:@"login_wx"] forState:UIControlStateNormal];
    [wxLoginBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, ANDY_Adapta(16), ANDY_Adapta(15))];
    [wxLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, ANDY_Adapta(15), ANDY_Adapta(16), 0)];
    [self.view addSubview:wxLoginBtn];
    [wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(loginBtn.mas_top).inset(spaceHeight(34));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(510));
        make.height.mas_equalTo(ANDY_Adapta(130));
    }];
//    if (![WXApi isWXAppInstalled]) {
//        wxLoginBtn.hidden = YES;
//    }
}
- (void)radioAction{
    self.radioBtn.selected = !self.radioBtn.isSelected;
    if (self.radioBtn.isSelected) {
        [self.radioBtn setImage:[UIImage imageNamed:@"login_radio"] forState:UIControlStateNormal];
    }else{
        [self.radioBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
}
//用户协议弹窗
- (void)yonghuAction{
    YinSiView *yinsiview = [[YinSiView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    yinsiview.delegate = self;
    [yinsiview setWebViewUrl:[PBCache shared].systemModel.agreementUrl withTitle:@"用户协议"];
    [yinsiview showPopView:self];
}
//隐私政策弹窗
- (void)yinsiAction{
    YinSiView *yinsiview = [[YinSiView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    yinsiview.delegate = self;
    [yinsiview setWebViewUrl:[PBCache shared].systemModel.privacyAgreementUrl withTitle:@"隐私协议"];
    [yinsiview showPopView:self];
}
- (void)agreeYinsiBack{
    self.radioBtn.selected = YES;
    [self.radioBtn setImage:[UIImage imageNamed:@"login_radio"] forState:UIControlStateNormal];
}
- (void)noAgreeYinsiBack{
    self.radioBtn.selected = NO;
    [self.radioBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

- (void)loginAction{
    OtherLoginViewController *vc = [[OtherLoginViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 微信登录
- (void)wxLoginAction{
    NSLog(@"微信登录");
    if (!self.radioBtn.isSelected) {
        [MBProgressHUD showText:@"请阅读同意《用户协议》和《隐私协议》" toView:self.view afterDelay:2.0];
        return;
    }
    [[APHandleManager sharedManager] authorizationWachat:^(NSString *authCode) {
        NSLog(@"authCode:%@",authCode);
        WCApiManager *manager = [WCApiManager sharedManager];
        manager.cachePloy = APICachePloy_Server;
        [MBProgressHUD showMessage:@"登录中" toView:self.view];
        NSDictionary *d = @{@"channel":@"APP",@"authCode":authCode,@"platform":@"ios",@"inviteCode":@"system"};
        [manager postHttp:WeChatLogin_URL dic:d block:^(NSDictionary *sth, NSError * sth2) {
            NSLog(@"sth:%@,,",sth);
            NSDictionary *dic = sth;
            if ([dic[@"code"] isEqualToString:@"ok"]) { //登录成功
                [MBProgressHUD hideHUDForView:self.view];
                WCLoginModel *loginModel = [WCLoginModel mj_objectWithKeyValues:dic[@"data"]];
                loginModel.isLogin = YES;
                [[PBCache shared] setMemberModel:loginModel];
                [WCApiManager sharedManager].loginModel  = loginModel;
                [[WCApiManager sharedManager].cache setObject:loginModel forKey:@"gUser"];
                [[NSUserDefaults standardUserDefaults] setObject:loginModel.token forKey:@"LoginTokenTmp"];
                [[NSUserDefaults standardUserDefaults] setObject:@(loginModel.userId) forKey:@"LoginUseridTmp"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"登录成功");
                TabbarViewController *tabbarVc = [[TabbarViewController alloc] init];
                tabbarVc.modalPresentationStyle = UIModalPresentationFullScreen;
                [self.navigationController pushViewController:tabbarVc animated:YES];
            }else{
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showText:dic[@"message"] toView:self.view afterDelay:1.0];
            }
        }];
    } failure:^(HandleStatus code) {
        
    }];
}

@end
