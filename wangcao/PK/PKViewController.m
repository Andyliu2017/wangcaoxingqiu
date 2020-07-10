//
//  PKViewController.m
//  wangcao
//
//  Created by EDZ on 2020/5/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import "PKViewController.h"
#import "AddTeamView.h"
#import "AddOtherTeamView.h"
#import "PKPersonController.h"
#import "PKTeamController.h"
#import "WCWebViewController.h"
#import "PKRankController.h"
#import <AVFoundation/AVFoundation.h>

@interface PKViewController ()<AdHandleManagerDelegate,AVAudioPlayerDelegate>

@property (nonatomic,strong) UIScrollView *pkScrollView;
@property (nonatomic,strong) UIImageView *headImg;  //头像
@property (nonatomic,strong) UILabel *fhCardLabel;  //复活卡数量
@property (nonatomic,strong) UILabel *nickNameLabel;   //昵称
@property (nonatomic,strong) UIView *recevieCardView;  //领取复活卡
@property (nonatomic,strong) UIView *rankView;  //昨日排行
@property (nonatomic,strong) UIView *ruleView;  //奖励规则
@property (nonatomic,strong) UILabel *timeLabel;  //剩余时间
@property (nonatomic,strong) UILabel *descInfoLabel; //信息描述
@property (nonatomic,strong) UILabel *teamTodayBonus;  //团队今日总奖金
@property (nonatomic,strong) UILabel *teamNum;  //今日参与团队
@property (nonatomic,strong) UILabel *todayBonus;  //个人今日总奖金
@property (nonatomic,strong) UILabel *personNum; //今日参与人数
//创建、加入房间 选择
@property (nonatomic,strong) AddTeamView *addTeamview;
//搜索加入其它战队
@property (nonatomic,strong) AddOtherTeamView *otherTeamView;
@property (nonatomic,strong) PKShouyeModel *syModel;
//倒计时
@property (nonatomic ,strong) dispatch_source_t pk_timer;
@property (nonatomic ,strong) dispatch_source_t s_timer;
//剩余时间
@property (nonatomic,assign) NSInteger seconds;

@property (nonatomic,strong) AVAudioPlayer *backgroundMusic;

@end

@implementation PKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_shouye_bg"]];
    bgImg.userInteractionEnabled = YES;
    [self.view addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    
    [self createUI];
    
    self.backgroundMusic = [Tools loadMusic:@"bg_music"];
    self.backgroundMusic.delegate = self;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def valueForKey:BACKGROUNDMUSIC] isEqualToString:@"1"]) {
        [self.backgroundMusic play];
    }
}
#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.backgroundMusic play];
}
- (void)didMoveToParentViewController:(UIViewController *)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        [self.backgroundMusic pause];
        self.backgroundMusic = nil;
        if (self.s_timer) {
            dispatch_source_cancel(self.s_timer);
            self.s_timer = nil;
        }
        if (self.pk_timer) {
            dispatch_source_cancel(self.pk_timer);
            self.pk_timer = nil;
        }
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getData];
}
- (UIScrollView *)pkScrollView{
    if (!_pkScrollView) {
        _pkScrollView = [[UIScrollView alloc] init];
        _pkScrollView.showsVerticalScrollIndicator = NO;
        _pkScrollView.bounces = NO;
        _pkScrollView.contentSize = CGSizeMake(SCREENWIDTH, [UIScreen mainScreen].bounds.size.height);
    }
    return _pkScrollView;
}

- (void)createUI{
    UIButton *backBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(0) normalColor:[UIColor clearColor] normalText:@"" click:^(id  _Nonnull x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [backBtn setImage:[UIImage imageNamed:@"luck_back"] forState:UIControlStateNormal];
    [self.pkScrollView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(ANDY_Adapta(112));
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    
    [self.view addSubview:self.pkScrollView];
    [self.pkScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.view);
    }];
    
    self.headImg = [[UIImageView alloc] init];
    self.headImg.backgroundColor = GrayColor;
    self.headImg.layer.cornerRadius = ANDY_Adapta(48);
    self.headImg.layer.masksToBounds = YES;
    [self.pkScrollView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn.mas_right).offset(ANDY_Adapta(20));
        make.top.mas_equalTo(ANDY_Adapta(80));
        make.width.and.height.mas_equalTo(ANDY_Adapta(96));
    }];
    
    self.nickNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.pkScrollView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).offset(ANDY_Adapta(15));
        make.top.mas_equalTo(self.headImg.mas_top);
        make.height.mas_equalTo(ANDY_Adapta(41));
    }];
    
    UIView *fhCardView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(28, 15, 95, 1) alpha:1.0 cornerRadius:ANDY_Adapta(21) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.pkScrollView addSubview:fhCardView];
    [fhCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).offset(ANDY_Adapta(20));
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).offset(ANDY_Adapta(4));
        make.width.mas_equalTo(ANDY_Adapta(160));
        make.height.mas_equalTo(ANDY_Adapta(42));
    }];
    UIImageView *cardImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_card"]];
    [self.pkScrollView addSubview:cardImg];
    [cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(fhCardView);
        make.left.mas_equalTo(fhCardView.mas_left).offset(-ANDY_Adapta(7));
        make.width.mas_equalTo(ANDY_Adapta(40));
        make.height.mas_equalTo(ANDY_Adapta(48));
    }];
    UIButton *addCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCardBtn setImage:[UIImage imageNamed:@"pk_addCard"] forState:UIControlStateNormal];
    [self.pkScrollView addSubview:addCardBtn];
    [addCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(fhCardView);
        make.right.mas_equalTo(fhCardView.mas_right);
        make.width.and.height.mas_equalTo(ANDY_Adapta(43));
    }];
    self.fhCardLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(14) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.pkScrollView addSubview:self.fhCardLabel];
    [self.fhCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cardImg.mas_right);
        make.right.mas_equalTo(addCardBtn.mas_left);
        make.top.and.bottom.mas_equalTo(fhCardView);
    }];
    
    self.ruleView = [GGUI customButtonTopSize:0 bgImage:[UIImage imageNamed:@""] image:[UIImage imageNamed:@"pk_rule"] imageSize:ANDY_Adapta(52) imgLabelSpace:ANDY_Adapta(54) labelSize:ANDY_Adapta(25) labelFont:FontBold_(12) labelColor:[UIColor whiteColor] title:@"奖励规则" click:^(id  _Nonnull x) {
        WCWebViewController *webVC = [[WCWebViewController alloc] initWithOpenUrl:[PBCache shared].systemModel.battleRewardRuleUrl title:@"PK规则"];
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    self.ruleView.frame = CGRectMake(SCREENWIDTH-ANDY_Adapta(115), ANDY_Adapta(95), ANDY_Adapta(100), ANDY_Adapta(82));
    [self.pkScrollView addSubview:self.ruleView];
    
    self.rankView = [GGUI customButtonTopSize:0 bgImage:[UIImage imageNamed:@""] image:[UIImage imageNamed:@"pk_rank"] imageSize:ANDY_Adapta(52) imgLabelSpace:ANDY_Adapta(54) labelSize:ANDY_Adapta(25) labelFont:FontBold_(12) labelColor:[UIColor whiteColor] title:@"昨日排行" click:^(id  _Nonnull x) {
        PKRankController *rankVC = [[PKRankController alloc] init];
        [self.navigationController pushViewController:rankVC animated:YES];
    }];
    self.rankView.frame = CGRectMake(self.ruleView.frame.origin.x-ANDY_Adapta(110), self.ruleView.frame.origin.y, self.ruleView.frame.size.width, self.ruleView.frame.size.height);
    [self.pkScrollView addSubview:self.rankView];
    
    self.recevieCardView = [GGUI customButtonTopSize:0 bgImage:[UIImage imageNamed:@""] image:[UIImage imageNamed:@"pop_videoicon"] imageSize:ANDY_Adapta(52) imgLabelSpace:ANDY_Adapta(54) labelSize:ANDY_Adapta(25) labelFont:FontBold_(12) labelColor:[UIColor whiteColor] title:@"领取复活卡" click:^(id  _Nonnull x) {
        NSLog(@"领取复活卡");
        [self recevieCardAction];
    }];
    self.recevieCardView.frame = CGRectMake(self.rankView.frame.origin.x-ANDY_Adapta(110), self.rankView.frame.origin.y, self.rankView.frame.size.width, self.rankView.frame.size.height);
    [self.pkScrollView addSubview:self.recevieCardView];
//    if ([PBCache shared].memberModel.userType == 2) {
//        self.recevieCardView.hidden = YES;
//    }
    
    UIImageView *headTitleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_head"]];
    headTitleImg.frame = CGRectMake(0, CGRectGetMaxY(self.ruleView.frame), SCREENWIDTH, ANDY_Adapta(481));
    [self.pkScrollView addSubview:headTitleImg];
//    [headTitleImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(self.pkScrollView);
//        make.top.mas_equalTo(self.ruleView.mas_bottom).offset(ANDY_Adapta(45));
//        make.height.mas_equalTo(ANDY_Adapta(481));
//    }];
    
    UIImageView *timeImgBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_time"]];
    [headTitleImg addSubview:timeImgBg];
    [timeImgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headTitleImg);
        make.top.mas_equalTo(ANDY_Adapta(127));
        make.width.mas_equalTo(ANDY_Adapta(383));
        make.height.mas_equalTo(ANDY_Adapta(79));
    }];
    self.timeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(14) textColor:[UIColor whiteColor] text:@"比赛剩余时间：" Radius:0];
    [timeImgBg addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(timeImgBg);
    }];
    self.descInfoLabel = [GGUI ui_label:CGRectZero lines:2 align:NSTextAlignmentCenter font:FontBold_(18) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [headTitleImg addSubview:self.descInfoLabel];
    [self.descInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headTitleImg);
        make.bottom.mas_equalTo(headTitleImg.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(380));
        make.height.mas_equalTo(ANDY_Adapta(100));
    }];
    //组队pk
    UIImageView *teamPKimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_team"]];
    teamPKimg.userInteractionEnabled = YES;
    teamPKimg.frame = CGRectMake(ANDY_Adapta(30), CGRectGetMaxY(headTitleImg.frame)+ANDY_Adapta(24), ANDY_Adapta(687), ANDY_Adapta(264));
    [self.pkScrollView addSubview:teamPKimg];
//    [teamPKimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(headTitleImg.mas_bottom).offset(ANDY_Adapta(24));
//        make.centerX.mas_equalTo(self.pkScrollView);
//        make.width.mas_equalTo(ANDY_Adapta(687));
//        make.height.mas_equalTo(ANDY_Adapta(264));
//    }];
    UILabel *teamTitleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(29) textColor:[UIColor whiteColor] text:@"组队PK" Radius:0];
    [teamPKimg addSubview:teamTitleLabel];
    [teamTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(35));
        make.top.mas_equalTo(ANDY_Adapta(6));
        make.right.mas_equalTo(teamPKimg.mas_right);
        make.height.mas_equalTo(ANDY_Adapta(95));
    }];
    UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_team_bg"]];
    [teamPKimg addSubview:img1];
    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(teamTitleLabel.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(307));
        make.height.mas_equalTo(ANDY_Adapta(52));
    }];
    self.teamTodayBonus = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"今日总奖金 ：" Radius:0];
    [img1 addSubview:self.teamTodayBonus];
    [self.teamTodayBonus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(img1);
    }];
    
    UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_team_bg"]];
    [teamPKimg addSubview:img2];
    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(img1.mas_bottom).offset(ANDY_Adapta(13));
        make.width.mas_equalTo(ANDY_Adapta(307));
        make.height.mas_equalTo(ANDY_Adapta(52));
    }];
    self.teamNum = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"今日参与团队 ：" Radius:0];
    [img2 addSubview:self.teamNum];
    [self.teamNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(img2);
    }];
    UIButton *teamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [teamBtn addTarget:self action:@selector(teamAction) forControlEvents:UIControlEventTouchUpInside];
    [teamPKimg addSubview:teamBtn];
    [teamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.width.and.height.mas_equalTo(teamPKimg);
    }];
    //个人闯关
    UIImageView *gerenImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_self"]];
    gerenImg.userInteractionEnabled = YES;
    gerenImg.frame = CGRectMake(teamPKimg.frame.origin.x, CGRectGetMaxY(teamPKimg.frame)+ANDY_Adapta(25), teamPKimg.frame.size.width, teamPKimg.frame.size.height);
//    gerenImg.frame = CGRectMake(ANDY_Adapta(30), ANDY_Adapta(1011), ANDY_Adapta(687), ANDY_Adapta(264));
    [self.pkScrollView addSubview:gerenImg];
//    [gerenImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.width.and.height.mas_equalTo(teamPKimg);
//        make.top.mas_equalTo(teamPKimg.mas_bottom).offset(ANDY_Adapta(25));
//    }];
    UILabel *gerenLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(29) textColor:[UIColor whiteColor] text:@"个人闯关" Radius:0];
    [gerenImg addSubview:gerenLabel];
    [gerenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(35));
        make.top.mas_equalTo(ANDY_Adapta(6));
        make.right.mas_equalTo(gerenImg.mas_right);
        make.height.mas_equalTo(ANDY_Adapta(95));
    }];
    UIImageView *grimg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_self_bg"]];
    [gerenImg addSubview:grimg1];
    [grimg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(gerenLabel.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(307));
        make.height.mas_equalTo(ANDY_Adapta(52));
    }];
    self.todayBonus = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"今日总奖金 ：" Radius:0];
    [grimg1 addSubview:self.todayBonus];
    [self.todayBonus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(grimg1);
    }];
    
    UIImageView *grimg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_self_bg"]];
    [gerenImg addSubview:grimg2];
    [grimg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(grimg1.mas_bottom).offset(ANDY_Adapta(13));
        make.width.mas_equalTo(ANDY_Adapta(307));
        make.height.mas_equalTo(ANDY_Adapta(52));
    }];
    self.personNum = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"今日参与人数 ：" Radius:0];
    [grimg2 addSubview:self.personNum];
    [self.personNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(grimg2);
    }];
    UIButton *personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [personBtn addTarget:self action:@selector(gerenAction) forControlEvents:UIControlEventTouchUpInside];
    [gerenImg addSubview:personBtn];
    [personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.width.and.height.mas_equalTo(gerenImg);
    }];
}

#pragma mark 组队PK
- (void)teamAction{
    //如果已经加入战队直接进入组队挑战页面
    if (self.syModel.hasGroup) {
        //创建战队成功
        PKTeamController *teamVc = [[PKTeamController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:teamVc animated:YES];
        return;
    }
    if (!_addTeamview) {
        _addTeamview = [[AddTeamView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_addTeamview];
    }
    [self.addTeamview showAddView];
    __weak __typeof__(self) weakSelf = self;
    self.addTeamview.pkblock = ^(NSInteger type) {
        if (type == 1) {
            WCApiManager *manager = [WCApiManager sharedManager];
            [[manager ApiPKCreateTeam] subscribeNext:^(id  _Nullable x) {
                //创建战队成功
                PKTeamController *teamvc = [[PKTeamController alloc] init];
                weakSelf.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:teamvc animated:YES];
            } error:^(NSError * _Nullable error) {
                
            }];
        }else{
            if (!weakSelf.otherTeamView) {
                weakSelf.otherTeamView = [[AddOtherTeamView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                [weakSelf.view addSubview:weakSelf.otherTeamView];
            }
            [weakSelf.otherTeamView showAddOtherView];
            weakSelf.otherTeamView.otherblock = ^(NSString * _Nonnull groupId) {
                //加入战队
                WCApiManager *manager = [WCApiManager sharedManager];
                [[manager ApiPKJoinTeamGroupid:[groupId integerValue]] subscribeNext:^(id  _Nullable x) {
                    //加入战队成功
                    PKTeamController *teamvc = [[PKTeamController alloc] init];
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:teamvc animated:YES];
                } error:^(NSError * _Nullable error) {
                    
                }];
            };
        }
    };
}
#pragma mark 个人闯关
- (void)gerenAction{
    PKPersonController *pkvc = [[PKPersonController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pkvc animated:YES];
}
#pragma mark 数据
- (void)getData{
    [self.headImg setImageWithURL:[NSURL URLWithString:[PBCache shared].userModel.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.nickNameLabel.text = [PBCache shared].userModel.nickName;
    //获取首页信息
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKShouYe] subscribeNext:^(PKShouyeModel *model) {
        self.syModel = model;
        [PBCache shared].maxCountDown = model.answerTime;
        self.descInfoLabel.text = model.battleInfo;
        self.teamTodayBonus.text = [NSString stringWithFormat:@"今日总奖金 ：%.2f",model.groupPool.poolAmount];
        self.teamNum.text = [NSString stringWithFormat:@"今日参与团队 ：%ld",model.groupPool.joinNumber];
        self.todayBonus.text = [NSString stringWithFormat:@"今日总奖金 ：%.2f",model.personalPool.poolAmount];
        self.personNum.text = [NSString stringWithFormat:@"今日参与人数 ：%ld",model.personalPool.joinNumber];
        [self setCountDown:model.surplusTime status:model.status];
    } error:^(NSError * _Nullable error) {
        
    }];
    [self getFuHuoCardNumber];
    [self getFhCardInfo];
}
- (void)getFuHuoCardNumber{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKRebirthCount] subscribeNext:^(id  _Nullable x) {
        self.fhCardLabel.text = [NSString stringWithFormat:@"%ld张",[x integerValue]];
        [PBCache shared].fhCardNum = [x integerValue];
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)getFhCardInfo{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKRecevieCardInfo] subscribeNext:^(NSDictionary *dic) {
        NSLog(@"dic:%@",dic);
        NSInteger countdown = [dic[@"countdown"] integerValue];
        for (UIView *subview in self.recevieCardView.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                UILabel *subLabel = (UILabel *)subview;
                if (countdown == 0) {
                    subLabel.text = @"领取复活卡";
                }else if (countdown > 0){
                    subLabel.text = [GGUI timeFormatted:countdown type:1];
                    __block NSInteger countDown1 = countdown;
                    @weakify(self);
                    dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
                    self.s_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    dispatch_source_set_timer(self.s_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                    dispatch_source_set_event_handler(self.s_timer, ^{
                        @strongify(self);
                        countDown1--;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (countDown1 > 0)
                            {
                                subLabel.text = [GGUI timeFormatted:countDown1 type:1];
                            }
                            else
                            {
                                if (countDown1 >= 0) {
                                    subLabel.text = @"领取复活卡";
                                }
                                dispatch_source_cancel(self.s_timer);
                                self.s_timer = nil;
                            }
                        });
                    });
                    dispatch_resume(self.s_timer);
                }else{
                    subLabel.text = @"不可领取";
                }
            }
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)setCountDown:(NSInteger)countDown status:(NSInteger)status{
    @weakify(self);
    self.seconds = countDown;
    dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
    self.pk_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.pk_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.pk_timer, ^{
        @strongify(self);
        self.seconds--;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.seconds > 0)
            {
                if (status == 1) {  //进行中
                    self.timeLabel.text = [NSString stringWithFormat:@"比赛剩余时间：%@",[GGUI timeFormatted:self.seconds type:0]];
                }else if (status == -1){   //已结束
                    self.timeLabel.text = [NSString stringWithFormat:@"比赛已结束"];
                }else if (status == 0){    //还未开始
                    self.timeLabel.text = [NSString stringWithFormat:@"比赛开始时间：%@",[GGUI timeFormatted:self.seconds type:0]];
                }
            }
            else
            {
                if (status == 1) {  //进行中
                    self.timeLabel.text = [NSString stringWithFormat:@"比赛剩余时间：%@",[GGUI timeFormatted:self.seconds type:0]];
                }else if (status == -1){   //已结束
                    self.timeLabel.text = [NSString stringWithFormat:@"比赛已结束"];
                }else if (status == 0){    //还未开始
                    self.timeLabel.text = [NSString stringWithFormat:@"比赛开始时间：%@",[GGUI timeFormatted:self.seconds type:0]];
                }
                dispatch_source_cancel(self.pk_timer);
                self.pk_timer = nil;
            }
        });
    });
    dispatch_resume(self.pk_timer);
}
#pragma mark 领取复活卡
- (void)recevieCardAction{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKRecevieCard] subscribeNext:^(VideoModel *model) {
//        if ([PBCache shared].memberModel.userType == 2) {
//            [self watchVideoSuccess:model.videoId withType:5];
//        }else{
            AdHandleManager *manager = [AdHandleManager sharedManager];
            manager.delegate = self;
            [manager RewardedSlotVideoAdViewRender:model videoType:5 viewController:self];
//        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)BUADVideoFinish:(id)rewardedVideoAd withVideoModel:(VideoModel *)model withType:(NSInteger)type{
//    if ([model.advertChannel isEqualToString:BUADVIDEOTYPE]) {
//        BUNativeExpressRewardedVideoAd *rewardedVideoAd = rewardedVideoAd;
//        [self watchVideoSuccess:model.videoId withType:rewardedVideoAd.rewardedVideoModel.rewardAmount];
//    }else if ([model.advertChannel isEqualToString:TENCENTVIDEOTYPE]){
//        [self watchVideoSuccess:model.videoId withType:type];
//    }else if ([model.advertChannel isEqualToString:SIGMOBVIDEOTYPE]){
//        [self watchVideoSuccess:model.videoId withType:type];
//    }
    [self watchVideoSuccess:model.videoId withType:type];
}
//观看视频完成回调
- (void)watchVideoSuccess:(NSString *)videoId withType:(NSInteger)type{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager WatchFinish:videoId] subscribeNext:^(id  _Nullable x) {
        //领取成功 刷新复活卡数量
        if (type == 5) {
            [self getFuHuoCardNumber];
            [self getFhCardInfo];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}

@end
