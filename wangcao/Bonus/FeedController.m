//
//  FeedController.m
//  wangcao
//
//  Created by liu dequan on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import "FeedController.h"

@interface FeedController ()

@property (nonatomic,strong) UIImageView *feedBg1;
@property (nonatomic,strong) UIImageView *feedBg2;
//feed1
@property (nonatomic,strong) UIProgressView *feedProgress; //进度条
@property (nonatomic,strong) UILabel *feedLabel;

@end

@implementation FeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NavigationBarColor;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"luck_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(23));
        make.top.mas_equalTo(ANDY_Adapta(88));
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    
    [self createUI];
    [self loadData];
}
- (void)createUI{
    UIImageView *headrImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_title"]];
    [self.view addSubview:headrImg];
    [headrImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(spaceHeight(88));
        make.width.mas_equalTo(ANDY_Adapta(305));
        make.height.mas_equalTo(ANDY_Adapta(47));
    }];
    self.feedBg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_bg1"]];
    [self.view addSubview:self.feedBg1];
    [self.feedBg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(headrImg.mas_bottom).offset(spaceHeight(39));
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(226));
    }];
    self.feedBg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_bg2"]];
    self.feedBg2.userInteractionEnabled = YES;
    [self.view addSubview:self.feedBg2];
    [self.feedBg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.feedBg1.mas_bottom).offset(spaceHeight(8));
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(611));
    }];
    [self createFeedOne];
    [self createFeedTwo];
}
- (void)createFeedOne{
    UILabel *feedYuxi = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"分红玉玺加速" Radius:0];
    [self.feedBg1 addSubview:feedYuxi];
    [feedYuxi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(39));
        make.top.mas_equalTo(ANDY_Adapta(11));
        make.right.mas_equalTo(self.feedBg1);
        make.height.mas_equalTo(ANDY_Adapta(93));
    }];
    self.feedProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.feedProgress.progress = 0.10485;
    self.feedProgress.layer.cornerRadius = ANDY_Adapta(10);
    self.feedProgress.layer.masksToBounds = YES;
    //已过进度条颜色
    self.feedProgress.progressTintColor = RGBA(71, 195, 94, 1);
    //未过
    self.feedProgress.trackTintColor = RGBA(244, 244, 244, 1);
    [self.feedBg1 addSubview:self.feedProgress];
    [self.feedProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(41));
        make.top.mas_equalTo(feedYuxi.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(608));
        make.height.mas_equalTo(ANDY_Adapta(20));
    }];
    self.feedLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:MessageColor text:@"" Radius:0];
    [self.feedBg1 addSubview:self.feedLabel];
    [self.feedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(feedYuxi.mas_left);
        make.top.mas_equalTo(self.feedProgress.mas_bottom).offset(ANDY_Adapta(19));
        make.right.mas_equalTo(self.feedBg1);
        make.height.mas_equalTo(ANDY_Adapta(45));
    }];
}
- (void)createFeedTwo{
    UILabel *feedTitle2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"提升进度早分红" Radius:0];
    [self.feedBg2 addSubview:feedTitle2];
    [feedTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(29));
        make.top.mas_equalTo(self.feedBg2).offset(ANDY_Adapta(9));
        make.right.mas_equalTo(self.feedBg2);
        make.height.mas_equalTo(ANDY_Adapta(77));
    }];
    NSArray *imgArr = @[@"feed_invita",@"feed_active",@"feed_friend",@"feed_try"];
    NSArray *titleArr = @[@"有效邀请",@"提升活跃度",@"好友活跃度",@"试玩任务活跃度"];
    NSArray *contenArr;
//    if ([PBCache shared].memberModel.userType == 2) {
//        contenArr = @[@"邀请好友越多，好友越活跃，进度越快",@"",@"好友越活跃，速度越快",@"完成试玩任务越多，速度越快"];
//    }else{
        contenArr = @[@"邀请好友越多，好友越活跃，进度越快",@"收金币、偷金币次数和视频次数，进度越快",@"好友越活跃，速度越快",@"完成试玩任务越多，速度越快"];
//    }
    for (int i = 0; i < 4; i++) {
        UIView *feedview = [self feedTwoView:[UIImage imageNamed:imgArr[i]] title:titleArr[i] content:contenArr[i] index:i];
        [self.feedBg2 addSubview:feedview];
        [feedview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(feedTitle2.mas_bottom).offset(ANDY_Adapta(2)+i*ANDY_Adapta(120));
            make.height.mas_equalTo(ANDY_Adapta(120));
        }];
    }
}
- (UIView *)feedTwoView:(UIImage *)image title:(NSString *)title content:(NSString *)content index:(NSInteger)index{
    UIView *view = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:image];
    [view addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(37));
        make.centerY.mas_equalTo(0);
        make.width.and.height.mas_equalTo(ANDY_Adapta(99));
    }];
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:title Radius:0];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImg.mas_right).offset(ANDY_Adapta(30));
        make.top.mas_equalTo(iconImg.mas_top).offset(ANDY_Adapta(6));
        make.width.mas_equalTo(ANDY_Adapta(480));
        make.height.mas_equalTo(ANDY_Adapta(47));
    }];
    UILabel *contentLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(11) textColor:MessageColor text:content Radius:0];
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(42));
    }];
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_arrow"]];
    [view addSubview:arrowImg];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(titleLabel.mas_right);
        make.width.and.height.mas_equalTo(ANDY_Adapta(20));
    }];
    if (index != 3) {
        UIImageView *lineImg = [[UIImageView alloc] init];
        lineImg.backgroundColor = LineColor;
        [view addSubview:lineImg];
        [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.bottom.mas_equalTo(view);
            make.width.mas_equalTo(ANDY_Adapta(657));
            make.height.mas_equalTo(1);
        }];
    }
    return view;
}

#pragma mark 数据
- (void)loadData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiBonusProgress] subscribeNext:^(BonusProgressModel *model) {
        self.feedProgress.progress = model.totalProcess / 100.0;
        self.feedLabel.text = [NSString stringWithFormat:@"已经解锁%ld%@，解锁之后必得分红玉玺",model.totalProcess,@"%"];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
