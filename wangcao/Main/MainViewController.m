//
//  MainViewController.m
//  wangcao
//
//  Created by EDZ on 2020/5/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import "MainViewController.h"
#import "MianTableCell.h"
#import "MyViewController.h"
#import "LuckDrawController.h"
#import "RankController.h"
#import "BonusController.h"
#import "PaopaoView.h"
#import "SignInView.h"
#import "TaojinController.h"
#import "DynastyView.h"
#import "TaskView.h"
#import "TaskViewController.h"
#import "PKViewController.h"
#import "SignInSuccessView.h"
#import "SignInConfigModel.h"
#import "LimitBonusController.h"
#import "LimitBonusView.h"
#import "OfflineView.h"
#import "DianGuKaView.h"
#import "DianGuKaController.h"
#import "SystemContentView.h"
#import "YinSiView.h"
#import "MainScroll.h"
#import "YuLeController.h"

#define ANGLE_TO_RADIAN(angle) ((angle)/180.0 * M_PI)

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,PaopaoViewDelegate,SignInViewDelegate,AdHandleManagerDelegate,DynastyViewDelegate,OfflineViewDelegate,YinSiViewDelegate,MQTTHandleManagerDelegate>

//抽奖列表数组
@property (nonatomic,strong) NSMutableArray *luckListArray;
//签到弹窗
@property (nonatomic,strong) SignInView *signinView;
@property (nonatomic,strong) NSArray *signInArr;   //签到奖励数据
@property (nonatomic,assign) NSInteger continuNum; //已签到多少天
//朝代升级弹窗
@property (nonatomic,strong) DynastyView *dyView;
//典故卡
@property (nonatomic,strong) DianGuKaView *dgkView;
//任务
@property (nonatomic,strong) TaskView *taskView;
@property (nonatomic,strong) DynastyModel *mainDynastymModel; //我的朝代信息
@property (nonatomic,strong) UIImageView *mainBgImg;
@property (nonatomic,strong) UIImageView *headerImg;  //头像
@property (nonatomic,strong) UILabel *userName;   //用户名
@property (nonatomic,strong) UIProgressView *upgradeProgress;  //升级经验条
@property (nonatomic,strong) UILabel *profitLabel;  //今日分红
@property (nonatomic,strong) UIButton *limitBonusBtn;  //限时分红按钮
//显示任务泡泡view
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *goldView;  //金币view
@property (nonatomic,strong) UIView *fudouView;  //福豆view
@property (nonatomic,strong) UILabel *fudouLabel;  //福豆
@property (nonatomic,strong) UILabel *goldLabel;   //金币
//升级建筑view
@property (nonatomic,strong) UIView *buildView;
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *mainTablArr;  //建筑信息数据
@property (nonatomic,strong) UIButton *myHeadBtn;  //我的
//泡泡显示view
@property (nonatomic,strong) PaopaoView *paopaoView;
//泡泡数组
@property (nonatomic,strong) NSMutableArray *ppMuArr;
//朝代背景图
@property (nonatomic,strong) UIImageView *topimg;

@property (nonatomic,strong) BUNativeExpressRewardedVideoAd *rewardedAd;

//金币不足
@property (nonatomic,strong) OfflineView *notEnoughView;
//离线收益
@property (nonatomic,strong) OfflineView *offlineview;

//放在view的上层，用来做下拉刷新数据
@property (nonatomic,strong) MainScroll *mainScroll;

@property (nonatomic,strong) UIView *taojinview;
@property (nonatomic,strong) UIView *rankview;
//推啊
@property (nonatomic,strong) UIView *tuiaView;
 
@end

@implementation MainViewController

- (NSMutableArray *)mainTablArr{
    if (!_mainTablArr) {
        _mainTablArr = [NSMutableArray array];
    }
    return _mainTablArr;
}
- (NSMutableArray *)luckListArray{
    if (!_luckListArray) {
        _luckListArray = [NSMutableArray array];
    }
    return _luckListArray;
}
- (NSMutableArray *)ppMuArr{
    if (!_ppMuArr) {
        _ppMuArr = [NSMutableArray array];
    }
    return _ppMuArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self MQTTAction];
    [self viewShakeAnimation:self.taojinview withAngle:15];
    [self viewShakeAnimation:self.rankview withAngle:10];
    self.goldLabel.text = [GGUI goldConversion:[NSString stringWithFormat:@"%ld",[PBCache shared].goldModel.goldCoins]];
    [self loadTaskList];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [[MQTTHandleManager sharedManager] disconnect];
    [self.taojinview.layer removeAllAnimations];
    [self.rankview.layer removeAllAnimations];
    //删除任务泡泡
    for (UIView *subview in self.paopaoView.subviews) {
        if ([subview isKindOfClass:[PaopaoButton class]]) {
            PaopaoButton *btn = (PaopaoButton *)subview;
            if (btn.taskcode) {
                [btn removeFromSuperview];
            }
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NavigationBarColor;
    [[YLManager sharedManager] tuiaSetUserid];
    [self createMainUI];
    [self getVersionInfo];
    [self getData];
    #pragma mark 创建推啊悬浮框
    [self createTuiaView];
    [self getUserInfo:[PBCache shared].memberModel.userId];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLimitTimeData) name:REFRESHLIMITTAMEDATA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goldNotEnoughAction) name:GOLDNOTENOUGH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoldFotonData) name:REFRESHGOLDCOINS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MQTTAction) name:MQTTCLIENTCONNECT object:nil];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *str = [def objectForKey:@"firstLangth"];
    if (![str isEqualToString:@"yes"]) {
        [self showYinsiView];
    }
    
//    self.mainScroll = [[MainScroll alloc] init];
//    self.mainScroll.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
//    [self.view addSubview:self.mainScroll];
//    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.and.top.mas_equalTo(self.view);
//        make.height.mas_equalTo(SCREENHEIGHT-self.tabBarController.tabBar.frame.size.height);
//    }];
}
- (void)getVersionInfo{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiVersionUpdate] subscribeNext:^(id  _Nullable x) {
        NSDictionary *dic = x;
        NSLog(@"版本号信息:%@",dic);
        NSString *severVersionStr = dic[@"version"];
        NSString *downloadUrl = dic[@"iosDownloadUrl"];
        NSString *downloadText = dic[@"updateInfo"];
        //本地版本
        NSString *localVersionStr=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSArray *severArr = [severVersionStr componentsSeparatedByString:@"."];
        NSArray *localArr = [localVersionStr componentsSeparatedByString:@"."];
        if (severArr.count != localArr.count) {
            return;
        }
        for (int i = 0; i < severArr.count; i++) {
            NSInteger severNum = [severArr[i] integerValue];
            NSInteger localNum = [localArr[i] integerValue];
            if (severNum > localNum) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本更新" message:downloadText preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了确认按钮");
                    NSString *urlString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&amp;url=%@",downloadUrl];
                    NSURL *url  = [NSURL URLWithString:urlString];
                    [[UIApplication sharedApplication] openURL:url];
                    MBProgressHUD *hud =[[MBProgressHUD alloc]init];
                    [self.view addSubview:hud];
                    
//                    hud.labelText=@"下载更新";
//                    [hud show:YES];
                }];
                [alertController addAction:conform];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)headRefresh{
    NSLog(@"下拉刷新");
    [self getData];
}
#pragma mark 连接MQTT
- (void)MQTTAction{
    NSLog(@"MQTT连接开始连接");
    MQTTHandleManager *manager = [MQTTHandleManager sharedManager];
    manager.delegate = self;
    [manager MQTTConnect];
}
#pragma mark MQTTHandleManagerDelegate
- (void)connectSuccess:(BOOL)isReconnect{
    NSLog(@"MQTT连接成功:%ld",isReconnect);
    if (isReconnect) {
        [[MQTTHandleManager sharedManager] reConnect];
    }
}
- (void)recevieMessage:(MQTTModel *)model{
    NSLog(@"收到MQTT消息:%@,,%@",model.type,model.data);
    if ([model.type isEqualToString:@"ACQUIRE_BLESS_BEAN"]) {
        OfflineView *offline = [[OfflineView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [offline setFutonView];
        [offline setFotonData:model.data];
        [offline showPopView:self];
    }else if ([model.type isEqualToString:@"ACQUIRE_MONEY"]){
        LimitBonusView *bonusview = [[LimitBonusView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [bonusview cashBonusView];
        [bonusview setCashBonusData:model.data];
        [bonusview showPopView:self];
    }
    
}
#pragma mark 第一次进弹隐私政策框
- (void)showYinsiView{
    YinSiView *yinsiview = [[YinSiView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    yinsiview.delegate = self;
    [yinsiview setWebViewUrl:[PBCache shared].systemModel.agreementUrl withTitle:@"用户协议"];
    [yinsiview showPopView:self];
}
- (void)agreeYinsiBack{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"yes" forKey:@"firstLangth"];
    [def synchronize];
}
- (void)noAgreeYinsiBack{
    exit(0);
}
#pragma mark 金币不足
- (void)goldNotEnoughAction{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiGoldNotEnoughVideo] subscribeNext:^(VideoModel *model) {
        NSLog(@"剩余视频次数:%ld",model.remainNum);
        if (model.remainNum > 0) {   //剩余视频次数大于0
            if (model.countDown > 0) {
                [MBProgressHUD showText:[NSString stringWithFormat:@"观看广告频繁，请%ld秒再来",model.countDown] toView:self.view afterDelay:1.0];
                return;
            }
            if (!self.notEnoughView) {
                self.notEnoughView = [[OfflineView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                self.notEnoughView.delegate = self;
                [self.notEnoughView setGoldEnoughView];
                [self.notEnoughView setgoldEnoughData:model];
                [self.notEnoughView showPopView:self];
            }
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 通知主页刷新显示分红信息
- (void)loadLimitTimeData{
    WCApiManager *manager = [WCApiManager sharedManager];
    //获取当前用户的限时分红列表
    [[manager ApiUserLimitBonusList] subscribeNext:^(NSArray *array) {
        if (array.count > 0) {
            self.limitBonusBtn.hidden = NO;
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 获取到期的限时分红信息  给弹窗
- (void)loadExpireLimitData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserExpireBonusList] subscribeNext:^(NSArray *array) {
//        NSMutableArray *expireArr = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            FotonExchangeModel *model = [FotonExchangeModel mj_objectWithKeyValues:array[i]];
            LimitBonusView *expireView = [[LimitBonusView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [expireView expireBonusView];
            [expireView setExpireBonusData:model];
            [expireView showPopView:self];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 获取界面数据
- (void)getData{
    //朝代信息
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager getFetchDynastyInfo] subscribeNext:^(DynastyModel *model) {
        self.mainDynastymModel = model;
        self.userName.text = model.dynastyName;
        self.upgradeProgress.progress = [model.process floatValue];
        NSLog(@"主城进度：%@",model.process);
        if ([model.process floatValue] == 1) {
            [self nextDynastyInfo];
        }
        NSLog(@"建筑物信息:%@",model.structures);
        [self.topimg setImageWithURL:[NSURL URLWithString:model.backgroundImg] placeholder:[UIImage imageNamed:@"sy_topImg"]];
        [self.mainTablArr addObjectsFromArray:model.structures];
        [self.mainTableView reloadData];
        if ([self.mainScroll.mj_header isRefreshing]) {
            [self.mainScroll.mj_header endRefreshing];
        }
    } error:^(NSError * _Nullable error) {
        if ([self.mainScroll.mj_header isRefreshing]) {
            [self.mainScroll.mj_header endRefreshing];
        }
    }];
    [self GoldFotonData];
    [self loadExpireLimitData];
    [self loadLimitTimeData];
    [self loadPaopaoViewData];
    [self loadNoRecevieCashBonus];
    [self loadNoRecevieFoton];
    [self loadOfflineProfit];
    [self getContentData];
    [self loadTodayProfit];
}
#pragma mark 悬浮泡泡任务
- (void)loadTaskList{
    CGFloat kMargin = ANDY_Adapta(10);
    CGFloat kBtnDiameter = ANDY_Adapta(104);
    CGFloat kBtnMinX = kBtnDiameter * 0.5 + 0;
    CGFloat kBtnMinY = 0.0;
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiTaskList:0 type:@"LIST"] subscribeNext:^(NSArray *array) {
        for (int i = 0; i < array.count; i++) {
            TaskDetailModel *taskModel = [TaskDetailModel mj_objectWithKeyValues:array[i]];
            if (!([taskModel.taskCode isEqualToString:TASKVIDEO] || [taskModel.taskCode isEqualToString:TASKANSWER] || [taskModel.taskCode isEqualToString:TASKSHARE])) {
                CGFloat minY = kBtnMinY + kBtnDiameter * 0.5 + kMargin;
                CGFloat maxY = self.paopaoView.size.height - kBtnDiameter * 0.5 - kMargin;
                CGFloat minX = kBtnMinX + kMargin;
                CGFloat maxX = SCREENWIDTH - kBtnDiameter * 0.5 - 0 - kMargin;
                CGFloat x = [Tools getRandomNumber:minX to:maxX];
                CGFloat y = [Tools getRandomNumber:minY to:maxY];
                PaopaoButton *randomBtn = [PaopaoButton buttonWithType:0];
                randomBtn.taskcode = taskModel.taskCode;
                randomBtn.bounds = CGRectMake(0, 0, kBtnDiameter, kBtnDiameter);
                randomBtn.center = CGPointMake(x, y);
                [randomBtn setTitleColor:RGBA(255, 202, 20, 1) forState:0];
                randomBtn.titleLabel.font = FontBold_(12);
                [randomBtn setBackgroundImage:[UIImage imageNamed:@"sy_paopao"] forState:0];
                [randomBtn addTarget:self action:@selector(taskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [randomBtn setImageWithURL:[NSURL URLWithString:taskModel.taskIcon] forState:UIControlStateNormal options:YYWebImageOptionProgressive];
                [randomBtn setTitle:taskModel.taskTitle forState:UIControlStateNormal];
                [self.paopaoView addSubview:randomBtn];
                [Tools animationScaleOnceWithView:randomBtn];
                [Tools animationUpDownWithView:randomBtn];
            }
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)taskBtnClick:(PaopaoButton *)ppBtn{
    if ([ppBtn.taskcode isEqualToString:TASKSHARE]) {  //分享
        
    }
    if ([ppBtn.taskcode isEqualToString:TASKDUOYOU]) {  //多游
        [[YLManager sharedManager] goToYuleControllerWithTaskCode:ppBtn.taskcode viewController:self userId:[PBCache shared].memberModel.userId advertType:0];
    }
    if ([ppBtn.taskcode isEqualToString:TASKTUIA]) {  //推啊
        [[YLManager sharedManager] showInterstitialAd];
    }
    if ([ppBtn.taskcode isEqualToString:TASKIBX]) { //爱变现
        [[YLManager sharedManager] showIBXgame:self];
    }
}
#pragma mark 今日分红玉玺收益
- (void)loadTodayProfit{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPlatformBonus] subscribeNext:^(BonusModel *model) {
        self.profitLabel.text = [NSString stringWithFormat:@"￥%.2f",model.profitMoney];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 金币、福豆 数据
- (void)GoldFotonData{
    WCApiManager *manager = [WCApiManager sharedManager];
    //金币、福豆信息
    [[manager ApiGlodAndFudou] subscribeNext:^(GoldModel *model) {
        self.fudouLabel.text = [GGUI goldConversion:[NSString stringWithFormat:@"%ld",model.blessBean]];
        self.goldLabel.text =[GGUI goldConversion:[NSString stringWithFormat:@"%ld",model.goldCoins]];
        [PBCache shared].goldModel = model;
    } error:^(NSError * _Nullable error) {
        
    }];
}
//获取系统公告
- (void)getContentData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiSystemContent] subscribeNext:^(MessageModel *model) {
        if (model == nil) {
            return;
        }
        SystemContentView *sysView = [[SystemContentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [sysView setContent:model.content];
        [sysView showPopView:self];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 加载泡泡数据
- (void)loadPaopaoViewData{
    [self.ppMuArr removeAllObjects];
    __weak __typeof__(self) weakSelf = self;
    WCApiManager *manager = [WCApiManager sharedManager];
    //用户可收取金币信息
    [[manager ApiUserGold] subscribeNext:^(NSArray *array) {
        for (int i = 0; i < array.count; i++) {
            RedPackageModel *model = [RedPackageModel mj_objectWithKeyValues:array[i]];
            [weakSelf.ppMuArr addObject:model];
        }
        //        dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.paopaoView.receiveGoldArr = weakSelf.ppMuArr;
        //        });
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 获取未领取现金红包、福豆
- (void)loadNoRecevieCashBonus{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiNoReceiveCashBonus] subscribeNext:^(NSArray *arr) {
        if (arr.count == 0) {
            return;
        }
        for (int i = 0; i < arr.count; i++) {
            FotonModel *model = [FotonModel mj_objectWithKeyValues:arr[i]];
            NSLog(@"获取未领取红包：%.2f，,%@",model.money,model.operInfo);
            
            LimitBonusView *limitview = [[LimitBonusView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [limitview cashBonusView];
            [limitview setCashBonusData:model];
            [limitview showPopView:self];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)loadNoRecevieFoton{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiNoReceiveFoton] subscribeNext:^(NSArray *arr) {
        if (arr.count == 0) {
            return;
        }
        for (int i = 0; i < arr.count; i++) {
            FotonModel *model = [FotonModel mj_objectWithKeyValues:arr[i]];
//            NSLog(@"获取未领取福豆：%ld,,%@",model.blessBean,model.operInfo);
            OfflineView *futonView = [[OfflineView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [futonView setFutonView];
            [futonView setFotonData:model];
            [futonView showPopView:self];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 获取离线收益
- (void)loadOfflineProfit{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiOfflineProfit] subscribeNext:^(OfflineProfitModel *model) {
        if (model.goldCoin <= 0) {
            return;
        }
        self.offlineview = [[OfflineView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.offlineview.delegate = self;
        [self.offlineview setOfflineView];
        [self.offlineview setOfflineData:model];
        [self.offlineview showPopView:self];
    } error:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark 创建主页面
- (void)createMainUI{
    self.topView = [[UIView alloc] init];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ANDY_Adapta(814));
        make.top.mas_equalTo(0);
        make.left.and.width.mas_equalTo(self.view);
    }];
    self.topimg = [[UIImageView alloc] init];
    self.topimg.image = [UIImage imageNamed:@"sy_topImg"];
    [self.topView addSubview:self.topimg];
    [self.topimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(self.topView);
    }];
    //创建头部 头像  今日分红
    [self createTopHeadView];
    
    self.buildView = [[UIView alloc] init];
    self.buildView.backgroundColor = NavigationBarColor;
    [self.view addSubview:self.buildView];
    [self.buildView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.and.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(ANDY_Adapta(13));
    }];
    //金币 福豆 战队等
    [self createBuildBottomView];
    //创建tableview
    [self createTableView];
}
#pragma mark 头部 头像  今日分红
- (void)createTopHeadView{
    UIView *headView = [[UIView alloc] init];
    [self.topView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(20));
        make.width.mas_equalTo(ANDY_Adapta(316));
        make.height.mas_equalTo(ANDY_Adapta(107));
        make.top.mas_equalTo(ANDY_Adapta(71));
    }];
    
    UIView *headBgView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(100, 83, 181, 1) alpha:1.0 cornerRadius:ANDY_Adapta(36) borderWidth:0 borderColor:[UIColor clearColor]];
    [headView addSubview:headBgView];
    [headBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView);
        make.right.mas_equalTo(headView.mas_right);
        make.width.mas_equalTo(ANDY_Adapta(263));
        make.height.mas_equalTo(ANDY_Adapta(72));
    }];
    self.userName = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(16) textColor:[UIColor whiteColor] text:@"大秦帝国" Radius:0];
    [headBgView addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.mas_equalTo(headBgView);
        make.width.mas_equalTo(ANDY_Adapta(190));
        make.height.mas_equalTo(ANDY_Adapta(50));
    }];
    //进度条
    self.upgradeProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.upgradeProgress.layer.cornerRadius = ANDY_Adapta(3);
    self.upgradeProgress.layer.masksToBounds = YES;
    //已过进度条颜色
    self.upgradeProgress.progressTintColor = RGBA(254, 172, 56, 1);
    //未过
    self.upgradeProgress.trackTintColor = RGBA(57, 41, 109, 1);
    [headView addSubview:self.upgradeProgress];
    [self.upgradeProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userName.mas_left).inset(ANDY_Adapta(4));
        make.top.mas_equalTo(self.userName.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(133));
        make.height.mas_equalTo(ANDY_Adapta(8));
    }];
    
    UIImageView *headBgImg = [[UIImageView alloc] init];
    headBgImg.image = [UIImage imageNamed:@"sy_headBg"];
    [headView addSubview:headBgImg];
    [headBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(headView);
        make.width.mas_equalTo(ANDY_Adapta(120));
    }];
    
    self.headerImg = [[UIImageView alloc] init];
//    self.headerImg.image = [UIImage imageNamed:@"sy_head"];
    self.headerImg.layer.cornerRadius = ANDY_Adapta(46);
    self.headerImg.layer.masksToBounds = YES;
    [headBgImg addSubview:self.headerImg];
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(headBgImg);
        make.width.and.height.mas_equalTo(ANDY_Adapta(92));
    }];
    
    self.myHeadBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(0) normalColor:[UIColor clearColor] normalText:@"" click:^(id  _Nonnull x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GOMYCONTROLLER object:self userInfo:nil];
    }];
    [headView addSubview:self.myHeadBtn];
    [self.myHeadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(headView);
    }];
    
    //淘金 抽奖 排行榜 签到
    UIView *taojinView = [GGUI customButtonTopSize:0 bgImage:nil image:[UIImage imageNamed:@"sy_taojin"] imageSize:ANDY_Adapta(64) imgLabelSpace:ANDY_Adapta(55) labelSize:ANDY_Adapta(22) labelFont:Font_(12) labelColor:[UIColor whiteColor] title:@"淘金" click:^(id  _Nonnull x) {
        [self topClick:1];
    }];
    [self.topView addSubview:taojinView];
    [taojinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView).offset(ANDY_Adapta(15));
        make.left.mas_equalTo(headView.mas_right).offset(ANDY_Adapta(54));
        make.width.mas_equalTo(ANDY_Adapta(80));
        make.height.mas_equalTo(ANDY_Adapta(80));
    }];
    //抽奖
    UIView *luckView = [GGUI customButtonTopSize:0 bgImage:nil image:[UIImage imageNamed:@"sy_luckImg"] imageSize:ANDY_Adapta(64) imgLabelSpace:ANDY_Adapta(55) labelSize:ANDY_Adapta(22) labelFont:Font_(12) labelColor:[UIColor whiteColor] title:@"抽奖" click:^(id  _Nonnull x) {
        [self topClick:2];
    }];
    [self.topView addSubview:luckView];
    [luckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.and.height.mas_equalTo(taojinView);
        make.left.mas_equalTo(taojinView.mas_right).offset(ANDY_Adapta(2));
    }];
//    if ([PBCache shared].memberModel.userType == 2) {
//        luckView.hidden = YES;
//    }
    //排行榜
    UIView *rankView = [GGUI customButtonTopSize:0 bgImage:nil image:[UIImage imageNamed:@"sy_icon_jd"] imageSize:ANDY_Adapta(64) imgLabelSpace:ANDY_Adapta(55) labelSize:ANDY_Adapta(22) labelFont:Font_(12) labelColor:[UIColor whiteColor] title:@"决战" click:^(id  _Nonnull x) {
        [self topClick:3];
    }];
    [self.topView addSubview:rankView];
    [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.and.height.mas_equalTo(luckView);
        make.left.mas_equalTo(luckView.mas_right).inset(ANDY_Adapta(2));
    }];
    
    //签到
    UIView *teamView = [GGUI customButtonTopSize:0 bgImage:nil image:[UIImage imageNamed:@"sy_sign"] imageSize:ANDY_Adapta(64) imgLabelSpace:ANDY_Adapta(55) labelSize:ANDY_Adapta(22) labelFont:Font_(12) labelColor:[UIColor whiteColor] title:@"任务" click:^(id  _Nonnull x) {
        [self topClick:4];
    }];
    [self.topView addSubview:teamView];
    [teamView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.and.height.mas_equalTo(rankView);
        make.left.mas_equalTo(rankView.mas_right).inset(ANDY_Adapta(2));
    }];
    self.taojinview = taojinView;
    self.rankview = rankView;
    
    //今日分红
    UIView *profitView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(100, 83, 181, 1) alpha:1.0 cornerRadius:ANDY_Adapta(47) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.topView addSubview:profitView];
    [profitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left).offset(ANDY_Adapta(21));
        make.width.mas_equalTo(ANDY_Adapta(233));
        make.height.mas_equalTo(ANDY_Adapta(94));
        make.top.mas_equalTo(headView.mas_bottom).offset(ANDY_Adapta(20));
    }];
    
    self.profitLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(17) textColor:RGBA(255, 202, 21, 1) text:@"￥200.34" Radius:0];
    [profitView addSubview:self.profitLabel];
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(profitView).inset(ANDY_Adapta(27));
        make.top.mas_equalTo(profitView).offset(ANDY_Adapta(10));
        make.width.mas_equalTo(ANDY_Adapta(142));
        make.height.mas_equalTo(ANDY_Adapta(40));
    }];
    UIImageView *profitImg = [[UIImageView alloc] init];
    profitImg.image = [UIImage imageNamed:@"sy_profit"];
    [profitView addSubview:profitImg];
    [profitImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.profitLabel);
        make.left.mas_equalTo(self.profitLabel.mas_right);
        make.width.and.height.mas_equalTo(ANDY_Adapta(14));
    }];
    UILabel *profitlabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(11) textColor:[UIColor whiteColor] text:@"今日分红玉玺收益" Radius:0];
    [profitView addSubview:profitlabel1];
    [profitlabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(profitView);
        make.top.mas_equalTo(self.profitLabel.mas_bottom).offset(ANDY_Adapta(7));
        make.height.mas_equalTo(ANDY_Adapta(32));
    }];
    
    UIButton *profitBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(20) normalColor:[UIColor blackColor] normalText:@"" click:^(id  _Nonnull x) {
//        [self todayProfile];
        BonusController *bonusVc = [[BonusController alloc] init];
        bonusVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bonusVc animated:YES];
    }];
    [profitView addSubview:profitBtn];
    [profitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(profitView);
    }];
//    if (![WXApi isWXAppInstalled] || [PBCache shared].memberModel.userType == 2) {
//        profitView.hidden = YES;
//    }
    
    self.limitBonusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.limitBonusBtn setImage:[UIImage imageNamed:@"sy_limitbonus"] forState:UIControlStateNormal];
    [self.limitBonusBtn addTarget:self action:@selector(limitBonusAction) forControlEvents:UIControlEventTouchUpInside];
    self.limitBonusBtn.hidden = YES;
    [self.topView addSubview:self.limitBonusBtn];
    [self.limitBonusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ANDY_Adapta(23));
        make.top.mas_equalTo(profitView.mas_top);
    }];
    
    self.paopaoView = [[PaopaoView alloc] init];
    self.paopaoView.delegate = self;
    self.paopaoView.frame = CGRectMake(0, ANDY_Adapta(292), SCREENWIDTH, ANDY_Adapta(397));
    [self.topView addSubview:self.paopaoView];

}
#pragma mark 金币 福豆等
- (void)createBuildBottomView{
    //金币
            self.goldView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(21, 5, 49, 1) alpha:1 cornerRadius:ANDY_Adapta(24) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.topView addSubview:self.goldView];
    [self.goldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(20));
        make.bottom.mas_equalTo(self.topView.mas_bottom).inset(ANDY_Adapta(78));
        make.width.mas_equalTo(ANDY_Adapta(201));
        make.height.mas_equalTo(ANDY_Adapta(48));
    }];
    UIImageView *goldImg = [[UIImageView alloc] init];
    goldImg.image = [UIImage imageNamed:@"sy_jinbi"];
    [self.goldView addSubview:goldImg];
    [goldImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.goldView);
        make.left.mas_equalTo(self.goldView).inset(ANDY_Adapta(7));
        make.width.and.height.mas_equalTo(ANDY_Adapta(36));
    }];
    self.goldLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(16) textColor:RGBA(255, 202, 21, 1) text:@"2545.5K" Radius:0];
    [self.goldView addSubview:self.goldLabel];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(self.goldView);
        make.left.mas_equalTo(goldImg.mas_right).inset(ANDY_Adapta(4));
        make.right.mas_equalTo(self.goldView);
    }];
    //福豆
    self.fudouView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(21, 5, 49, 1) alpha:1 cornerRadius:ANDY_Adapta(24) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.topView addSubview:self.fudouView];
    [self.fudouView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(self.goldView);
        make.top.mas_equalTo(self.goldView.mas_bottom).inset(ANDY_Adapta(12));
    }];
    UIImageView *fudouImg = [[UIImageView alloc] init];
    fudouImg.image = [UIImage imageNamed:@"sy_fudou"];
    [self.fudouView addSubview:fudouImg];
    [fudouImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(goldImg);
        make.centerY.mas_equalTo(self.fudouView);
    }];
    self.fudouLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(16) textColor:RGBA(255, 202, 21, 1) text:@"2545.5K" Radius:0];
    [self.fudouView addSubview:self.fudouLabel];
    [self.fudouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.height.mas_equalTo(self.goldLabel);
        make.top.mas_equalTo(self.fudouView);
    }];
    //任务、决斗、典故卡、娱乐、玩法
    NSArray *titleArr = @[@"签到",@"排行榜",@"典故卡",@"娱乐",@"攻略"];
    NSArray *iconArr = @[@"sy_icon_rw",@"sy_rankImg",@"sy_icon_dgk",@"sy_icon_yl",@"sy_icon_rule"];
    for (int i = 0; i < titleArr.count; i++) {
        UIView *wcView = [GGUI customButtonTopSize:0 bgImage:[UIImage imageNamed:@""] image:[UIImage imageNamed:iconArr[i]] imageSize:ANDY_Adapta(68) imgLabelSpace:ANDY_Adapta(68) labelSize:ANDY_Adapta(23) labelFont:FontBold_(12) labelColor:[UIColor whiteColor] title:titleArr[i] click:^(id  _Nonnull x) {
            NSLog(@"%@",titleArr[i]);
            [self bottomClick:i];
        }];
        [self.topView addSubview:wcView];
//        if ([PBCache shared].memberModel.userType == 2) {
//            wcView.hidden = YES;
//        }
//        if (i == 3) {
//            wcView.hidden = YES;
//        }
        [wcView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fudouView.mas_right).offset(ANDY_Adapta(90)*i+ANDY_Adapta(75));
            make.width.mas_equalTo(ANDY_Adapta(70));
            make.height.mas_equalTo(ANDY_Adapta(91));
            make.bottom.mas_equalTo(self.topView.mas_bottom).inset(ANDY_Adapta(18));
        }];
    }
}
#pragma mark 创建tableview
- (void)createTableView{
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.bounces = NO;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.buildView addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buildView.mas_top);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.buildView);
        make.bottom.mas_equalTo(self.buildView.mas_bottom).offset(-ANDY_Adapta(20));
    }];
}
#pragma mark 推啊
- (void)createTuiaView{
    self.tuiaView = [[YLManager sharedManager] getTuiaXuanfuView:CGRectMake(ANDY_Adapta(30), ANDY_Adapta(50), self.limitBonusBtn.frame.size.width, self.limitBonusBtn.frame.size.height)];
    [self.paopaoView addSubview:self.tuiaView];
}
#pragma mark 今日分红
- (void)todayProfile{
    WCApiManager *manager  =[WCApiManager sharedManager];
    [[manager fetchDateProfitRecord:20 page:1] subscribeNext:^(RecordListModel *model) {
        NSLog(@"今日分红:%@",model.content);
    } error:^(NSError * _Nullable error) {
        NSLog(@"今日分红error:%@",error);
    }];
}
//顶部点击事件 淘金 抽奖 排行榜 签到
- (void)topClick:(NSInteger)index{
    switch (index) {
        case 1:
        {
            TaojinController *vc = [[TaojinController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            LuckDrawController *luckVc = [[LuckDrawController alloc] init];
            luckVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:luckVc animated:YES];
        }
            break;
        case 3:
        {
            PKViewController *pkvc = [[PKViewController alloc] init];
            pkvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pkvc animated:YES];
        }
            break;
        case 4:
        {
            TaskViewController *taskVc = [[TaskViewController alloc] init];
            taskVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:taskVc animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark 限时分红点击
- (void)limitBonusAction{
    LimitBonusController *limitVc = [[LimitBonusController alloc] init];
    limitVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:limitVc animated:YES];
}
#pragma mark 弹出签到弹窗
- (void)showSignInView:(SigninVoModel *)model{
    self.signinView = [SignInView new];
    self.signinView.isSignIn = model.signin;
    self.signinView.continuNum = model.continuNum;
    [self.signinView showPopView:self];
    self.signinView.dataArr = model.configs;
    self.continuNum = model.continuNum;
    self.signInArr = model.configs;
    self.signinView.delegate = self;
}
#pragma mark SignInViewDelegate
- (void)SingInActionBack:(VideoModel *)model{
    AdHandleManager *magager = [AdHandleManager sharedManager];
    magager.delegate = self;
    [magager RewardedSlotVideoAdViewRender:model videoType:1 viewController:self];
}
//不看视频点击签到
- (void)SingInNotVideo:(VideoModel *)model{
    [self watchVideoFinish:model withType:1];
}
#pragma mark OfflineViewDelegate
- (void)goldNotEnoughBack:(VideoModel *)model{
    AdHandleManager *manager = [AdHandleManager sharedManager];
    manager.delegate = self;
    [manager RewardedSlotVideoAdViewRender:model videoType:4 viewController:self];
}
- (void)offlineViewClose{
    self.notEnoughView = nil;
    [self.notEnoughView removeFromSuperview];
}
- (void)offlineGoldDoubleWithVideo:(VideoModel *)model{
    AdHandleManager *manager = [AdHandleManager sharedManager];
    manager.delegate = self;
    [manager RewardedSlotVideoAdViewRender:model videoType:8 viewController:self];
}
#pragma mark AdHandleManagerDelegate
- (void)BUADVideoFinish:(id)rewardedVideoAd withVideoModel:(VideoModel *)model withType:(NSInteger)type{
//    if ([model.advertChannel isEqualToString:BUADVIDEOTYPE]) {
//        BUNativeExpressRewardedVideoAd *rewardedVideoAd = rewardedVideoAd;
//        [self watchVideoFinish:model withType:rewardedVideoAd.rewardedVideoModel.rewardAmount];
//    }else if ([model.advertChannel isEqualToString:TENCENTVIDEOTYPE]){
//        [self watchVideoFinish:model withType:type];
//    }else if ([model.advertChannel isEqualToString:SIGMOBVIDEOTYPE]){
//        [self watchVideoFinish:model withType:type];
//    }
    [self watchVideoFinish:model withType:type];
}
- (void)watchVideoFinish:(VideoModel *)model withType:(NSInteger)type{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager WatchFinish:model.videoId] subscribeNext:^(id  _Nullable x) {
        if (type == 1) {
            [self.signinView closeAction];
            //签到成功
            [self showSignInSuccessView];
        }else if (type == 4){
            [self.notEnoughView closeAction];
            [self GoldFotonData];
        }else if (type == 8){
            [self.offlineview closeAction];
            [self GoldFotonData];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 弹出签到成功弹窗
- (void)showSignInSuccessView{
    self.continuNum++;
    SignInConfigModel *model = self.signInArr[self.continuNum-1];
    SignInSuccessView *successView = [SignInSuccessView new];
    [successView setDataContinuNum:self.continuNum reward:model.reward rewardType:[self signInName:model.rewardType]];
    [successView showPopView:self];
}
//签到奖励名字配置  GOLD:金币，REBIRTH_CARD:复活卡，BLESS_BEAN:福豆
- (NSString *)signInName:(NSString *)keyStr{
    if ([keyStr isEqualToString:@"GOLD"]) {
        return @"金币";
    }
    if ([keyStr isEqualToString:@"REBIRTH_CARD"]) {
        return @"复活卡";
    }
    if ([keyStr isEqualToString:@"BLESS_BEAN"]) {
        return @"福豆";
    }
    return @"";
}
//底部点击事件 签到、排行榜、典故卡、娱乐、玩法
- (void)bottomClick:(NSInteger)num{
    switch (num) {
        case 0:
        {
            WCApiManager *manager = [WCApiManager sharedManager];
            [[manager ApiSignInInfo] subscribeNext:^(SigninVoModel *model) {
                [self showSignInView:model];
            } error:^(NSError * _Nullable error) {
                
            }];
        }
            break;
        case 1:
        {
            RankController *rankVc = [[RankController alloc] init];
            rankVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rankVc animated:YES];
        }
            break;
        case 2:
        {
            DianGuKaController *vc = [[DianGuKaController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:   //娱乐
        {
            YuLeController *yuleVc = [[YuLeController alloc] init];
            yuleVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:yuleVc animated:YES];
        }
            break;
        case 4:   //玩法
        {
            WCWebViewController *webController = [[WCWebViewController alloc] initWithOpenUrl:[PBCache shared].systemModel.indexPlayRule title:@"玩法规则"];
            webController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webController animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(144);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainTablArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"MianTableCell";
    MianTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MianTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.mainTablArr.count > indexPath.row) {
        [cell setData:self.mainTablArr[indexPath.row] index:indexPath.row];
    }
    __weak __typeof__(self) weakSelf = self;
    cell.sjblock = ^(DynastyBuildModel * _Nonnull dyModel, NSInteger index, NSInteger money) {
        //主城进度
        weakSelf.upgradeProgress.progress = [dyModel.process floatValue];
        [weakSelf.mainTablArr replaceObjectAtIndex:index withObject:dyModel];
        [weakSelf unlockAction:index];
        if ([PBCache shared].goldModel.goldCoins-money < 0) {  //小于0 去刷新金币
            [weakSelf GoldFotonData];
        }else{
            weakSelf.goldLabel.text = [GGUI goldConversion:[NSString stringWithFormat:@"%ld",[PBCache shared].goldModel.goldCoins-money]];
            [PBCache shared].goldModel.goldCoins = [PBCache shared].goldModel.goldCoins - money;
        }
        //可以升级朝代
        NSLog(@"self.mainDynastymModel.status:%ld",self.mainDynastymModel.status);
        if ([dyModel.process floatValue] == 1 && self.mainDynastymModel.status != 2) {
            [self nextDynastyInfo];
        }
    };
    return cell;
}
//判断哪些建筑能解锁
- (void)unlockAction:(NSInteger)index{
    //当前升级model
    DynastyBuildModel *currentModel = self.mainTablArr[index];
    for (int i = 0; i < self.mainTablArr.count; i++) {
        if (i != index) {
            DynastyBuildModel *model = self.mainTablArr[i];
            //前置解锁编码=当前升级建筑编码  &&  前置解锁数量=当前建筑购买数 即解锁此建筑
            if (([model.preLockStructureCode isEqualToString:currentModel.structureCode]) && (model.preLockNumber <= currentModel.buyNumber)) {
                model.unlock = YES;
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                MianTableCell *cell = [self.mainTableView cellForRowAtIndexPath:indexpath];
                [cell setData:model index:i];
//                NSLog(@"建筑是否解锁：%ld,,%@,,%@,,%ld,,%d",model.unlock,model.preLockStructureCode,currentModel.structureCode,index,i);
            }
        }
    }
}
//获取下一个朝代信息 朝代弹窗美容显示   点继续经营调朝代翻篇
- (void)nextDynastyInfo{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiNextDynasty:self.mainDynastymModel.dynasty] subscribeNext:^(DynastyModel *dynastyModel) {
        //下一个朝代编码大于当前朝代编码进入下一个朝代 否则 朝代重置
        [self.topimg setImageURL:[NSURL URLWithString:dynastyModel.backgroundImg]];
        NSLog(@"下一个朝代等级：%ld,,,当前朝代等级:%ld",dynastyModel.dynasty,self.mainDynastymModel.dynasty);
        if (dynastyModel.dynasty > self.mainDynastymModel.dynasty) {
            [self PopDynastyView:dynastyModel type:1];
        }else{
            [self PopDynastyView:dynastyModel type:2];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
//type=1 朝代翻篇  type=2朝代重置
- (void)PopDynastyView:(DynastyModel *)model type:(NSInteger)type{
    self.dyView = [[DynastyView alloc] init];
    self.dyView.delegate = self;
    [self.dyView showPopView:self];
    [self.dyView loadData:model type:type];
}
#pragma mark DynastyViewDelegate
- (void)goOnOperation:(NSInteger)type{
    WCApiManager *manager = [WCApiManager sharedManager];
    if (type == 1) {  //朝代翻篇
        [[manager ApiDynastyFanPian] subscribeNext:^(DynastyFanPianModel *model1) {
            [self.dyView closeAction];
            self.mainDynastymModel = model1.userDynasty;
            self.userName.text = model1.userDynasty.dynastyName;
            self.upgradeProgress.progress = [model1.userDynasty.process floatValue];
            [self.mainTablArr removeAllObjects];
            for (int i = 0; i < model1.userDynasty.structures.count; i++) {
                [self.mainTablArr addObject:model1.userDynasty.structures[i]];
            }
            [self.mainTableView reloadData];
            [self showDiangukaView:model1.allusion];
        } error:^(NSError * _Nullable error) {
            
        }];
    }else{  //朝代重置
        [[manager ApiDynastyReset] subscribeNext:^(DynastyFanPianModel *model1) {
            [self.dyView closeAction];
            self.mainDynastymModel = model1.userDynasty;
            self.userName.text = model1.userDynasty.dynastyName;
            self.upgradeProgress.progress = [model1.userDynasty.process floatValue];
            [self.mainTablArr removeAllObjects];
            for (int i = 0; i < model1.userDynasty.structures.count; i++) {
                [self.mainTablArr addObject:model1.userDynasty.structures[i]];
            }
            [self.mainTableView reloadData];
            [self showDiangukaView:model1.allusion];
        } error:^(NSError * _Nullable error) {
            
        }];
    }
}
- (void)showDiangukaView:(DianGuKaModel *)model{
    self.dgkView = [[DianGuKaView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.dgkView setData:model withType:1];
    [self.dgkView showPopView:self];
}
#pragma mark PaopaoViewDelegate
- (void)selectUnlimitedBtnAtIndex:(NSInteger)index withButton:(nonnull PaopaoButton *)btn{
    [self.paopaoView removeRandomIndex:index];
    NSLog(@"红包id:%ld",btn.redId);
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiCollectGold:btn.redId] subscribeNext:^(RedPackageModel *redModel) {
        self.goldLabel.text = [GGUI goldConversion:[NSString stringWithFormat:@"%ld",[PBCache shared].goldModel.goldCoins+(int)redModel.stealMoney]];
        [PBCache shared].goldModel.goldCoins = [PBCache shared].goldModel.goldCoins + (int)redModel.stealMoney;
        [self goldLabelAnimation];
    } error:^(NSError * _Nullable error) {
        
    }];
}
//金币增加动画 放大缩小
- (void)goldLabelAnimation{
    [UIView animateWithDuration:0.25 animations:^{
        self.goldLabel.transform = CGAffineTransformMake(1.5, 0, 0, 1.5, 0, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.goldLabel.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
        } completion:^(BOOL finished) {
            
        }];
    }];
}
//泡泡移动动画
- (void)movePaopaoBtnAnimation:(PaopaoButton *)btn{
    
}

- (void)selectUnlimitedBtnAtIndex:(NSInteger)index
{
    [self.paopaoView removeRandomIndex:index];
}

- (void)allCollected
{
    NSLog(@"全都点完了");
    //泡泡全部点完重新加载泡泡数据
    [self loadPaopaoViewData];
}
#pragma mark 获取用户信息
//获取用户信息
- (void)getUserInfo:(NSInteger)userid{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserInfo:userid] subscribeNext:^(UserModel *model) {
        [PBCache shared].userModel = model;
        [self.headerImg setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 图片抖动动画
- (void)viewShakeAnimation:(UIView *)shakeView withAngle:(NSInteger)angle{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 0.25;
    animation.repeatCount = MAXFLOAT;
    //设置抖动数值
    animation.values = @[@(ANGLE_TO_RADIAN(-angle)),@(ANGLE_TO_RADIAN(angle)),@(ANGLE_TO_RADIAN(-angle))];
    //保持最后的状态
    animation.removedOnCompletion=NO;
    //动画的填充模式
    animation.fillMode=kCAFillModeForwards;
    //layer层实现动画
    [shakeView.layer addAnimation:animation forKey:@"shake"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESHLIMITTAMEDATA object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:GOLDNOTENOUGH object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESHGOLDCOINS object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MQTTCLIENTCONNECT object:nil];
}

@end
