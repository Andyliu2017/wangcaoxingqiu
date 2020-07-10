//
//  SetViewController.m
//  wangcao
//
//  Created by EDZ on 2020/5/8.
//  Copyright © 2020 andy. All rights reserved.
//

#import "SetViewController.h"
#import "BindPhoneController.h"

@interface SetViewController ()

@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) UISwitch *musicSwitch;

@end

@implementation SetViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"设置";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"设置";
    //设置界面frame从navigationBar的下面开始计算
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setData];
    [self setUI];
}
#pragma mark 设置数据
- (void)setData{
    self.titleArr = @[@"绑定手机号",@"新版本检测",@"用户协议",@"隐私政策",@"开启音效"];
}
#pragma mark UI创建
- (void)setUI{
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(ANDY_Adapta(63));
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(487));
    }];
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    whiteView.clipsToBounds = YES;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(53));
        make.left.and.height.and.width.mas_equalTo(blackView);
    }];
    __block SetViewController *weakSelf = self;
    for (int i = 0; i < self.titleArr.count; i++) {
        UIView *setView = [self setViewWith:self.titleArr[i] index:i click:^(id x) {
            [weakSelf setAction:i];
        }];
        [whiteView addSubview:setView];
//        if (![WXApi isWXAppInstalled] || [PBCache shared].memberModel.userType == 2) {
//            if (i == 1) {
//                setView.hidden = YES;
//            }
//        }
        [setView mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (![WXApi isWXAppInstalled] || [PBCache shared].memberModel.userType == 2) {
//                if (i == 0) {
//                    make.top.mas_equalTo(0);
//                    make.left.and.right.mas_equalTo(whiteView);
//                    make.height.mas_equalTo(ANDY_Adapta(96));
//                }else if (i == 1){
//                    make.top.mas_equalTo(ANDY_Adapta(96));
//                    make.left.and.right.mas_equalTo(whiteView);
//                    make.height.mas_equalTo(ANDY_Adapta(0));
//                }else{
//                    make.top.mas_equalTo(ANDY_Adapta(96)*(i-1));
//                    make.left.and.right.mas_equalTo(whiteView);
//                    make.height.mas_equalTo(ANDY_Adapta(96));
//                }
//            }else{
                make.top.mas_equalTo(ANDY_Adapta(96)*i);
                make.left.and.right.mas_equalTo(whiteView);
                make.height.mas_equalTo(ANDY_Adapta(96));
//            }
        }];
    }
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"rank_invite"] forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exitBtn.titleLabel.font = FontBold_(17);
    [exitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-spaceHeight(50));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(642));
        make.height.mas_equalTo(ANDY_Adapta(110));
    }];
}
- (UIView *)setViewWith:(NSString *)title index:(NSInteger)index click:(void (^)(id x))click{
    UIView *setView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:MYTEXT_COLOR text:title Radius:0];
    [setView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(26));
        make.top.and.bottom.mas_equalTo(setView);
        make.width.mas_equalTo(ANDY_Adapta(260));
    }];
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_more"]];
    [setView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(setView.mas_right).offset(-ANDY_Adapta(30));
        make.centerY.mas_equalTo(0);
        make.width.and.height.mas_equalTo(ANDY_Adapta(20));
    }];
    UILabel *label = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(13) textColor:RGBA(170, 170, 170, 1) text:@"" Radius:0];
    label.tag = 10+index;
    if (index == 0) {
        label.text = [PBCache shared].userModel.phone;
    }else if (index == 1){
        label.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    [setView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right);
        make.right.mas_equalTo(iconImg.mas_left).offset(-ANDY_Adapta(5));
        make.top.and.bottom.mas_equalTo(setView);
    }];
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = RGBA(238, 238, 238, 1);
    [setView addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(setView);
        make.width.mas_equalTo(ANDY_Adapta(638));
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    if (index == 4) {
        iconImg.hidden = YES;
        label.hidden = YES;
        self.musicSwitch = [[UISwitch alloc] init];
        self.musicSwitch.frame = CGRectMake(ANDY_Adapta(650)-self.musicSwitch.frame.size.width, (ANDY_Adapta(96)-self.musicSwitch.frame.size.height)/2.0, self.musicSwitch.frame.size.width, self.musicSwitch.frame.size.height);
        self.musicSwitch.onTintColor = RGBA(71, 195, 94, 1);
        self.musicSwitch.tintColor = RGBA(238, 238, 238, 1);
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if ([[def valueForKey:BACKGROUNDMUSIC] isEqualToString:@"1"]) {
            self.musicSwitch.on = YES;
        }else{
            self.musicSwitch.on = NO;
        }
        [self.musicSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
        [setView addSubview:self.musicSwitch];
//        [self.musicSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(titleLabel.centerY);
//            make.right.mas_equalTo(setView.mas_right).offset(-ANDY_Adapta(80));
//            make.width.mas_equalTo(ANDY_Adapta(48));
//            make.height.mas_equalTo(ANDY_Adapta(30));
//        }];
    }else{
        //添加点击
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [setView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.and.bottom.mas_equalTo(setView);
        }];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (click) {
                click(x);
            }
        }];
    }
    return setView;
}
//退出登录
- (void)exitAction{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"是否退出当前账号?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确认按钮");
        [self exitLogin];
    }];
    //2.2 取消按钮
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消按钮");
    }];
    [alertController addAction:cancel];
    [alertController addAction:conform];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)setAction:(NSInteger)type{
    switch (type) {
        case 0:
        {
            if ([[PBCache shared].userModel.phone isNotBlank]) {
                [MBProgressHUD showText:@"您已经绑定手机号了" toView:self.view afterDelay:1.0];                
            }else{
                BindPhoneController *vc = [[BindPhoneController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1:
            [MBProgressHUD showText:@"你已经是最新版本了" toView:self.view afterDelay:1.0];
            break;
        case 2:
        {
            WCWebViewController *webVC = [[WCWebViewController alloc] initWithOpenUrl:[PBCache shared].systemModel.agreementUrl title:@"用户协议"];
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 3:
        {
            WCWebViewController *webVC = [[WCWebViewController alloc] initWithOpenUrl:[PBCache shared].systemModel.privacyAgreementUrl title:@"隐私政策"];
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 4:
            
            break;
        default:
            break;
    }
}
- (void)switchAction{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (self.musicSwitch.isOn) {
        [def setValue:@"1" forKey:BACKGROUNDMUSIC];
    }else{
        [def setValue:@"0" forKey:BACKGROUNDMUSIC];
    }
    [def synchronize];
}
- (void)exitLogin{
    [[NSNotificationCenter defaultCenter] postNotificationName:gRelogin object:nil];
}

@end
