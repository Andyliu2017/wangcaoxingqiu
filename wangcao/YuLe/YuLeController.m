//
//  YuLeController.m
//  wangcao
//
//  Created by EDZ on 2020/6/16.
//  Copyright © 2020 andy. All rights reserved.
//

#import "YuLeController.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>

@interface YuLeController ()

@property (nonatomic,strong) UIScrollView *yuleScroll;
@property (nonatomic,strong) UIView *announceView;
@property (nonatomic,weak) JhtVerticalMarquee *marqueeView;
@property (nonatomic,strong) NSMutableArray *yuleDataArr;

@end

@implementation YuLeController

- (NSMutableArray *)yuleDataArr{
    if (!_yuleDataArr) {
        _yuleDataArr = [NSMutableArray array];
    }
    return _yuleDataArr;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.yuleScroll.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1895));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(244, 244, 244, 1);
    UIScrollView *yulescrollview = [[UIScrollView alloc] init];
//    yulescrollview.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    yulescrollview.showsVerticalScrollIndicator = NO;
    yulescrollview.bounces = NO;
    [self.view addSubview:yulescrollview];
    [yulescrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    self.yuleScroll = yulescrollview;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"dgk_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(31));
        make.top.mas_equalTo(ANDY_Adapta(73));
    }];
    
    [self createUI];
    [self getNewsData];
    [self getYuleListData];
}
#pragma mark 数据
- (void)getNewsData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiYuLeScrollNews] subscribeNext:^(NSArray *arr) {
        if (arr.count > 0) {
            self.marqueeView.sourceArray = arr;
            [self.marqueeView marqueeOfSettingWithState:MarqueeStart_V];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)getYuleListData{
//  'XIQU', 'DOWNLOAD', 'TARGET_URL', 'VIDEO', 'XIANYU', 'DUOYOU', 'HK_VIDEO', 'ZRB', 'ANSWER', 'TUIYA', 'ABX', 'XIANWAN', 'YWHZ', 'SHARE'
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiYuleListWithLimit:10] subscribeNext:^(NSArray *arr) {
        NSLog(@"娱乐列表:%@",arr);
        for (int i = 0; i < arr.count; i++) {
            YuleModel *model = [YuleModel mj_objectWithKeyValues:arr[i]];
            [self.yuleDataArr addObject:model];
        }
        if (arr.count > 0) {
            [self createYuleUI];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 界面
- (void)createUI{
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, SCREENWIDTH, ANDY_Adapta(417));
    [self.yuleScroll addSubview:topView];
    UIImageView *topImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yule_topimg"]];
    topImg.frame = CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height);
    [topView addSubview:topImg];
    
    UIView *announceView1 = [GGUI ui_view:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREENWIDTH, ANDY_Adapta(93)) backgroundColor:RGBA(255, 248, 237, 1) alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.yuleScroll addSubview:announceView1];
    self.announceView = announceView1;
    UIImageView *headlineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yule_headLine"]];
    [self.announceView addSubview:headlineImg];
    [headlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.announceView);
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.width.mas_equalTo(ANDY_Adapta(64));
        make.height.mas_equalTo(ANDY_Adapta(56));
    }];
    
    JhtVerticalMarquee *marqueeView1 = [[JhtVerticalMarquee alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headlineImg.frame)+ANDY_Adapta(50), 0, ANDY_Adapta(600), ANDY_Adapta(93))];
    marqueeView1.textColor = RGBA(153, 58, 20, 1);
    marqueeView1.textFont = Font_(12);
    [self.announceView addSubview:marqueeView1];
    self.marqueeView = marqueeView1;
}
- (void)createYuleUI{
    self.yuleScroll.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(330)*self.yuleDataArr.count+ANDY_Adapta(580));
    for (int i = 0; i < self.yuleDataArr.count; i++) {
        YuleModel *model = self.yuleDataArr[i];
        UIImageView *yuleImg = [[UIImageView alloc] init];
        yuleImg.frame = CGRectMake(0, CGRectGetMaxY(self.announceView.frame)+ANDY_Adapta(330)*i, SCREENWIDTH, ANDY_Adapta(320));
        yuleImg.userInteractionEnabled = YES;
        [self.yuleScroll addSubview:yuleImg];
        [yuleImg setImageURL:[NSURL URLWithString:model.coverImg]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(yuleAction:) forControlEvents:UIControlEventTouchUpInside];
        [yuleImg addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.and.bottom.mas_equalTo(yuleImg);
        }];
    }
}

- (void)yuleAction:(UIButton *)btn{
    YuleModel *model = self.yuleDataArr[btn.tag-10];
    if ([model.taskCode isEqualToString:TASKDUOYOU]) {
        [[YLManager sharedManager] goToYuleControllerWithTaskCode:model.taskCode viewController:self userId:[PBCache shared].memberModel.userId advertType:0];
    }
    if ([model.taskCode isEqualToString:TASKIBX]) {
        [[YLManager sharedManager] showIBXgame:self];
    }
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
