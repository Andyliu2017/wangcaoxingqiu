//
//  MyWalletController.m
//  wangcao
//
//  Created by EDZ on 2020/6/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import "MyWalletController.h"
#import "ShiMingController.h"
#import "MoneyRecordController.h"
#import "WithDrawController.h"
#import "WithdrawSuccessController.h"

@interface MyWalletController ()

@property (nonatomic,strong) UIScrollView *walletScroll;
@property (nonatomic,strong) UIView *whiteView1;
@property (nonatomic,strong) UIView *whiteView2;
@property (nonatomic,strong) UIView *whiteView3;
@property (nonatomic,strong) UIView *blackView4;
@property (nonatomic,strong) UIView *whiteView4;
//注意事项
@property (nonatomic,strong) UILabel *matterLabel;
//提现
@property (nonatomic,strong) UIButton *reflectBtn;
//余额
@property (nonatomic,strong) UILabel *balanceLabel;
//实名
@property (nonatomic,strong) UILabel *shimingLabel;
@property (nonatomic,strong) UIImageView *shimingImg;
//支付方式  支付宝
@property (nonatomic,strong) UIButton *alipayBtn;
/////
@property (nonatomic,assign) BOOL isShiMing;    //是否已实名
@property (nonatomic,strong) ShiMingModel *smModel;
@property (nonatomic,strong) NSString *tixianType;  //提现方式
@property (nonatomic,strong) RedButton *tixianRedBtn;   //提现金额
@property (nonatomic,strong) NSMutableArray *amountBtnArr;   //提现金额数组
@property (nonatomic,assign) NSInteger withdrawRate;  //提现手续费 万分之

@end

@implementation MyWalletController

- (NSMutableArray *)amountBtnArr{
    if (!_amountBtnArr) {
        _amountBtnArr = [NSMutableArray array];
    }
    return _amountBtnArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NavigationBarColor;
    [self createUI];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShiMingInfo) name:REFRESHSHIMINGINFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAccountAmount) name:WITHDRAWSUCCESS object:nil];
}

- (void)createUI{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"luck_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(23));
        make.top.mas_equalTo(ANDY_Adapta(88));
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    UIImageView *headrImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_title"]];
    [self.view addSubview:headrImg];
    [headrImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(spaceHeight(88));
        make.width.mas_equalTo(ANDY_Adapta(202));
        make.height.mas_equalTo(ANDY_Adapta(47));
    }];
    
    UILabel *mingxiLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(13) textColor:[UIColor whiteColor] text:@"收支明细" Radius:0];
    [self.view addSubview:mingxiLabel];
    [mingxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-ANDY_Adapta(20));
        make.centerY.mas_equalTo(headrImg);
        make.height.mas_equalTo(ANDY_Adapta(40));
    }];
    UIButton *mingxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mingxiBtn addTarget:self action:@selector(mingxiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mingxiBtn];
    [mingxiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(mingxiLabel);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    self.walletScroll = [[UIScrollView alloc] init];
    self.walletScroll.showsVerticalScrollIndicator = NO;
    self.walletScroll.bounces = NO;
    [self.view addSubview:self.walletScroll];
    [self.walletScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(headrImg.mas_bottom).offset(ANDY_Adapta(40));
    }];
    
    UIView *blackView1 = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.walletScroll addSubview:blackView1];
    [blackView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(10));
        make.centerX.mas_equalTo(self.walletScroll);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(285));
    }];
    self.whiteView1 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.walletScroll addSubview:self.whiteView1];
    [self.whiteView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.walletScroll);
        make.width.and.height.mas_equalTo(blackView1);
    }];
    
    UIView *blackView2 = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.walletScroll addSubview:blackView2];
    [blackView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blackView1.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(self.walletScroll);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(133));
    }];
    self.whiteView2 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.walletScroll addSubview:self.whiteView2];
    [self.whiteView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.whiteView1.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(self.walletScroll);
        make.width.and.height.mas_equalTo(blackView2);
    }];
    
    UIView *blackView3 = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.walletScroll addSubview:blackView3];
    [blackView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blackView2.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(self.walletScroll);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(227));
    }];
    self.whiteView3 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.walletScroll addSubview:self.whiteView3];
    [self.whiteView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.whiteView2.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(self.walletScroll);
        make.width.and.height.mas_equalTo(blackView3);
    }];
    
    self.blackView4 = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.walletScroll addSubview:self.blackView4];
    [self.blackView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blackView3.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(self.walletScroll);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(333));
    }];
    self.whiteView4 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.walletScroll addSubview:self.whiteView4];
//    [self.whiteView4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.whiteView3.mas_bottom).offset(ANDY_Adapta(20));
//        make.centerX.mas_equalTo(self.walletScroll);
//        make.width.and.height.mas_equalTo(self.blackView4);
//    }];
    
    UILabel *attentionMattersLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:RGBA(218, 199, 248, 1) text:@"注意事项" Radius:0];
    [self.walletScroll addSubview:attentionMattersLabel];
    [attentionMattersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.blackView4.mas_left);
        make.top.mas_equalTo(self.blackView4.mas_bottom).offset(ANDY_Adapta(30));
        make.width.mas_equalTo(self.blackView4);
    }];
        
    self.matterLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:FontBold_(12) textColor:RGBA(218, 199, 248, 1) text:@"" Radius:0];
    [self.walletScroll addSubview:self.matterLabel];
    [self.matterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(attentionMattersLabel.mas_left);
        make.top.mas_equalTo(attentionMattersLabel.mas_bottom).offset(ANDY_Adapta(30));
        make.width.mas_equalTo(attentionMattersLabel);
    }];
    
    self.reflectBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"立即提现" click:^(id  _Nonnull x) {
        [self tixianAction];
    }];
    [self.reflectBtn setBackgroundImage:[UIImage imageNamed:@"rank_invite"] forState:UIControlStateNormal];
    [self.walletScroll addSubview:self.reflectBtn];
    [self.reflectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.matterLabel.mas_bottom).offset(ANDY_Adapta(40));
        make.centerX.mas_equalTo(self.walletScroll);
        make.width.mas_equalTo(ANDY_Adapta(642));
        make.height.mas_equalTo(ANDY_Adapta(110));
    }];
    
    [self createWhiteViewOne];
    [self createWhiteViewTwo];
    [self createWhiteViewThree];
    [self createWhiteViewFour];
}

- (void)createWhiteViewOne{
    UILabel *balance = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(16) textColor:TitleColor text:@"可用余额(元)" Radius:0];
    [self.whiteView1 addSubview:balance];
    [balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView1);
        make.top.mas_equalTo(ANDY_Adapta(30));
    }];
    self.balanceLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(44) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView1 addSubview:self.balanceLabel];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(balance.mas_bottom);
        make.bottom.mas_equalTo(self.whiteView1);
        make.centerX.mas_equalTo(self.whiteView1);
    }];
}
- (void)createWhiteViewTwo{
    UILabel *smLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:TitleColor text:@"实名认证" Radius:0];
    [self.whiteView2 addSubview:smLabel];
    [smLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.whiteView2).offset(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(self.whiteView2);
    }];
    
    self.shimingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_arrow"]];
    [self.whiteView2 addSubview:self.shimingImg];
    [self.shimingImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.whiteView2);
        make.right.mas_equalTo(self.whiteView2).offset(-ANDY_Adapta(30));
        make.width.and.height.mas_equalTo(ANDY_Adapta(22));
    }];
    self.shimingLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(12) textColor:LineColor text:@"" Radius:0];
    [self.whiteView2 addSubview:self.shimingLabel];
    [self.shimingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shimingImg.mas_left).offset(-ANDY_Adapta(20));
        make.centerY.mas_equalTo(self.whiteView2);
    }];
    
    UIButton *shimingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shimingBtn addTarget:self action:@selector(shimingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView2 addSubview:shimingBtn];
    [shimingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.whiteView2);
    }];
}
- (void)createWhiteViewThree{
    UILabel *reflectLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:TitleColor text:@"提现方式" Radius:0];
    [self.whiteView3 addSubview:reflectLabel];
    [reflectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(self.whiteView3.mas_top);
        make.height.mas_equalTo(ANDY_Adapta(95));
    }];
    UIImageView *reflectImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_arrow"]];
    [self.whiteView3 addSubview:reflectImg];
    [reflectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(reflectLabel);
        make.right.mas_equalTo(self.whiteView3).offset(-ANDY_Adapta(30));
        make.width.and.height.mas_equalTo(ANDY_Adapta(22));
    }];
    UILabel *reflectDetail = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(12) textColor:LineColor text:@"提现明细" Radius:0];
    [self.whiteView3 addSubview:reflectDetail];
    [reflectDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(reflectLabel);
        make.right.mas_equalTo(reflectImg.mas_left).offset(-ANDY_Adapta(20));
    }];
    
    UIButton *mingxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mingxiBtn addTarget:self action:@selector(reflectDetailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView3 addSubview:mingxiBtn];
    [mingxiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(reflectDetail.mas_left);
        make.right.mas_equalTo(reflectImg.mas_right);
        make.centerY.mas_equalTo(reflectImg);
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
    
    self.alipayBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(14) normalColor:TitleColor normalText:@"支付宝" click:^(id  _Nonnull x) {
        
    }];
    [self.alipayBtn setTitleColor:RGBA(92, 88, 205, 1) forState:UIControlStateSelected];
    self.alipayBtn.layer.cornerRadius = ANDY_Adapta(20);
    self.alipayBtn.layer.masksToBounds = YES;
    self.alipayBtn.layer.borderWidth = ANDY_Adapta(1);
    self.alipayBtn.layer.borderColor = RGBA(228, 228, 228, 1).CGColor;
    [self.alipayBtn setBackgroundColor:[UIColor whiteColor]];
    [self.alipayBtn setImage:[UIImage imageNamed:@"wallet_ali"] forState:UIControlStateNormal];
    [self.alipayBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(15))];;
    [self.whiteView3 addSubview:self.alipayBtn];
    [self.alipayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reflectLabel.mas_bottom);
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.width.mas_equalTo(ANDY_Adapta(305));
        make.height.mas_equalTo(ANDY_Adapta(88));
    }];
    self.alipayBtn.selected = YES;
    self.alipayBtn.layer.borderColor = RGBA(92, 88, 205, 1).CGColor;
    [self.alipayBtn setBackgroundColor:RGBA(243, 241, 255, 1)];
}
- (void)createWhiteViewFour{
    UILabel *tixian = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:TitleColor text:@"普通提现" Radius:0];
    [self.whiteView4 addSubview:tixian];
    [tixian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(self.whiteView4);
        make.height.mas_equalTo(ANDY_Adapta(95));
    }];
}

- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    //获取提现配置
    [[manager ApiReflectConfig] subscribeNext:^(ReflectConfigModel *model) {
        self.withdrawRate = model.withdrawRate;
        //按钮排数
        NSInteger num = model.userWithdrawConfigVoList.count/3;
        NSInteger num1 = model.userWithdrawConfigVoList.count%3;
        NSInteger paiNum = 0;
        if (num1 > 0) {
            paiNum = num+1;
        }else{
            paiNum = num;
        }
        for (int i = 0; i < model.userWithdrawConfigVoList.count; i++) {
            ReflectListModel *listModel = model.userWithdrawConfigVoList[i];
            RedButton *redbtn = [RedButton buttonWithType:UIButtonTypeCustom];
            redbtn.redId = listModel.reflect_id;
            redbtn.amount = listModel.money;
            redbtn.firstFlag = listModel.firstFlag;
            [redbtn setImage:[UIImage imageNamed:@"wallet_tixianIcon"] forState:UIControlStateNormal];
            [redbtn setBackgroundImage:[UIImage imageNamed:@"wallet_tixianbg"] forState:UIControlStateSelected];
            [redbtn setTitle:[NSString stringWithFormat:@"%.0f元",listModel.money] forState:UIControlStateNormal];
            redbtn.layer.cornerRadius = ANDY_Adapta(20);
            redbtn.layer.borderColor = RGBA(228, 228, 228, 1).CGColor;
            [redbtn setTitleColor:TitleColor forState:UIControlStateNormal];
            [redbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(15))];
            [redbtn addTarget:self action:@selector(selectTiXianAmount:) forControlEvents:UIControlEventTouchUpInside];
            [self.whiteView4 addSubview:redbtn];
            [redbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(ANDY_Adapta(95)+ANDY_Adapta(108)*(i/3));
                make.left.mas_equalTo(ANDY_Adapta(30)+ANDY_Adapta(216)*(i%3));
                make.width.mas_equalTo(ANDY_Adapta(196));
                make.height.mas_equalTo(ANDY_Adapta(88));
            }];
            [self.amountBtnArr addObject:redbtn];
            //默认选中第一个
            if (i == 0) {
                redbtn.selected = YES;
                self.tixianRedBtn = redbtn;
                redbtn.layer.masksToBounds = NO;
                redbtn.layer.borderWidth = ANDY_Adapta(0);
            }else{
                redbtn.layer.masksToBounds = YES;
                redbtn.layer.borderWidth = ANDY_Adapta(1);
            }
        }
        [self.whiteView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.whiteView3.mas_bottom).offset(ANDY_Adapta(20));
            make.centerX.mas_equalTo(self.walletScroll);
            make.width.mas_equalTo(self.blackView4);
            make.height.mas_equalTo(ANDY_Adapta(135)+ANDY_Adapta(88)*paiNum+ANDY_Adapta(20)*(paiNum-1));
        }];
        self.matterLabel.text = model.attentionMatters;
        CGSize baseSize = CGSizeMake(ANDY_Adapta(690), CGFLOAT_MAX);
        CGSize labelsize = [self.matterLabel sizeThatFits:baseSize];
        self.walletScroll.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1150)+labelsize.height+ANDY_Adapta(88)*paiNum+ANDY_Adapta(20)*(paiNum-1));
    } error:^(NSError * _Nullable error) {
        
    }];
    [self getAccountAmount];
    [self getShiMingInfo];
}
//获取账户可用余额
- (void)getAccountAmount{
    WCApiManager *manager = [WCApiManager sharedManager];
    //用户账户信息
    [[manager ApiUserAccountInfo] subscribeNext:^(UserAccountModel *model) {
        self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",model.enabledMoney];
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)getShiMingInfo{
    WCApiManager *manager = [WCApiManager sharedManager];
    //用户实名信息
    [[manager ApiUserShiMingInfo] subscribeNext:^(ShiMingModel *model) {
        self.smModel = model;
        if (model == nil) {
            self.isShiMing = NO;
            self.shimingLabel.text = @"未实名";
            self.shimingLabel.textColor = LineColor;
            self.shimingImg.image = [UIImage imageNamed:@"feed_arrow"];
        }else{
            if (model.status == -1) {
                self.shimingLabel.text = @"未实名";
                self.shimingLabel.textColor = LineColor;
                self.shimingImg.image = [UIImage imageNamed:@"feed_arrow"];
                self.isShiMing = NO;
            }else if (model.status == 1){
                self.shimingLabel.text = @"已实名";
                self.shimingLabel.textColor = RGBA(71, 195, 94, 1);
                self.shimingImg.image = [UIImage imageNamed:@"wallet_shiming"];
                self.isShiMing = YES;
            }else{
                self.shimingLabel.text = @"审核中";
                self.shimingLabel.textColor = LineColor;
                self.shimingImg.image = [UIImage imageNamed:@"feed_arrow"];
                self.isShiMing = NO;
            }
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
//收支明细
- (void)mingxiAction{
    MoneyRecordController *vc = [[MoneyRecordController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//实名认证
- (void)shimingAction{
    ShiMingController *vc = [[ShiMingController alloc] init];
    vc.isShiMing = self.isShiMing;
    vc.smModel = self.smModel;
    [self.navigationController pushViewController:vc animated:YES];
}
//提现明细
- (void)reflectDetailAction{
    WithDrawController *vc = [[WithDrawController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//选择提现金额
- (void)selectTiXianAmount:(RedButton *)btn{
    if (self.tixianRedBtn == btn) {
        return;
    }
    self.tixianRedBtn = btn;
    for (int i = 0; i < self.amountBtnArr.count; i++) {
        RedButton *redbtn = self.amountBtnArr[i];
        if (redbtn == btn) {
            redbtn.selected = YES;
            redbtn.layer.masksToBounds = NO;
            redbtn.layer.borderWidth = ANDY_Adapta(0);
        }else{
            redbtn.selected = NO;
            redbtn.layer.masksToBounds = YES;
            redbtn.layer.borderWidth = ANDY_Adapta(1);
        }
    }
}
//立即提现
- (void)tixianAction{
    if (!self.isShiMing) {
        [MBProgressHUD showText:@"未实名" toView:self.view afterDelay:1.0];
        return;;
    }
    if (!self.tixianRedBtn) {
        [MBProgressHUD showText:@"请选择提现金额" toView:self.view afterDelay:1.0];
        return;
    }
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiWithdrawalWithPayType:@"ALIPAY" userBankId:@"" userWithdrawConfigId:self.tixianRedBtn.redId] subscribeNext:^(id  _Nullable x) {
        WithdrawSuccessController *vc = [[WithdrawSuccessController alloc] init];
        vc.amount = self.tixianRedBtn.amount;
        if (self.tixianRedBtn.firstFlag) {
            vc.shouxuAmount = 0;
        }else{
            CGFloat rate = self.withdrawRate/10000.0;
            vc.shouxuAmount = self.tixianRedBtn.amount*rate;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)backAction{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESHSHIMINGINFO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WITHDRAWSUCCESS object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
