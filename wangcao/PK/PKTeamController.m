//
//  PKTeamController.m
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import "PKTeamController.h"
#import "PKBattleController.h"
#import "InvitaView.h"
#import "SharePopView.h"
#import "WatchVideoBattleView.h"

@interface PKTeamController ()<WatchVideoBattleViewDelegate,AdHandleManagerDelegate>

//战队号
@property (nonatomic,strong) UILabel *teamNumLabel;
//战队人数 1/6
@property (nonatomic,strong) UILabel *teamPersonLabel;
@property (nonatomic,strong) UIScrollView *teamScroll;
@property (nonatomic,strong) NSMutableArray *teamArr;  //战队用户数据
@property (nonatomic,strong) PKTeamInfoModel *teamModel;  //当前战队信息
//团队排名
@property (nonatomic,strong) UILabel *teamRankLabel;
//当前团队总答对题数
@property (nonatomic,strong) UILabel *answerNumLabel;
//邀请好友
@property (nonatomic,strong) UIButton *inviteBtn;
//继续挑战
@property (nonatomic,strong) UIButton *goOnBtn;
//看视频继续挑战弹窗
@property (nonatomic,strong) WatchVideoBattleView *videoView;
 
@end

@implementation PKTeamController

- (NSMutableArray *)teamArr{
    if (!_teamArr) {
        _teamArr = [NSMutableArray array];
    }
    return _teamArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_bg"]];
    bgImg.userInteractionEnabled = YES;
    [self.view addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.width.and.height.mas_equalTo(self.view);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"pk_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(23));
        make.top.mas_equalTo(ANDY_Adapta(88));
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    [self createUI];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getData];
}
#pragma mark UI
- (void)createUI{
    UIView *violetView1 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(97, 70, 176, 1) alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:violetView1];
    [violetView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(ANDY_Adapta(217));
        make.width.mas_equalTo(ANDY_Adapta(654));
        make.height.mas_equalTo(ANDY_Adapta(567));
    }];
    
    UIView *violetView2 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(145, 116, 229, 1) alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:violetView2];
    [violetView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(violetView1);
        make.top.mas_equalTo(ANDY_Adapta(207));
    }];
    
    UIImageView *titleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_team_title"]];
    [self.view addSubview:titleImg];
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(131));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(441));
        make.height.mas_equalTo(ANDY_Adapta(93));
    }];
    
    self.teamNumLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"战队号：" Radius:0];
    [violetView2 addSubview:self.teamNumLabel];
    [self.teamNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(violetView2);
        make.top.mas_equalTo(ANDY_Adapta(15));
        make.width.mas_equalTo(ANDY_Adapta(415));
        make.height.mas_equalTo(ANDY_Adapta(67));
    }];
    self.teamPersonLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:RGBA(196, 186, 248, 1) text:@"" Radius:0];
    [violetView2 addSubview:self.teamPersonLabel];
    [self.teamPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.teamNumLabel.mas_right);
        make.top.and.bottom.mas_equalTo(self.teamNumLabel);
        make.right.mas_equalTo(violetView2.mas_right);
    }];
    
    UIView *blackView1 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(145, 116, 229, 1) alpha:1.0 cornerRadius:ANDY_Adapta(49) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:blackView1];
    [blackView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(violetView1.mas_bottom).offset(ANDY_Adapta(33));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(654));
        make.height.mas_equalTo(ANDY_Adapta(98));
    }];
    UIView *whiteView1 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(244, 244, 255, 1) alpha:1.0 cornerRadius:ANDY_Adapta(49) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:whiteView1];
    [whiteView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(violetView1.mas_bottom).offset(ANDY_Adapta(23));
        make.left.and.width.and.height.mas_equalTo(blackView1);
    }];
    UILabel *rankLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:RGBA(87, 49, 143, 1) text:@"当前团队排名" Radius:0];
    [whiteView1 addSubview:rankLabel];
    [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(53));
        make.top.and.bottom.mas_equalTo(whiteView1);
        make.width.mas_equalTo(ANDY_Adapta(320));
    }];
    self.teamRankLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(15) textColor:RGBA(87, 49, 143, 1) text:@"" Radius:0];
    [whiteView1 addSubview:self.teamRankLabel];
    [self.teamRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rankLabel.mas_right);
        make.top.and.bottom.mas_equalTo(whiteView1);
        make.right.mas_equalTo(-ANDY_Adapta(47));
    }];
    
    UIView *blackView2 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(145, 116, 229, 1) alpha:1.0 cornerRadius:ANDY_Adapta(49) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:blackView2];
    [blackView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blackView1.mas_bottom).offset(ANDY_Adapta(23));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(654));
        make.height.mas_equalTo(ANDY_Adapta(98));
    }];
    UIView *whiteView2 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(244, 244, 255, 1) alpha:1.0 cornerRadius:ANDY_Adapta(49) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:whiteView2];
    [whiteView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blackView1.mas_bottom).offset(ANDY_Adapta(13));
        make.left.and.width.and.height.mas_equalTo(blackView1);
    }];
    UILabel *totalLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:RGBA(87, 49, 143, 1) text:@"当前团队总答对题数" Radius:0];
    [whiteView2 addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(53));
        make.top.and.bottom.mas_equalTo(whiteView2);
        make.width.mas_equalTo(ANDY_Adapta(320));
    }];
    self.answerNumLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(15) textColor:RGBA(87, 49, 143, 1) text:@"" Radius:0];
    [whiteView2 addSubview:self.answerNumLabel];
    [self.answerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(totalLabel.mas_right);
        make.top.and.bottom.mas_equalTo(whiteView2);
        make.right.mas_equalTo(-ANDY_Adapta(47));
    }];
    
    UIView *inviteView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(171, 99, 35, 1) alpha:1.0 cornerRadius:ANDY_Adapta(48) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:inviteView];
    [inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(blackView2.mas_left);
        make.top.mas_equalTo(blackView2.mas_bottom).offset(ANDY_Adapta(39));
        make.width.mas_equalTo(ANDY_Adapta(310));
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    self.inviteBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(15) normalColor:[UIColor whiteColor] normalText:@"邀请好友" click:^(id  _Nonnull x) {
        [self invaiteAction];
    }];
    [self.inviteBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    self.inviteBtn.layer.cornerRadius = ANDY_Adapta(48);
    self.inviteBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.inviteBtn];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(inviteView);
        make.top.mas_equalTo(blackView2.mas_bottom).offset(ANDY_Adapta(29));
    }];
//    if (![WXApi isWXAppInstalled]) {
//        self.inviteBtn.hidden = YES;
//    }
    
    UIView *goOnView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(97, 70, 176, 1) alpha:1.0 cornerRadius:ANDY_Adapta(48) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:goOnView];
    [goOnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.and.height.mas_equalTo(inviteView);
        make.right.mas_equalTo(blackView2.mas_right);
    }];
    self.goOnBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(15) normalColor:[UIColor whiteColor] normalText:@"继续挑战" click:^(id  _Nonnull x) {
        [self goOnAction];
    }];
    [self.goOnBtn setBackgroundColor:RGBA(170, 151, 254, 1)];
    self.goOnBtn.layer.cornerRadius = ANDY_Adapta(48);
    self.goOnBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.goOnBtn];
    [self.goOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.and.height.mas_equalTo(self.inviteBtn);
        make.right.mas_equalTo(goOnView.mas_right);
    }];
    
    self.teamScroll = [[UIScrollView alloc] init];
    [violetView2 addSubview:self.teamScroll];
    [self.teamScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teamNumLabel.mas_bottom);
        make.left.and.right.and.bottom.mas_equalTo(violetView2);
    }];
}
- (void)createScrollSubViews:(NSMutableArray *)subArr{
    NSInteger indexNum;
    if (subArr.count < 6) {
        indexNum = 6;
        self.teamScroll.contentSize = CGSizeMake(self.teamScroll.frame.size.width, ANDY_Adapta(474));
    }else{
        indexNum = subArr.count;
        if (indexNum%3 > 0) {
            self.teamScroll.contentSize = CGSizeMake(self.teamScroll.frame.size.width, ANDY_Adapta(237)*(indexNum/3+1));
        }else{
            self.teamScroll.contentSize = CGSizeMake(self.teamScroll.frame.size.width, ANDY_Adapta(237)*(indexNum/3));
        }
    }
    for (int i = 0; i < indexNum; i++) {
        InvitaView *vitaView = [[InvitaView alloc] initWithFrame:CGRectMake(ANDY_Adapta(26)+ANDY_Adapta(209)*(i%3), ANDY_Adapta(237)*(i/3), ANDY_Adapta(188), ANDY_Adapta(214))];
        [self.teamScroll addSubview:vitaView];
        if (subArr.count > i) {  //无数据
            [vitaView setData:subArr[i] withType:1];
        }else{
            [vitaView setData:nil withType:2];
        }
    }
}
#pragma mark 数据
- (void)getData{
    //获取战队信息
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKTeamInfo] subscribeNext:^(PKTeamInfoModel *model) {
        self.teamModel = model;
        self.teamNumLabel.text = [NSString stringWithFormat:@"战队号：%ld",model.team_id];
        self.teamPersonLabel.text = [NSString stringWithFormat:@"(%ld/%ld)",model.groupPeoples,model.groupMaxPeoples];
        self.teamRankLabel.text = [NSString stringWithFormat:@"%ld名",model.rank];
        if (model.rank == -1) {
            self.teamRankLabel.text = @"0名";
        }
        self.answerNumLabel.text = [NSString stringWithFormat:@"%ld题",model.answerNumber];
        [self getGroupUserInfo:model.team_id];
        if (model.sulplusBattleNumber == model.totalBattleNumber) {
            [self.goOnBtn setTitle:[NSString stringWithFormat:@"开始挑战%ld/%ld",model.sulplusBattleNumber,model.totalBattleNumber] forState:UIControlStateNormal];
        }else{
            [self.goOnBtn setTitle:[NSString stringWithFormat:@"继续挑战%ld/%ld",model.sulplusBattleNumber,model.totalBattleNumber] forState:UIControlStateNormal];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)getGroupUserInfo:(NSInteger)groupId{
    //获取战队用户信息
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKTeamUserInfo:groupId] subscribeNext:^(NSArray *array) {
        [self.teamArr removeAllObjects];
        for (int i = 0; i < array.count; i++) {
            TeamNumberModel *teamModel = [TeamNumberModel mj_objectWithKeyValues:array[i]];
            [self.teamArr addObject:teamModel];
        }
        [self createScrollSubViews:self.teamArr];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 点击事件
//邀请好友
- (void)invaiteAction{
    SharePopView *popview = [SharePopView new];
    [popview setDataWithImg:[UIImage imageNamed:@"share_pk_bg"] type:2 teamNum:[NSString stringWithFormat:@"%ld",self.teamModel.team_id] nickName:[PBCache shared].userModel.nickName qrcode:self.teamModel.qrcodeUrl];
    [popview showView];
}
//继续挑战
- (void)goOnAction{
    //是否必须看广告
    if (self.teamModel.isMustAd) {
        self.videoView = [[WatchVideoBattleView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.videoView.delegate = self;
        [self.videoView setVideoIdData:self.teamModel.videoAd];
        [self.videoView showPopView:self];
    }else{
        [self getBattleData];
    }
}
#pragma mark WatchVideoBattleViewDelegate看视频继续挑战
- (void)WatchVideoBattleViewBack:(VideoModel *)model{
    //拉起视频
    AdHandleManager *manager = [AdHandleManager sharedManager];
    manager.delegate = self;
    [manager RewardedSlotVideoAdViewRender:model videoType:6 viewController:self];
}
//跳过视频
- (void)noVideoBattleViewBack:(VideoModel *)model{
    [self watchVideoSuccess:model.videoId withType:6];
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
- (void)watchVideoSuccess:(NSString *)videoId withType:(NSInteger)type{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager WatchFinish:videoId] subscribeNext:^(id  _Nullable x) {
        if (type == 6) {
            [self getBattleData];
            [self.videoView closeAction];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}

//开始挑战
- (void)getBattleData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKStart:@"GROUP"] subscribeNext:^(id  _Nullable x) {
        NSDictionary *dic = x;
        [PBCache shared].code = dic[@"code"];
        PKBattleController *vc = [[PKBattleController alloc] init];
        vc.battleType = @"GROUP";
        [self.navigationController pushViewController:vc animated:YES];
    } error:^(NSError * _Nullable error) {
        NSLog(@"error:%@",error);
    }];
}
//返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
