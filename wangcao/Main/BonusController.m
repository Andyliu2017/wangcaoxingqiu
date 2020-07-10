//
//  BonusController.m
//  wangcao
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 andy. All rights reserved.
//

#import "BonusController.h"
#import "BonusRecordController.h"
#import "FeedController.h"
#import "SharePopView.h"

@interface BonusController ()

@property (nonatomic,strong) UIScrollView *bonusScroll;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UIImageView *bonusBg1;
@property (nonatomic,strong) UIImageView *bonusBg2;
@property (nonatomic,strong) UIImageView *bonusBg3;
@property (nonatomic,strong) UIImageView *bonusBg4;
@property (nonatomic,strong) UIButton *inviteBtn;
//恭喜用户获得分红玉玺label
@property (nonatomic,strong) UILabel *getBonusLabel;
//今日每个分红
@property (nonatomic,strong) UILabel *todayBonusMoney;
//我的玉玺个数
@property (nonatomic,strong) UILabel *myYuxiLabel;
//我的今日分红
@property (nonatomic,strong) UILabel *myBonusLabel;
//累计分红
@property (nonatomic,strong) UILabel *myTotalLabel;
//分红玉玺介绍
@property (nonatomic,strong) UITextView *textView;
//加速进度条
@property (nonatomic,strong) UIProgressView *feedProgress;
//解锁进度
@property (nonatomic,strong) UILabel *unlockLabel;
//分享弹窗
@property (nonatomic,strong) SharePopView *shareView;

@end

@implementation BonusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TabbarColor;
    
    [self createUI];
    [self loadData];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI{
    [self createBonusScroll];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"luck_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(23));
        make.top.mas_equalTo(ANDY_Adapta(88));
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    [self createBonusUI];
}
- (void)createBonusScroll{
    self.bonusScroll = [[UIScrollView alloc] init];
    self.bonusScroll.bounces = NO;
    self.bonusScroll.showsVerticalScrollIndicator = NO;
    self.bonusScroll.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(2251));
    [self.view addSubview:self.bonusScroll];
    [self.bonusScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.view);
    }];
}
- (void)createBonusUI{
    self.headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bonus_headImg"]];
//    if ([PBCache shared].memberModel.userType == 2) {
//        self.headImg.image = [UIImage imageNamed:@"bonus_headImg1"];
//    }
    [self.bonusScroll addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(ANDY_Adapta(75));
        make.width.mas_equalTo(ANDY_Adapta(676));
        make.height.mas_equalTo(ANDY_Adapta(197));
    }];
    [self bonusViewOne];
    [self bonusViewTwo];
    [self bonusViewThree];
    [self bonusViewFour];
    self.inviteBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"邀请好友" click:^(id  _Nonnull x) {
        [self inviteAction];
    }];
    [self.inviteBtn setBackgroundImage:[UIImage imageNamed:@"rank_invite"] forState:UIControlStateNormal];
    [self.inviteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, ANDY_Adapta(10), 0)];
    [self.bonusScroll addSubview:self.inviteBtn];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.bonusBg4.mas_bottom).offset(ANDY_Adapta(36));
        make.width.mas_equalTo(ANDY_Adapta(642));
        make.height.mas_equalTo(ANDY_Adapta(110));
    }];
//    if (![WXApi isWXAppInstalled]) {
//        self.inviteBtn.hidden = YES;
//    }
}
- (void)bonusViewOne{
    self.bonusBg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bonus_bg1"]];
    self.bonusBg1.userInteractionEnabled = YES;
    [self.bonusScroll addSubview:self.bonusBg1];
    [self.bonusBg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(ANDY_Adapta(21));
        make.width.mas_equalTo(ANDY_Adapta(710));
        make.height.mas_equalTo(ANDY_Adapta(300));
    }];
    UIImageView *hornImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bonus_horn"]];
    [self.bonusBg1 addSubview:hornImg];
    [hornImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(53));
        make.top.mas_equalTo(ANDY_Adapta(25));
        make.width.and.height.mas_equalTo(ANDY_Adapta(40));
    }];
//    恭喜 这是用户昵称 获得一个分红玉玺
    self.getBonusLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:MessageColor text:@"" Radius:0];
    [self.bonusBg1 addSubview:self.getBonusLabel];
    [self.getBonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(hornImg);
        make.left.mas_equalTo(hornImg.mas_right).offset(ANDY_Adapta(15));
        make.right.mas_equalTo(self.bonusBg1.mas_right);
    }];
    UIImageView *bonusImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_bonus"]];
    [self.bonusBg1 addSubview:bonusImg];
    [bonusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(41));
        make.top.mas_equalTo(hornImg.mas_bottom).offset(ANDY_Adapta(21));
        make.width.mas_equalTo(ANDY_Adapta(151));
        make.height.mas_equalTo(ANDY_Adapta(177));
    }];
    //分红玉玺
    UILabel *bonusLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(22) textColor:TitleColor text:@"分红玉玺" Radius:0];
    [self.bonusBg1 addSubview:bonusLabel];
    [bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bonusImg.mas_right).offset(ANDY_Adapta(19));
        make.top.mas_equalTo(bonusImg.mas_top).offset(ANDY_Adapta(38));
        make.height.mas_equalTo(ANDY_Adapta(40));
        make.width.mas_equalTo(ANDY_Adapta(317));
    }];
    //分红记录
    UILabel *bonusRecord = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:MoneyColor text:@"分红纪录" Radius:0];
    [self.bonusBg1 addSubview:bonusRecord];
    [bonusRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bonusLabel.mas_right).offset(ANDY_Adapta(22));
        make.top.and.height.mas_equalTo(bonusLabel);
        make.width.mas_equalTo(ANDY_Adapta(108));
    }];
    UIImageView *bonusRecordIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bonus_more"]];
    [self.bonusBg1 addSubview:bonusRecordIcon];
    [bonusRecordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bonusRecord.mas_right);
        make.centerY.mas_equalTo(bonusRecord);
        make.width.and.height.mas_equalTo(ANDY_Adapta(20));
    }];
    UIButton *bonusRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bonusRecordBtn addTarget:self action:@selector(bonusRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bonusBg1 addSubview:bonusRecordBtn];
    [bonusRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(bonusRecord);
        make.right.mas_equalTo(bonusRecordIcon.mas_right);
    }];
    //今日每个分红
    UILabel *todayBonus = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:TitleColor text:@"今日每个分红" Radius:0];
    [self.bonusBg1 addSubview:todayBonus];
    [todayBonus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bonusLabel.mas_left);
        make.top.mas_equalTo(bonusRecord.mas_bottom).offset(ANDY_Adapta(37));
        make.height.mas_equalTo(ANDY_Adapta(30));
//        make.width.mas_equalTo(ANDY_Adapta(160));
    }];
    self.todayBonusMoney = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(17) textColor:MoneyColor text:@"208.00元" Radius:0];
    [self.bonusBg1 addSubview:self.todayBonusMoney];
    [self.todayBonusMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(todayBonus.mas_right).offset(ANDY_Adapta(10));
        make.top.and.height.mas_equalTo(todayBonus);
        make.right.mas_equalTo(self.bonusBg1.mas_right);
    }];
}
- (void)bonusViewTwo{
    self.bonusBg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bonus_bg2"]];
    [self.bonusScroll addSubview:self.bonusBg2];
    [self.bonusBg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.bonusBg1.mas_bottom).offset(ANDY_Adapta(10));
        make.width.mas_equalTo(ANDY_Adapta(710));
        make.height.mas_equalTo(ANDY_Adapta(250));
    }];
    //我的分红玉玺
    UILabel *myYuxi = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"我的分红玉玺" Radius:0];
    [self.bonusBg2 addSubview:myYuxi];
    [myYuxi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(47));
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(ANDY_Adapta(310));
        make.height.mas_equalTo(ANDY_Adapta(79));
    }];
    self.myYuxiLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(15) textColor:MoneyColor text:@"1000个" Radius:0];
    [self.bonusBg2 addSubview:self.myYuxiLabel];
    [self.myYuxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(myYuxi.mas_right);
        make.top.and.bottom.mas_equalTo(myYuxi);
        make.width.mas_equalTo(ANDY_Adapta(310));
    }];
    UIImageView *lineImg1 = [[UIImageView alloc] init];
    lineImg1.backgroundColor = LineColor;
    [self.bonusBg2 addSubview:lineImg1];
    [lineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(myYuxi);
        make.top.mas_equalTo(myYuxi.mas_bottom);
        make.right.mas_equalTo(self.myYuxiLabel);
        make.height.mas_equalTo(1);
    }];
    //今日分红
    UILabel *todaylabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:MessageColor text:@"今日分红" Radius:0];
    [self.bonusBg2 addSubview:todaylabel];
    [todaylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.height.and.width.mas_equalTo(myYuxi);
        make.top.mas_equalTo(lineImg1.mas_bottom);
    }];
    self.myBonusLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(14) textColor:MoneyColor text:@"10元" Radius:0];
    [self.bonusBg2 addSubview:self.myBonusLabel];
    [self.myBonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(self.myYuxiLabel);
        make.top.mas_equalTo(todaylabel.mas_top);
    }];
    UIImageView *lineImg2 = [[UIImageView alloc] init];
    lineImg2.backgroundColor = LineColor;
    [self.bonusBg2 addSubview:lineImg2];
    [lineImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(todaylabel.mas_bottom);
        make.left.and.right.and.height.mas_equalTo(lineImg1);
    }];
    //累计分红
    UILabel *totalLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:MessageColor text:@"累计分红" Radius:0];
    [self.bonusBg2 addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.height.mas_equalTo(todaylabel);
        make.top.mas_equalTo(lineImg2.mas_bottom);
    }];
    self.myTotalLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(14) textColor:MoneyColor text:@"100元" Radius:0];
    [self.bonusBg2 addSubview:self.myTotalLabel];
    [self.myTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.height.mas_equalTo(self.myBonusLabel);
        make.top.mas_equalTo(totalLabel);
    }];
}
- (void)bonusViewThree{
    self.bonusBg3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bonus_bg3"]];
    self.bonusBg3.userInteractionEnabled = YES;
    [self.bonusScroll addSubview:self.bonusBg3];
//    [self.bonusBg3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//        make.top.mas_equalTo(self.bonusBg2.mas_bottom).offset(ANDY_Adapta(10));
//        make.width.mas_equalTo(ANDY_Adapta(710));
//        make.height.mas_equalTo(ANDY_Adapta(440));
//    }];
//    self.bonusBg3.hidden = YES;
//    if ([PBCache shared].memberModel.userType == 2) {
//        [self.bonusBg3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(0);
//            make.top.mas_equalTo(self.bonusBg2.mas_bottom).offset(ANDY_Adapta(10));
//            make.width.mas_equalTo(ANDY_Adapta(710));
//            //        make.height.mas_equalTo(ANDY_Adapta(440));
//            make.height.mas_equalTo(0);
//        }];
//        self.bonusBg3.hidden = YES;
//    }else{
        [self.bonusBg3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.bonusBg2.mas_bottom).offset(ANDY_Adapta(10));
            make.width.mas_equalTo(ANDY_Adapta(710));
            make.height.mas_equalTo(ANDY_Adapta(440));
        }];
//    }
    //分红玉玺加速
    UILabel *feedLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"分红玉玺加速" Radius:0];
    [self.bonusBg3 addSubview:feedLabel];
    [feedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(47));
        make.top.mas_equalTo(ANDY_Adapta(30));
        make.width.mas_equalTo(ANDY_Adapta(480));
        make.height.mas_equalTo(ANDY_Adapta(56));
    }];
    UIButton *feedBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(13) normalColor:[UIColor whiteColor] normalText:@"去加速" click:^(id  _Nonnull x) {
        NSLog(@"去加速");
        FeedController *feedVc = [[FeedController alloc] init];
        [self.navigationController pushViewController:feedVc animated:YES];
    }];
    feedBtn.layer.cornerRadius = ANDY_Adapta(28);
    feedBtn.layer.masksToBounds = YES;
    feedBtn.backgroundColor = RGBA(254, 172, 56, 1);
    [self.bonusBg3 addSubview:feedBtn];
    [feedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(feedLabel.mas_right).offset(ANDY_Adapta(13));
        make.top.mas_equalTo(feedLabel.mas_top);
        make.width.mas_equalTo(ANDY_Adapta(151));
        make.height.mas_equalTo(ANDY_Adapta(56));
    }];
    self.feedProgress = [[UIProgressView alloc] init];
    self.feedProgress.progress = 0;
    self.feedProgress.layer.cornerRadius = ANDY_Adapta(10);
    self.feedProgress.layer.masksToBounds = YES;
    //已过进度条颜色
    self.feedProgress.progressTintColor = ProgressSelectColor;
    //未过
    self.feedProgress.trackTintColor = ProgressNoColor;
    [self.bonusBg3 addSubview:self.feedProgress];
    [self.feedProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(feedLabel.mas_left);
        make.top.mas_equalTo(feedLabel.mas_bottom).offset(ANDY_Adapta(29));
        make.width.mas_equalTo(ANDY_Adapta(610));
        make.height.mas_equalTo(ANDY_Adapta(20));
    }];
    self.unlockLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:TitleColor text:@"已经解锁10.485%，解锁之后必得分红玉玺" Radius:0];
    [self.bonusBg3 addSubview:self.unlockLabel];
    [self.unlockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.feedProgress);
        make.top.mas_equalTo(self.feedProgress.mas_bottom).offset(ANDY_Adapta(30));
        make.width.mas_equalTo(self.feedProgress);
        make.height.mas_equalTo(ANDY_Adapta(30));
    }];
    //线
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = LineColor;
    [self.bonusBg3 addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.feedProgress);
        make.top.mas_equalTo(self.unlockLabel.mas_bottom).offset(ANDY_Adapta(35));
        make.height.mas_equalTo(1);
    }];
    //加速方法
    UILabel *feedMayLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:TitleColor text:@"加速方法" Radius:0];
    [self.bonusBg3 addSubview:feedMayLabel];
    [feedMayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(lineImg);
        make.top.mas_equalTo(lineImg.mas_bottom).offset(ANDY_Adapta(40));
        make.height.mas_equalTo(ANDY_Adapta(30));
    }];
    UILabel *feedMayLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:MessageColor text:@"1. 观看视频加速     2. 游戏活跃加速" Radius:0];
    [self.bonusBg3 addSubview:feedMayLabel1];
    [feedMayLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(feedMayLabel);
        make.top.mas_equalTo(feedMayLabel.mas_bottom).offset(ANDY_Adapta(20));
        make.height.mas_equalTo(ANDY_Adapta(30));
    }];
    UILabel *feedMayLabel2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:MessageColor text:@"3. 邀请好友加速     4. 领取任务次数" Radius:0];
    [self.bonusBg3 addSubview:feedMayLabel2];
    [feedMayLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(feedMayLabel1);
        make.top.mas_equalTo(feedMayLabel1.mas_bottom).offset(ANDY_Adapta(20));
        make.height.mas_equalTo(ANDY_Adapta(30));
    }];
}
- (void)bonusViewFour{
    self.bonusBg4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bonus_bg4"]];
    [self.bonusScroll addSubview:self.bonusBg4];
    [self.bonusBg4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.bonusBg3.mas_bottom).offset(ANDY_Adapta(10));
        make.width.mas_equalTo(ANDY_Adapta(710));
        make.height.mas_equalTo(ANDY_Adapta(740));
    }];
    //什么是分红玉玺
    UILabel *fenhongyuxi = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"什么是分红玉玺？" Radius:0];
    [self.bonusBg4 addSubview:fenhongyuxi];
    [fenhongyuxi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(46));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(ANDY_Adapta(96));
        make.right.mas_equalTo(self.bonusBg4.mas_right);
    }];
    self.textView = [[UITextView alloc] init];
    self.textView.textColor = MessageColor;
    self.textView.font = Font_(14);
    [self.bonusBg4 addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fenhongyuxi.mas_left);
        make.top.mas_equalTo(fenhongyuxi.mas_bottom).offset(ANDY_Adapta(5));
        make.width.mas_equalTo(ANDY_Adapta(612));
        make.height.mas_equalTo(ANDY_Adapta(585));
    }];
//    if ([PBCache shared].memberModel.userType == 2) {
//        self.textView.text = @"永久分红玉玺获取途径：\n1. 通过个人努力，邀请好友一起游戏，持续完成任务，提升活跃度，必得分红玉玺。\n2. 通过集成所有王朝典故卡，集满合成必得永久分红玉玺。\n3. 通过个人努力，完成每个王朝的典故卡，集满合成有机会获得永久分红玉玺。\n\n限时分红玉玺获取途径：\n1：通过个人努力，完成每个王朝的典故卡，集满合成有机会获得限时分红玉玺和永久分红玉玺。";
//    }else{
        self.textView.text = @"永久分红玉玺每日均分20%平台广告收益，限量100000个，持有分红玉玺享受平台永久广告分红，限时分红玉玺享受一定时间分红。\n\n永久分红玉玺获取途径：\n1. 通过个人努力，邀请好友一起游戏，持续完成任务，提升活跃度，必得分红玉玺。\n2. 通过集成所有王朝典故卡，集满合成必得永久分红玉玺。\n3. 通过个人努力，完成每个王朝的典故卡，集满合成有机会获得永久分红玉玺。\n\n限时分红玉玺获取途径：\n1：通过个人努力，完成每个王朝的典故卡，集满合成有机会获得限时分红玉玺和永久分红玉玺。";
//    }
}
#pragma mark 分红记录
- (void)bonusRecordAction{
    NSLog(@"分红记录");
    BonusRecordController *recordVc = [[BonusRecordController alloc] init];
    [self.navigationController pushViewController:recordVc animated:YES];
}
#pragma mark 邀请好友
- (void)inviteAction{
    self.shareView = [SharePopView new];
    [self.shareView setDataWithImg:[UIImage imageNamed:@"share_invate_bg"] type:1 teamNum:[PBCache shared].userModel.invitecode nickName:[PBCache shared].userModel.nickName qrcode:[PBCache shared].userModel.qrcode];
    [self.shareView showView];
}
#pragma mark 数据
- (void)loadData{
    WCApiManager *manager = [WCApiManager sharedManager];
    //我的分红
    [[manager ApiMyBonus] subscribeNext:^(BonusModel *model) {
        self.myYuxiLabel.text = [NSString stringWithFormat:@"%ld个",model.profitCount];
        self.myBonusLabel.text = [NSString stringWithFormat:@"%.2f元",model.profitMoney];
        self.myTotalLabel.text = [NSString stringWithFormat:@"%.2f元",model.totalProfit];
    } error:^(NSError * _Nullable error) {
        
    }];
    //进度
    [[manager ApiBonusProgress] subscribeNext:^(BonusProgressModel *model) {
        self.feedProgress.progress = model.totalProcess / 100.0;
        self.unlockLabel.text = [NSString stringWithFormat:@"已经解锁%ld%@，解锁之后必得分红玉玺",model.totalProcess,@"%"];
    } error:^(NSError * _Nullable error) {
        
    }];
    //平台分红
    [[manager ApiPlatformBonus] subscribeNext:^(BonusModel *model) {
        self.todayBonusMoney.text = [NSString stringWithFormat:@"%.2f",model.profitMoney];
    } error:^(NSError * _Nullable error) {
        
    }];
}

@end
