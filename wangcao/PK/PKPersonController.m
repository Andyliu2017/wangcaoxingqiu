//
//  PKPersonController.m
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import "PKPersonController.h"
#import "PKBattleController.h"
#import "WatchVideoBattleView.h"

@interface PKPersonController ()<WatchVideoBattleViewDelegate,AdHandleManagerDelegate>

@property (nonatomic,strong) UIButton *goOnBtn;  //继续挑战
@property (nonatomic,strong) UILabel *personRankLabel;  //当前名次
@property (nonatomic,strong) UILabel *personAnswerNum;  //答题数量
@property (nonatomic,assign) BOOL isViewDidLoad;
@property (nonatomic,strong) PKPersonInfoModel *personModel;
//看视频继续挑战弹窗
@property (nonatomic,strong) WatchVideoBattleView *videoView;

@end

@implementation PKPersonController

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
    [self getData];
    self.isViewDidLoad = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isViewDidLoad) {
        self.isViewDidLoad = NO;
        return;
    }
    [self getData];
}
#pragma mark 界面
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
    
    UIImageView *titleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_person_title"]];
    [self.view addSubview:titleImg];
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(131));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(441));
        make.height.mas_equalTo(ANDY_Adapta(93));
    }];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_person_icon"]];
    [violetView2 addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(violetView2);
        make.top.mas_equalTo(ANDY_Adapta(33));
        make.width.mas_equalTo(ANDY_Adapta(250));
        make.height.mas_equalTo(ANDY_Adapta(283));
    }];
    
    UIView *blackView1 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(97, 70, 176, 1) alpha:1.0 cornerRadius:ANDY_Adapta(49) borderWidth:0 borderColor:[UIColor clearColor]];
    [violetView2 addSubview:blackView1];
    [blackView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(317));
        make.centerX.mas_equalTo(violetView2);
        make.width.mas_equalTo(ANDY_Adapta(627));
        make.height.mas_equalTo(ANDY_Adapta(98));
    }];
    UIView *whiteView1 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(244, 244, 255, 1) alpha:1.0 cornerRadius:ANDY_Adapta(49) borderWidth:0 borderColor:[UIColor clearColor]];
    [violetView2 addSubview:whiteView1];
    [whiteView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(307));
        make.left.and.width.and.height.mas_equalTo(blackView1);
    }];
    UILabel *rankLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:RGBA(87, 49, 143, 1) text:@"当前排名" Radius:0];
    [whiteView1 addSubview:rankLabel];
    [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(53));
        make.top.and.bottom.mas_equalTo(whiteView1);
        make.width.mas_equalTo(ANDY_Adapta(240));
    }];
    self.personRankLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(15) textColor:RGBA(87, 49, 143, 1) text:@"" Radius:0];
    [whiteView1 addSubview:self.personRankLabel];
    [self.personRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rankLabel.mas_right);
        make.top.and.bottom.mas_equalTo(whiteView1);
        make.right.mas_equalTo(-ANDY_Adapta(47));
    }];
    
    UIView *blackView2 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(97, 70, 176, 1) alpha:1.0 cornerRadius:ANDY_Adapta(49) borderWidth:0 borderColor:[UIColor clearColor]];
    [violetView2 addSubview:blackView2];
    [blackView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blackView1.mas_bottom).offset(ANDY_Adapta(23));
        make.centerX.mas_equalTo(violetView2);
        make.width.mas_equalTo(ANDY_Adapta(627));
        make.height.mas_equalTo(ANDY_Adapta(98));
    }];
    UIView *whiteView2 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(244, 244, 255, 1) alpha:1.0 cornerRadius:ANDY_Adapta(49) borderWidth:0 borderColor:[UIColor clearColor]];
    [violetView2 addSubview:whiteView2];
    [whiteView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blackView1.mas_bottom).offset(ANDY_Adapta(13));
        make.left.and.width.and.height.mas_equalTo(blackView1);
    }];
    UILabel *totalLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:RGBA(87, 49, 143, 1) text:@"当前总答对题数" Radius:0];
    [whiteView2 addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(53));
        make.top.and.bottom.mas_equalTo(whiteView2);
        make.width.mas_equalTo(ANDY_Adapta(240));
    }];
    self.personAnswerNum = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(15) textColor:RGBA(87, 49, 143, 1) text:@"" Radius:0];
    [whiteView2 addSubview:self.personAnswerNum];
    [self.personAnswerNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(totalLabel.mas_right);
        make.top.and.bottom.mas_equalTo(whiteView2);
        make.right.mas_equalTo(-ANDY_Adapta(47));
    }];
    
    UIView *yellowView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(171, 99, 35, 1) alpha:1.0 cornerRadius:ANDY_Adapta(48) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:yellowView];
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(violetView1.mas_bottom).offset(ANDY_Adapta(39));
        make.width.mas_equalTo(ANDY_Adapta(533));
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    self.goOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goOnBtn.layer.cornerRadius = ANDY_Adapta(48);
    self.goOnBtn.layer.masksToBounds = YES;
    self.goOnBtn.titleLabel.font = FontBold_(15);
    [self.goOnBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    [self.goOnBtn setTitle:@"继续挑战" forState:UIControlStateNormal];
    [self.goOnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.goOnBtn addTarget:self action:@selector(goOnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goOnBtn];
    [self.goOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(violetView1.mas_bottom).offset(ANDY_Adapta(29));
        make.left.and.width.and.height.mas_equalTo(yellowView);
    }];
}
#pragma mark 数据
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKPersonInfo] subscribeNext:^(PKPersonInfoModel *model) {
        self.personModel = model;
        self.personRankLabel.text = [NSString stringWithFormat:@"%ld名",model.rank];
        if (model.rank == -1) {
            self.personRankLabel.text = @"0名";
        }
        self.personAnswerNum.text = [NSString stringWithFormat:@"%ld题",model.answerNumber];
        if (model.sulplusBattleNumber == model.totalBattleNumber) {
            [self.goOnBtn setTitle:[NSString stringWithFormat:@"开始挑战%ld/%ld",model.sulplusBattleNumber,model.totalBattleNumber] forState:UIControlStateNormal];
        }else{
            [self.goOnBtn setTitle:[NSString stringWithFormat:@"继续挑战%ld/%ld",model.sulplusBattleNumber,model.totalBattleNumber] forState:UIControlStateNormal];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)goOnAction{
    //是否必须看广告
    if (self.personModel.isMustAd) {
        self.videoView = [[WatchVideoBattleView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.videoView setVideoIdData:self.personModel.videoAd];
        self.videoView.delegate = self;
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
//开始答题
- (void)getBattleData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKStart:@"PERSONAL"] subscribeNext:^(id  _Nullable x) {
        NSDictionary *dic = x;
        [PBCache shared].code = dic[@"code"];
        PKBattleController *vc = [[PKBattleController alloc] init];
        vc.battleType = @"PERSONAL";
        [self.navigationController pushViewController:vc animated:YES];
    } error:^(NSError * _Nullable error) {
        NSLog(@"error:%@",error);
    }];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
