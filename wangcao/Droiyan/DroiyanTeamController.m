//
//  DroiyanTeamController.m
//  wangcao
//
//  Created by EDZ on 2020/5/9.
//  Copyright © 2020 andy. All rights reserved.
//

#import "DroiyanTeamController.h"
#import "MyFriendController.h"
#import "TodayProfitController.h"
#import "SharePopView.h"
#import "BindInvitaView.h"
#import "QQWechatView.h"
#import "ReferView.h"

#define DyColor RGBA(170, 170, 170, 1)

@interface DroiyanTeamController ()

@property (nonatomic,strong) UIScrollView *dyScrollView;
@property (nonatomic,strong) UIView *teamView1;
@property (nonatomic,strong) UIView *teamView2;
@property (nonatomic,strong) UIView *teamView3;
//teamView4 未绑定邀请码显示邀请页面  已绑定但是没有邀请人信息隐藏  已绑定有邀请人信息显示邀请人信息
@property (nonatomic,strong) UIView *teamView4;
//view1
@property (nonatomic,strong) UILabel *teamNumLabel;
//好友
@property (nonatomic,strong) UILabel *friendLabel1;  //直邀好友
@property (nonatomic,strong) UILabel *friendLabel2;  //扩散好友
@property (nonatomic,strong) UILabel *friendLabel3;  //通讯录好友
//好友详情
@property (nonatomic,strong) UILabel *friendInfoLabel;
//当前战队总收益
@property (nonatomic,strong) UILabel *totalProfit;
//加速金额
@property (nonatomic,strong) UILabel *totalFeed;
//阶段 加速倍数
@property (nonatomic,strong) UILabel *stageLabel;
//战队累计进度条
@property (nonatomic,strong) UIProgressView *teamProgress;
//战队累计 描述
@property (nonatomic,strong) UILabel *totalContent;
//今日活跃
@property (nonatomic,strong) UILabel *todayActive;
@property (nonatomic,strong) UILabel *todayTotal;   //今日合计
@property (nonatomic,strong) UILabel *todayZhijie;  //直接好友贡献
@property (nonatomic,strong) UILabel *todayKuosan;  //扩散好友贡献
@property (nonatomic,strong) UIView *inviateView;
@property (nonatomic,strong) UIView *referUserView;
@property (nonatomic,strong) UIImageView *referUserImg;  //邀请人头像
@property (nonatomic,strong) UILabel *referUserName;    //邀请人名称
@property (nonatomic,strong) UILabel *referUserIncome;  //邀请人收益
//分享弹窗
@property (nonatomic,strong) SharePopView *shareView;
//邀请人对象
@property (nonatomic,strong) UserTeamModel *referModel;

@end

@implementation DroiyanTeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NavigationBarColor;
    [self createUI];
    [self getData];
}
#pragma mark 数据
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiTeamSubCount] subscribeNext:^(UserTeamModel *model) {
        self.referModel = model;
        if (!model.bindInviteCode) {   //未绑定 显示邀请view
            self.teamView4.hidden = NO;
            self.dyScrollView.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1760));
            self.referUserView.hidden = YES;
            self.inviateView.hidden = NO;
        }else{   //已绑定
            if (model.bindInviteCode) {   //有上级
                self.teamView4.hidden = NO;
                self.dyScrollView.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1760));
                self.referUserView.hidden = NO;
                self.inviateView.hidden = YES;
                [self setReferUserViewData:model];
            }else{   //无上级 首码  隐藏view
                self.teamView4.hidden = YES;
                self.dyScrollView.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1625));
            }
        }
//        if ((model.bindInviteCode && model.referUser) || !model.bindInviteCode) { //已绑定且有邀请人信息 或 未绑定  已绑定没有邀请人信息首码
//            self.teamView4.hidden = NO;
//            self.dyScrollView.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1760));
//            if (model.bindInviteCode) {
//                self.referUserView.hidden = NO;
//                self.inviateView.hidden = YES;
//                [self setReferUserViewData:model];
//            }else{
//                
//            }
//        }else{
//            
//        }
        //设置战队人数数据
        [self setTeamViewOneData:model];
    } error:^(NSError * _Nullable error) {
        
    }];
    //未实名收益及人数
    [[manager ApiTeamUncertMoney] subscribeNext:^(UncertInfoVoModel *model) {
        self.friendInfoLabel.text = [NSString stringWithFormat:@"当前未实名好友%ld人，已替您产生收入%@元 通知好友完成实名即可获得收入",model.uncertCount,model.uncertMoney];
    } error:^(NSError * _Nullable error) {
        
    }];
    //战队累计收益
    [[manager ApiTeamIncome] subscribeNext:^(UserTeamModel *model) {
        self.totalProfit.text = [NSString stringWithFormat:@"%.2f",model.stageMoney];
        self.totalFeed.text = [NSString stringWithFormat:@"%.2f",model.targetMoney];
        self.stageLabel.text = [NSString stringWithFormat:@"%@下x%.1f倍加速",model.name,model.ratio];
        //进度 当前收益/目标收益
        CGFloat pro = model.stageMoney / model.targetMoney;
        self.teamProgress.progress = pro;
        self.totalContent.text = [NSString stringWithFormat:@"已解锁%@，解锁后你将有%.2f元自动存入钱包x%.1f被加速",[NSString stringWithFormat:@"%.2f%%",pro*100],model.targetMoney,model.ratio];
    } error:^(NSError * _Nullable error) {
        
    }];
    //今日战队收益
    [[manager ApiTeamIncomeToday] subscribeNext:^(UserTeamModel *model) {
        self.todayActive.text = [NSString stringWithFormat:@"(%ld人活跃)",model.activeUser];
        self.todayTotal.text = [NSString stringWithFormat:@"%.2f元",model.totalAmount];
        self.todayZhijie.text = [NSString stringWithFormat:@"%.2f元",model.directAmount];
        self.todayKuosan.text = [NSString stringWithFormat:@"%.2f元",model.indirectAmount];
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)setTeamViewOneData:(UserTeamModel *)model{
    self.teamNumLabel.text = [NSString stringWithFormat:@"%ld人",model.totalCount];
    self.friendLabel1.text = [NSString stringWithFormat:@"%ld",model.directCount];
    self.friendLabel2.text = [NSString stringWithFormat:@"%ld",model.indirectCount];
    self.friendLabel3.text = [NSString stringWithFormat:@"%ld",model.contactCount];
}
- (void)setReferUserViewData:(UserTeamModel *)model{
    [self.referUserImg setImageWithURL:[NSURL URLWithString:model.referUser.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.referUserName.text = [NSString stringWithFormat:@"我的邀请人：%@",model.referUser.nickName];
    self.referUserIncome.text = [NSString stringWithFormat:@"%.2f",model.referUser.income];
}
#pragma mark UI
- (void)createUI{
    self.dyScrollView = [[UIScrollView alloc] init];
    self.dyScrollView.userInteractionEnabled = YES;
    self.dyScrollView.showsVerticalScrollIndicator = NO;
    self.dyScrollView.bounces = NO;
    [self.view addSubview:self.dyScrollView];
    [self.dyScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    
    UIImageView *titleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_my"]];
    [self.dyScrollView addSubview:titleImg];
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(85));
        make.top.mas_equalTo(ANDY_Adapta(95));
        make.width.mas_equalTo(ANDY_Adapta(279));
        make.height.mas_equalTo(ANDY_Adapta(63));
    }];
    
    UIImageView *headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_head"]];
    headImg.frame = CGRectMake(SCREENWIDTH-ANDY_Adapta(262), ANDY_Adapta(17), ANDY_Adapta(262), ANDY_Adapta(288));
    [self.dyScrollView addSubview:headImg];
//    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.dyScrollView.mas_top).offset(ANDY_Adapta(17));
//        make.right.mas_equalTo(self.dyScrollView.mas_right);
//        make.width.mas_equalTo(ANDY_Adapta(262));
//        make.height.mas_equalTo(ANDY_Adapta(288));
//    }];
    
    UILabel *label = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:FontBold_(16) textColor:[UIColor whiteColor] text:@"队友越多越活跃、越快解锁越快得分红玉玺" Radius:0];
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
    label.transform = matrix;
    [self.dyScrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleImg.mas_left);
        make.top.mas_equalTo(titleImg.mas_bottom).offset(ANDY_Adapta(25));
        make.width.mas_equalTo(ANDY_Adapta(390));
    }];
    
    UIView *blackView1 = [GGUI ui_viewBlackAndWhite:BlackBgColor];
    [self.dyScrollView addSubview:blackView1];
    
    self.teamView1 = [GGUI ui_viewBlackAndWhite:[UIColor whiteColor]];
    [self.dyScrollView addSubview:self.teamView1];
//    if ([PBCache shared].memberModel.userType == 2) {
//        blackView1.hidden = YES;
//        self.teamView1.hidden = YES;
//        [blackView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.dyScrollView);
//            make.top.mas_equalTo(ANDY_Adapta(303));
//            make.width.mas_equalTo(ANDY_Adapta(689));
//            make.height.mas_equalTo(0);
//        }];
//    }else{
        [blackView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.dyScrollView);
            make.top.mas_equalTo(ANDY_Adapta(303));
            make.width.mas_equalTo(ANDY_Adapta(689));
            make.height.mas_equalTo(ANDY_Adapta(500));
        }];
//    }
    [self.teamView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.and.height.mas_equalTo(blackView1);
        make.top.mas_equalTo(blackView1.mas_top).offset(-ANDY_Adapta(10));
    }];
    
    UIView *blackView2 = [GGUI ui_viewBlackAndWhite:BlackBgColor];
    [self.dyScrollView addSubview:blackView2];
    [blackView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.dyScrollView);
        make.top.mas_equalTo(blackView1.mas_bottom).offset(ANDY_Adapta(20));
        make.width.mas_equalTo(ANDY_Adapta(689));
        make.height.mas_equalTo(ANDY_Adapta(427));
    }];
    self.teamView2 = [GGUI ui_viewBlackAndWhite:[UIColor whiteColor]];
    [self.dyScrollView addSubview:self.teamView2];
    [self.teamView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.and.height.mas_equalTo(blackView2);
        make.top.mas_equalTo(blackView2.mas_top).offset(-ANDY_Adapta(10));
    }];
    
    UIView *blackView3 = [GGUI ui_viewBlackAndWhite:BlackBgColor];
    [self.dyScrollView addSubview:blackView3];
    [blackView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blackView2.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(self.dyScrollView);
        make.width.mas_equalTo(ANDY_Adapta(689));
        make.height.mas_equalTo(ANDY_Adapta(253));
    }];
    self.teamView3 = [GGUI ui_viewBlackAndWhite:[UIColor whiteColor]];
    [self.dyScrollView addSubview:self.teamView3];
    [self.teamView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.and.height.mas_equalTo(blackView3);
        make.top.mas_equalTo(blackView3.mas_top).offset(-ANDY_Adapta(10));
    }];
    
    UIView *blackView4 = [GGUI ui_viewBlackAndWhite:BlackBgColor];
    [self.dyScrollView addSubview:blackView4];
    [blackView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blackView3.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(self.dyScrollView);
        make.width.mas_equalTo(ANDY_Adapta(689));
        make.height.mas_equalTo(ANDY_Adapta(147));
    }];
    self.teamView4 = [GGUI ui_viewBlackAndWhite:[UIColor whiteColor]];
    [self.dyScrollView addSubview:self.teamView4];
    [self.teamView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.and.height.mas_equalTo(blackView4);
        make.top.mas_equalTo(blackView4.mas_top).offset(-ANDY_Adapta(10));
    }];
    
    [self createTeamViewOne];
    [self createTeamViewTwo];
    [self createTeamViewThree];
    [self createInviateView];
    [self CreateReferUserView];
}
- (void)createTeamViewOne{
    UILabel *teamLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"战队人数" Radius:0];
    [self.teamView1 addSubview:teamLabel];
    [teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(39));
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(ANDY_Adapta(325));
        make.height.mas_equalTo(ANDY_Adapta(97));
    }];
    self.teamNumLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(15) textColor:DyColor text:@"" Radius:0];
    [self.teamView1 addSubview:self.teamNumLabel];
    [self.teamNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(teamLabel.mas_right);
        make.top.and.height.mas_equalTo(teamLabel);
        make.width.mas_equalTo(ANDY_Adapta(269));
    }];
    //箭头
    UIImageView *jtImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_arrow"]];
    [self.teamView1 addSubview:jtImg];
    [jtImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.teamNumLabel.mas_right).offset(ANDY_Adapta(6));
        make.centerY.mas_equalTo(self.teamNumLabel);
        make.width.and.height.mas_equalTo(ANDY_Adapta(16));
    }];
    //我的战队点击
    UIButton *teamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [teamBtn addTarget:self action:@selector(teamAction) forControlEvents:UIControlEventTouchUpInside];
    [self.teamView1 addSubview:teamBtn];
    [teamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.centerY.mas_equalTo(jtImg);
        make.width.mas_equalTo(ANDY_Adapta(110));
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = DyColor;
    [self.teamView1 addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(teamLabel.mas_bottom);
        make.left.mas_equalTo(ANDY_Adapta(35));
        make.width.mas_equalTo(ANDY_Adapta(622));
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    //好友 直邀
    self.friendLabel1 = [GGUI ui_label:self.view.bounds lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:TitleColor text:@"" Radius:0];
    [self.teamView1 addSubview:self.friendLabel1];
    [self.friendLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(24));
        make.top.mas_equalTo(lineImg.mas_bottom).offset(ANDY_Adapta(19));
        make.width.mas_equalTo(ANDY_Adapta(207));
        make.height.mas_equalTo(ANDY_Adapta(55));
    }];
    //扩散
    self.friendLabel2 = [GGUI ui_label:self.view.bounds lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:TitleColor text:@"" Radius:0];
    [self.teamView1 addSubview:self.friendLabel2];
    [self.friendLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.friendLabel1.mas_right);
        make.top.and.height.mas_equalTo(self.friendLabel1);
        make.width.mas_equalTo(ANDY_Adapta(230));
    }];
    //通讯录
    self.friendLabel3 = [GGUI ui_label:self.view.bounds lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:TitleColor text:@"" Radius:0];
    [self.teamView1 addSubview:self.friendLabel3];
    [self.friendLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.friendLabel2.mas_right);
        make.top.and.height.mas_equalTo(self.friendLabel2);
        make.width.mas_equalTo(ANDY_Adapta(204));
    }];
    UILabel *inviatLabel1 = [GGUI ui_label:self.view.bounds lines:1 align:NSTextAlignmentCenter font:Font_(13) textColor:DyColor text:@"直邀好友" Radius:0];
    [self.teamView1 addSubview:inviatLabel1];
    [inviatLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.friendLabel1);
        make.top.mas_equalTo(self.friendLabel1.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(207));
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
    UIImageView *lineImg1 = [[UIImageView alloc] init];
    lineImg1.backgroundColor = DyColor;
    [self.teamView1 addSubview:lineImg1];
    [lineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(inviatLabel1);
        make.left.mas_equalTo(inviatLabel1.mas_right);
        make.width.mas_equalTo(ANDY_Adapta(1));
    }];
    UILabel *inviatLabel2 = [GGUI ui_label:self.view.bounds lines:1 align:NSTextAlignmentCenter font:Font_(13) textColor:DyColor text:@"扩散好友" Radius:0];
    [self.teamView1 addSubview:inviatLabel2];
    [inviatLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(inviatLabel1);
        make.left.mas_equalTo(lineImg1.mas_right);
        make.width.mas_equalTo(ANDY_Adapta(228));
    }];
    UIImageView *lineImg2 = [[UIImageView alloc] init];
    lineImg2.backgroundColor = DyColor;
    [self.teamView1 addSubview:lineImg2];
    [lineImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(inviatLabel1);
        make.left.mas_equalTo(inviatLabel2.mas_right);
        make.width.mas_equalTo(ANDY_Adapta(1));
    }];
    UILabel *inviatLabel3 = [GGUI ui_label:self.view.bounds lines:1 align:NSTextAlignmentCenter font:Font_(13) textColor:DyColor text:@"通讯录好友" Radius:0];
    [self.teamView1 addSubview:inviatLabel3];
    [inviatLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(inviatLabel2);
        make.left.mas_equalTo(lineImg2.mas_right);
        make.width.mas_equalTo(ANDY_Adapta(204));
    }];
    //邀请好友 按钮
    UIButton *inviatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviatBtn setBackgroundImage:[UIImage imageNamed:@"rank_invite"] forState:UIControlStateNormal];
    [inviatBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
    [inviatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inviatBtn addTarget:self action:@selector(inviatAction) forControlEvents:UIControlEventTouchUpInside];
    inviatBtn.titleLabel.font = FontBold_(17);
    [self.teamView1 addSubview:inviatBtn];
    [inviatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.teamView1);
        make.top.mas_equalTo(inviatLabel1.mas_bottom).offset(ANDY_Adapta(33));
        make.width.mas_equalTo(ANDY_Adapta(642));
        make.height.mas_equalTo(ANDY_Adapta(110));
    }];
//    if (![WXApi isWXAppInstalled]) {
//        inviatBtn.hidden = YES;
//    }
    
    self.friendInfoLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentCenter font:Font_(12) textColor:DyColor text:@"当前未实名好友242人，已替您产生收入100.5元 通知好友完成实名即可获得收入" Radius:0];
    [self.teamView1 addSubview:self.friendInfoLabel];
    [self.friendInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.teamView1);
        make.top.mas_equalTo(inviatBtn.mas_bottom).offset(ANDY_Adapta(13));
        make.width.mas_equalTo(ANDY_Adapta(517));
        make.height.mas_equalTo(ANDY_Adapta(80));
    }];
}
- (void)createTeamViewTwo{
    //战队收益
    UILabel *teamProfit = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"战队累计收益" Radius:0];
    [self.teamView2  addSubview:teamProfit];
    [teamProfit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(39));
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(ANDY_Adapta(300));
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    UILabel *ruleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(15) textColor:DyColor text:@"玩法规则" Radius:0];
    [self.teamView2 addSubview:ruleLabel];
    [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(teamProfit.mas_right);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(ANDY_Adapta(279));
        make.height.mas_equalTo(teamProfit);
    }];
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_arrow"]];
    [self.view addSubview:arrowImg];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ruleLabel.mas_right).offset(ANDY_Adapta(25));
        make.centerY.mas_equalTo(ruleLabel);
        make.width.and.height.mas_equalTo(ANDY_Adapta(16));
    }];
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ruleBtn addTarget:self action:@selector(ruleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.teamView2 addSubview:ruleBtn];
    [ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrowImg.mas_right);
        make.centerY.mas_equalTo(arrowImg);
        make.height.mas_equalTo(ANDY_Adapta(60));
        make.width.mas_equalTo(ANDY_Adapta(200));
    }];
    
//    if ([PBCache shared].memberModel.userType == 2) {   //审核账号
//        ruleLabel.hidden = YES;
//        arrowImg.hidden = YES;
//        ruleBtn.hidden = YES;
//    }
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = DyColor;
    [self.teamView2 addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.teamView2);
        make.top.mas_equalTo(teamProfit.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(622));
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    UIImageView *lineImg1 = [[UIImageView alloc] init];
    lineImg1.backgroundColor = DyColor;
    [self.teamView2 addSubview:lineImg1];
    [lineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(lineImg.mas_bottom).offset(ANDY_Adapta(61));
        make.width.mas_equalTo(ANDY_Adapta(1));
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
    
    self.totalProfit = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(21) textColor:RGBA(249, 100, 100, 1) text:@"" Radius:0];
    [self.teamView2 addSubview:self.totalProfit];
    [self.totalProfit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineImg.mas_left);
        make.right.mas_equalTo(lineImg1.mas_left);
        make.top.mas_equalTo(lineImg).offset(ANDY_Adapta(32));
        make.height.mas_equalTo(ANDY_Adapta(62));
    }];
    UILabel *totalLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:DyColor text:@"当前阶段总收入" Radius:0];
    [self.teamView2 addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalProfit.mas_bottom);
        make.left.and.right.mas_equalTo(self.totalProfit);
        make.height.mas_equalTo(ANDY_Adapta(50));
    }];
    //第三阶段下x1.0倍加速
    self.totalFeed = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(21) textColor:RGBA(254, 172, 56, 1) text:@"" Radius:0];
    [self.teamView2 addSubview:self.totalFeed];
    [self.totalFeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineImg1.mas_right);
        make.right.mas_equalTo(lineImg.mas_right);
        make.top.and.bottom.mas_equalTo(self.totalProfit);
    }];
    self.stageLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:DyColor text:@"" Radius:0];
    [self.teamView2 addSubview:self.stageLabel];
    [self.stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.totalFeed);
        make.top.mas_equalTo(self.totalFeed.mas_bottom);
        make.height.mas_equalTo(totalLabel);
    }];
    
    self.teamProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.teamProgress.layer.cornerRadius = ANDY_Adapta(7);
    self.teamProgress.layer.masksToBounds = YES;
    self.teamProgress.progress = 0.3;
    //已过进度条颜色
    self.teamProgress.progressTintColor = RGBA(71, 195, 94, 1);
    //未过
    self.teamProgress.trackTintColor = RGBA(238, 238, 238, 1);
    [self.teamView2 addSubview:self.teamProgress];
    [self.teamProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.teamView2);
        make.top.mas_equalTo(totalLabel.mas_bottom).offset(ANDY_Adapta(23));
        make.width.mas_equalTo(ANDY_Adapta(610));
        make.height.mas_equalTo(ANDY_Adapta(14));
    }];
    //已解锁85.48%，解锁后你将有100.0元自动存入钱包x1.0被加速
    self.totalContent = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:Font_(12) textColor:DyColor text:@"" Radius:0];
    [self.teamView2 addSubview:self.totalContent];
    [self.totalContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.teamProgress.mas_bottom).offset(ANDY_Adapta(42));
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
}
- (void)createTeamViewThree{
    UILabel *todayLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"今日战队收益" Radius:0];
    [self.teamView3 addSubview:todayLabel];
    [todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(35));
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(ANDY_Adapta(220));
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    self.todayActive = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(15) textColor:DyColor text:@"" Radius:0];
    [self.teamView3 addSubview:self.todayActive];
    [self.todayActive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(todayLabel.mas_right);
        make.top.and.bottom.mas_equalTo(todayLabel);
        make.width.mas_equalTo(ANDY_Adapta(200));
    }];
    
    UILabel *todayDetail = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(15) textColor:DyColor text:@"今日明细" Radius:0];
    [self.teamView3 addSubview:todayDetail];
    [todayDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.todayActive.mas_right);
        make.top.and.bottom.mas_equalTo(self.todayActive);
        make.width.mas_equalTo(ANDY_Adapta(185));
    }];
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_arrow"]];
    [self.teamView3 addSubview:arrowImg];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(todayDetail);
        make.left.mas_equalTo(todayDetail.mas_right).offset(ANDY_Adapta(15));
        make.width.and.height.mas_equalTo(ANDY_Adapta(16));
    }];
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.teamView3 addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrowImg.mas_right);
        make.centerY.mas_equalTo(arrowImg);
        make.width.mas_equalTo(ANDY_Adapta(150));
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = DyColor;
    [self.teamView3 addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(todayLabel.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(622));
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    UIImageView *lineImg1 = [[UIImageView alloc] init];
    lineImg1.backgroundColor = DyColor;
    [self.teamView3 addSubview:lineImg1];
    [lineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineImg.mas_bottom).offset(ANDY_Adapta(46));
        make.left.mas_equalTo(ANDY_Adapta(229));
        make.width.mas_equalTo(ANDY_Adapta(1));
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
    UIImageView *lineImg2 = [[UIImageView alloc] init];
    lineImg2.backgroundColor = DyColor;
    [self.teamView3 addSubview:lineImg2];
    [lineImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.and.height.mas_equalTo(lineImg1);
        make.left.mas_equalTo(lineImg1.mas_right).offset(ANDY_Adapta(228));
    }];
    self.todayTotal = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:RGBA(249, 100, 100, 1) text:@"" Radius:0];
    [self.teamView3 addSubview:self.todayTotal];
    [self.todayTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineImg.mas_left);
        make.top.mas_equalTo(lineImg.mas_bottom).offset(ANDY_Adapta(20));
        make.right.mas_equalTo(lineImg1.mas_left);
        make.height.mas_equalTo(ANDY_Adapta(57));
    }];
    UILabel *totalLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(13) textColor:DyColor text:@"合计" Radius:0];
    [self.teamView3 addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.centerX.mas_equalTo(self.todayTotal);
        make.top.mas_equalTo(self.todayTotal.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(53));
    }];
    
    self.todayZhijie = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:RGBA(249, 100, 100, 1) text:@"" Radius:0];
    [self.teamView3 addSubview:self.todayZhijie];
    [self.todayZhijie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(self.todayTotal);
        make.centerX.mas_equalTo(self.teamView3);
//        make.left.mas_equalTo(lineImg1.mas_right);
//        make.right.mas_equalTo(lineImg1.mas_left);
    }];
    UILabel *zhijieLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(13) textColor:DyColor text:@"直接好友贡献" Radius:0];
    [self.teamView3 addSubview:zhijieLabel];
    [zhijieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(totalLabel);
        make.left.mas_equalTo(lineImg1.mas_right);
        make.right.mas_equalTo(lineImg2.mas_left);
    }];
    
    self.todayKuosan = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:TitleColor text:@"" Radius:0];
    [self.teamView3 addSubview:self.todayKuosan];
    [self.todayKuosan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(self.todayTotal);
        make.left.mas_equalTo(lineImg2.mas_right);
        make.right.mas_equalTo(lineImg.mas_right);
    }];
    UILabel *kuosanLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(13) textColor:DyColor text:@"扩散好友贡献" Radius:0];
    [self.teamView3 addSubview:kuosanLabel];
    [kuosanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(totalLabel);
        make.left.mas_equalTo(lineImg2.mas_right);
        make.right.mas_equalTo(lineImg.mas_right);
    }];
}
//未绑定邀请码
- (void)createInviateView{
    self.inviateView = [[UIView alloc] init];
    self.inviateView.hidden = YES;
    self.inviateView.backgroundColor = [UIColor clearColor];
    [self.teamView4 addSubview:self.inviateView];
    [self.inviateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.teamView4);
    }];
    UIImageView *inviateImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_inviate"]];
    [self.inviateView addSubview:inviateImg];
    [inviateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(25));
        make.centerY.mas_equalTo(self.inviateView);
        make.width.and.height.mas_equalTo(ANDY_Adapta(65));
    }];
    UILabel *inviateLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:TitleColor text:@"点击添加邀请人信息" Radius:0];
    [self.inviateView addSubview:inviateLabel];
    [inviateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inviateImg.mas_right).offset(ANDY_Adapta(19));
        make.top.and.bottom.and.right.mas_equalTo(self.inviateView);
    }];
    UIButton *inviateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviateBtn addTarget:self action:@selector(addInviteInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.inviateView addSubview:inviateBtn];
    [inviateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.inviateView);
    }];
}
//绑定 有推荐人信息
- (void)CreateReferUserView{
    self.referUserView = [[UIView alloc] init];
    self.referUserView.hidden = YES;
    self.referUserView.backgroundColor = [UIColor clearColor];
    [self.teamView4 addSubview:self.referUserView];
    [self.referUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.teamView4);
    }];
    self.referUserImg = [[UIImageView alloc] init];
    self.referUserImg.layer.cornerRadius = ANDY_Adapta(44);
    self.referUserImg.layer.masksToBounds = YES;
    [self.referUserView addSubview:self.referUserImg];
    [self.referUserImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(24));
        make.centerY.mas_equalTo(0);
        make.width.and.height.mas_equalTo(ANDY_Adapta(88));
    }];
    self.referUserName = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:TitleColor text:@"我的邀请人：" Radius:0];
    [self.referUserView addSubview:self.referUserName];
    [self.referUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.referUserImg.mas_right).offset(ANDY_Adapta(16));
        make.top.mas_equalTo(self.referUserImg.mas_top);
        make.width.mas_equalTo(ANDY_Adapta(340));
        make.height.mas_equalTo(ANDY_Adapta(44));
    }];
    UILabel *contactLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(12) textColor:DyColor text:@"联系TA" Radius:0];
    [self.referUserView  addSubview:contactLabel];
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_arrow"]];
    [self.referUserView addSubview:arrowImg];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contactLabel.mas_right).offset(ANDY_Adapta(5));
        make.centerY.mas_equalTo(contactLabel);
        make.height.and.width.mas_equalTo(ANDY_Adapta(16));
    }];
    
    UILabel *incomeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(12) textColor:TitleColor text:@"累计收入：" Radius:0];
    [self.referUserView addSubview:incomeLabel];
    [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.referUserName.mas_bottom);
        make.left.and.height.mas_equalTo(self.referUserName);
    }];
    self.referUserIncome = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:MoneyColor text:@"" Radius:0];
    [self.referUserView addSubview:self.referUserIncome];
    [self.referUserIncome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(incomeLabel.mas_right).offset(ANDY_Adapta(13));
        make.top.and.height.mas_equalTo(incomeLabel);
    }];
    
    UILabel *lianxiLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(12) textColor:GrayColor text:@"联系他 >" Radius:0];
    [self.referUserView addSubview:lianxiLabel];
    [lianxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.referUserView.mas_right).offset(-ANDY_Adapta(40));
        make.centerY.mas_equalTo(self.referUserName);
    }];
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactBtn addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
    [self.referUserView addSubview:contactBtn];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.referUserView);
    }];
}

#pragma mark Action
//我的战队
- (void)teamAction{
    MyFriendController *vc = [[MyFriendController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//邀请好友
- (void)inviatAction{
    self.shareView = [SharePopView new];
    [self.shareView setDataWithImg:[UIImage imageNamed:@"share_invate_bg"] type:1 teamNum:[PBCache shared].userModel.invitecode nickName:[PBCache shared].userModel.nickName qrcode:[PBCache shared].userModel.qrcode];
    [self.shareView showView];
}
//今日明细
- (void)detailAction{
    TodayProfitController *vc = [[TodayProfitController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//添加邀请人信息
- (void)addInviteInfo{
    BindInvitaView *bindView = [[BindInvitaView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [bindView showPopView:self];
    __block DroiyanTeamController *weakSelf = self;
    //绑定成功
    bindView.bindblock = ^{
        [weakSelf refreshUI];
    };
}
//绑定成功刷新页面
- (void)refreshUI{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiTeamSubCount] subscribeNext:^(UserTeamModel *model) {
        self.referModel = model;
        if ((model.bindInviteCode && model.referUser) || !model.bindInviteCode) { //已绑定且有邀请人信息 或 未绑定
            self.teamView4.hidden = NO;
            self.dyScrollView.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1746));
            if (model.bindInviteCode) {
                self.referUserView.hidden = NO;
                self.inviateView.hidden = YES;
                [self setReferUserViewData:model];
            }else{
                self.referUserView.hidden = YES;
                self.inviateView.hidden = NO;
            }
        }else{
            self.teamView4.hidden = YES;
            self.dyScrollView.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1579));
        }
        //设置战队人数数据
        [self setTeamViewOneData:model];
    } error:^(NSError * _Nullable error) {
        
    }];
}
//联系他
- (void)contactAction{
    if ([PBCache shared].userModel.weixin || [PBCache shared].userModel.qq) {
        ReferView *referView = [[ReferView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [referView setRefreUserView];
        [referView setRefreUserData:self.referModel];
        [referView showPopView:self];
    }else{
        QQWechatView *qqwechatView = [[QQWechatView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [qqwechatView showPopView:self];
    }
}
//玩法规则
- (void)ruleAction{
    WCWebViewController *webvc = [[WCWebViewController alloc] initWithOpenUrl:[PBCache shared].systemModel.friendsPlayRule title:@"玩法规则"];
    webvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webvc animated:YES];
}

@end
