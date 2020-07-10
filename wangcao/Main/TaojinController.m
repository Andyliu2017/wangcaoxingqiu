//
//  TaojinController.m
//  wangcao
//
//  Created by EDZ on 2020/5/13.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TaojinController.h"
#import "StealListModel.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>
#import "PaopaoView.h"
#import "StealView.h"
#import "TaoJinCell.h"
#import "StealDynamicView.h"
#import "StealGoldView.h"

@interface TaojinController ()<PaopaoViewDelegate,UITableViewDelegate,UITableViewDataSource>
//可偷用户列表
@property (nonatomic,strong) NSMutableArray *stealListArr;
//可偷取用户view列表
@property (nonatomic,strong) NSMutableArray *stealviewArr;
//用户收取金币列表
@property (nonatomic,strong) NSMutableArray *redPackageArr;

@property (nonatomic,strong) UIImageView *topImage;
@property (nonatomic,weak) JhtVerticalMarquee *marqueeView;
@property (nonatomic,strong) UIScrollView *topScroll;
@property (nonatomic,strong) PaopaoView *paopaoView;

@property (nonatomic,strong) UIView *bottomView;
//当前选中可偷取用户
@property (nonatomic,strong) StealView *userview;
//自己被偷取
@property (nonatomic,strong) NSMutableArray *userMuArr;
@property (nonatomic,strong) StealDynamicView *stealInfoView;  //自己被偷去信息view
//别人被偷取
@property (nonatomic,strong) NSMutableArray *otherMuArr;
@property (nonatomic,assign) NSInteger currentUserid;   //当前用户id
@property (nonatomic,strong) UITableView *otherTable;   //别人被偷去记录显示
@property (nonatomic,strong) StealListModel *sModel;  //当前选中用户
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) BOOL hasNext;  //是否有下页

@end

@implementation TaojinController

- (NSMutableArray *)stealListArr{
    if (!_stealListArr) {
        _stealListArr = [NSMutableArray array];
    }
    return _stealListArr;
}
- (NSMutableArray *)stealviewArr{
    if (!_stealviewArr) {
        _stealviewArr = [NSMutableArray array];
    }
    return _stealviewArr;
}
- (NSMutableArray *)redPackageArr{
    if (!_redPackageArr) {
        _redPackageArr = [NSMutableArray array];
    }
    return _redPackageArr;
}
- (NSMutableArray *)userMuArr{
    if (!_userMuArr) {
        _userMuArr = [NSMutableArray array];
    }
    return _userMuArr;
}
- (NSMutableArray *)otherMuArr{
    if (!_otherMuArr) {
        _otherMuArr = [NSMutableArray array];
    }
    return _otherMuArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self getData];
}
#pragma mark UI
- (void)createUI{
    self.topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taojin_bg"]];
    self.topImage.userInteractionEnabled = YES;
    [self.view addSubview:self.topImage];
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(836));
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"luck_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topImage addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(20));
        make.top.mas_equalTo(ANDY_Adapta(120));
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    
    UIView *topview = [GGUI ui_view:CGRectZero backgroundColor:RGBA(221, 172, 127, 1) alpha:1 cornerRadius:ANDY_Adapta(33) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.topImage addSubview:topview];
    [topview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topImage);
        make.top.mas_equalTo(ANDY_Adapta(99));
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(66));
    }];
    
    JhtVerticalMarquee *marqueeView1 = [[JhtVerticalMarquee alloc] initWithFrame:CGRectMake(ANDY_Adapta(160), ANDY_Adapta(99), ANDY_Adapta(600), ANDY_Adapta(66))];
    marqueeView1.textColor = RGBA(153, 58, 20, 1);
    [self.topImage addSubview:marqueeView1];
    self.marqueeView = marqueeView1;
    UIButton *marqueeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [marqueeBtn addTarget:self action:@selector(marqueeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.marqueeView addSubview:marqueeBtn];
    [marqueeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.left.and.right.mas_equalTo(self.marqueeView);
    }];
    
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.3;
    [self.topImage addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.topImage);
        make.height.mas_equalTo(ANDY_Adapta(147));
    }];
    self.topScroll = [[UIScrollView alloc] init];
    self.topScroll.showsHorizontalScrollIndicator = NO;
    self.topScroll.bounces = NO;
    [self.topImage addSubview:self.topScroll];
    [self.topScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.topImage);
        make.height.mas_equalTo(ANDY_Adapta(147));
    }];
    
    self.paopaoView = [[PaopaoView alloc] init];
    [self.topImage addSubview:self.paopaoView];
    self.paopaoView.delegate = self;
    [self.paopaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(topview.mas_bottom);
        make.bottom.mas_equalTo(blackView.mas_top);
    }];
    
    self.bottomView = [GGUI ui_view:self.view.bounds backgroundColor:RGBA(255, 237, 205, 1) alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImage.mas_bottom);
        make.left.and.right.and.bottom.mas_equalTo(self.view);
    }];
    [self createBottomUI];
}
//当前用户被偷去信息view
- (void)createBottomUI{
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taojin_dynamic"]];
    [self.bottomView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(spaceHeight(31));
        make.width.and.height.mas_equalTo(ANDY_Adapta(30));
    }];
    UILabel *titleLabel = [GGUI ui_label:self.view.bounds lines:1 align:NSTextAlignmentLeft font:FontBold_(17) textColor:RGBA(153, 58, 20, 1) text:@"最新动态" Radius:0];
    [self.bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImg.mas_right).offset(ANDY_Adapta(13));
        make.centerY.mas_equalTo(iconImg);
        make.height.mas_equalTo(ANDY_Adapta(40));
        make.right.mas_equalTo(self.bottomView);
    }];
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.bottomView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomView);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(ANDY_Adapta(10));
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.bottom.mas_equalTo(self.bottomView).offset(-ANDY_Adapta(47));
    }];
    
    [whiteView addSubview:self.otherTable];
    [self.otherTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(whiteView);
    }];
}
- (void)setScrollViewUI:(int)index{
    self.topScroll.contentSize = CGSizeMake(ANDY_Adapta(130)*self.stealListArr.count, ANDY_Adapta(147));
    for (int i = 0; i < self.stealListArr.count; i++) {
        StealListModel *model = self.stealListArr[i];
        StealView *stealview = [self stealView:model.avatar isSteal:model.steal index:index withi:i];
        stealview.frame = CGRectMake(ANDY_Adapta(130)*i, 0, ANDY_Adapta(130), ANDY_Adapta(147));
        [self.topScroll addSubview:stealview];
        [self.stealviewArr addObject:stealview];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(changeUserAction:) forControlEvents:UIControlEventTouchUpInside];
        [stealview addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.and.left.and.right.mas_equalTo(stealview);
        }];
    }
}
- (StealView *)stealView:(NSString *)head isSteal:(BOOL)isSteal index:(int)index withi:(int)i{
    StealView *view = [[StealView alloc] init];
    view.borderImg = [[UIImageView alloc] init];
    view.borderImg.layer.borderWidth = 1;
    view.borderImg.layer.borderColor = RGBA(233, 170, 53, 1).CGColor;
    view.borderImg.layer.cornerRadius = ANDY_Adapta(50);
    view.borderImg.layer.masksToBounds = YES;
    view.borderImg.hidden = YES;
    [view addSubview:view.borderImg];
    [view.borderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(view);
        make.width.and.height.mas_equalTo(ANDY_Adapta(100));
    }];
    UIImageView *headimg = [[UIImageView alloc] init];
    [headimg setImageURL:[NSURL URLWithString:head]];
    headimg.layer.cornerRadius = ANDY_Adapta(49.5);
    headimg.layer.masksToBounds = YES;
    [view addSubview:headimg];
    [headimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(view);
        make.width.and.height.mas_equalTo(ANDY_Adapta(99));
    }];
    view.currentLabel = [GGUI ui_label:self.view.bounds lines:1 align:NSTextAlignmentCenter font:FontBold_(10) textColor:[UIColor whiteColor] text:@"当前" Radius:ANDY_Adapta(7)];
    view.currentLabel.backgroundColor = RGBA(233, 170, 53, 1);
    view.currentLabel.hidden = YES;
    [view addSubview:view.currentLabel];
    [view.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.centerX.mas_equalTo(headimg);
        make.width.mas_equalTo(ANDY_Adapta(62));
        make.height.mas_equalTo(ANDY_Adapta(32));
    }];
    
    view.handImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taojin_hand"]];
    view.handImg.hidden = !isSteal;
    [view addSubview:view.handImg];
    [view.handImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view.mas_right);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.width.and.height.mas_equalTo(ANDY_Adapta(72));
    }];
    if (index == i) {
        view.isCurrent = YES;
        self.userview = view;
    }else{
        view.isSteal = isSteal;
        view.isCurrent = NO;
    }
    return view;
}

- (UITableView *)otherTable{
    if (!_otherTable) {
        _otherTable = [[UITableView alloc] init];
        _otherTable.bounces = NO;
        _otherTable.showsVerticalScrollIndicator = NO;
        _otherTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _otherTable.delegate = self;
        _otherTable.dataSource = self;
        _otherTable.layer.cornerRadius = ANDY_Adapta(20);
        _otherTable.layer.masksToBounds = YES;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"查看更多数据..." forState:MJRefreshStateIdle];
        [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
        _otherTable.mj_footer = footer;
        
//        _otherTable.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    }
    return _otherTable;
}
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    //获取可偷取用户数据
    [[manager ApiTakeRedList] subscribeNext:^(NSArray *array) {
        StealListModel *stealModel;
        for (int i = 0; i < array.count; i++) {
            StealListModel *model = [StealListModel mj_objectWithKeyValues:array[i]];
            [self.stealListArr addObject:model];
            if (i == 0) {
                stealModel = model;
                self.sModel = model;
            }
        }
        [self setScrollViewUI:0];
        [self getPaopaoViewData:stealModel];
        //获取当前用户被偷去数据
        [self otherBeStealData:stealModel.userId];
    } error:^(NSError * _Nullable error) {
        
    }];
    //获取哪些用户偷了自己的金币数据  顶部上下滚动数据显示
    [[manager ApiStealRedLogs:[PBCache shared].memberModel.userId page:1 limit:20] subscribeNext:^(WCBaseModel *baseModel) {
        NSArray *contentarr = baseModel.content;
        NSMutableArray *strArr = [NSMutableArray array];
        for (int i = 0; i < contentarr.count; i++) {
            RecviedRedModel *redmodel = [RecviedRedModel mj_objectWithKeyValues:contentarr[i]];
            [self.userMuArr addObject:redmodel];
            NSString *str = [NSString stringWithFormat:@"%@偷了我%ldg金子",redmodel.nickName,redmodel.amount];
            [strArr addObject:str];
        }
        if (strArr.count > 0) {
            self.marqueeView.sourceArray = strArr;
            // 开始滚动
            [self.marqueeView marqueeOfSettingWithState:MarqueeStart_V];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
//获取当前选中用户被偷取数据
- (void)otherBeStealData:(NSInteger)userid{
    self.pageNum = 1;
    [self.otherMuArr removeAllObjects];
    [self otherDataAction:userid];
}
- (void)otherDataAction:(NSInteger)userid{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiStealRedLogs:userid page:self.pageNum limit:10] subscribeNext:^(WCBaseModel *baseModel) {
        NSArray *contentarr = baseModel.content;
        for (int i = 0; i < contentarr.count; i++) {
            RecviedRedModel *redmodel = [RecviedRedModel mj_objectWithKeyValues:contentarr[i]];
            [self.otherMuArr addObject:redmodel];
        }
        [self.otherTable.mj_footer endRefreshing];
        self.hasNext = baseModel.hasNext;
        if (baseModel.hasNext) {
            self.otherTable.mj_footer.state = MJRefreshStateIdle;
        }else{
            self.otherTable.mj_footer.state = MJRefreshStateNoMoreData;
            [self.otherTable.mj_footer noticeNoMoreData];
        }
        [self.otherTable reloadData];
    } error:^(NSError * _Nullable error) {
        if (self.pageNum > 1) {
            self.pageNum--;
        }
        self.pageNum--;
    }];
}
//淘金页面 泡泡数据
- (void)getPaopaoViewData:(StealListModel *)stealModel{
    for (UIView *subview in self.paopaoView.subviews) {
        [subview removeFromSuperview];
    }
    self.currentUserid = stealModel.userId;
    [self loadData:self.currentUserid];
}
- (void)loadData:(NSInteger)userid{
    [self.redPackageArr removeAllObjects];
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserStealGoldInfo:userid] subscribeNext:^(NSArray *stealarr) {
        BOOL isSteal = NO;
        for (int i = 0; i < stealarr.count; i++) {
            RedPackageModel *redModel = [RedPackageModel mj_objectWithKeyValues:stealarr[i]];
            [self.redPackageArr addObject:redModel];
            if (redModel.stealFlag) {
                isSteal = YES;
            }
        }
        for (int i = 0; i < self.stealListArr.count; i++) {
            StealListModel *model = self.stealListArr[i];
            //刷新用户是否可偷取状态
            if (model.userId == self.currentUserid) {
                model.steal = isSteal;
            }
        }
//        self.userview.isSteal = isSteal;
//        self.userview.handImg.hidden = YES;
        self.paopaoView.stealGoldArr = self.redPackageArr;
    } error:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark Action
- (StealDynamicView *)stealInfoView{
    if (!_stealInfoView) {
        _stealInfoView = [[StealDynamicView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _stealInfoView;;
}
//垂直跑马灯点击
- (void)marqueeAction{
    [self.view addSubview:self.stealInfoView];
    [self.stealInfoView setData:self.userMuArr];
    [self.stealInfoView showAnimation];
}
//返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//切换用户
- (void)changeUserAction:(UIButton *)btn{
    [self getPaopaoViewData:self.stealListArr[btn.tag-10]];
    StealListModel *model = self.stealListArr[btn.tag-10];
    self.sModel = model;
    [self otherBeStealData:model.userId];
    for (int i = 0; i < self.stealviewArr.count; i++) {
        StealListModel *model1 = self.stealListArr[i];
        StealView *view = self.stealviewArr[i];
        if (i == btn.tag-10) {
            view.isCurrent = YES;
            self.userview = view;
        }else{
            view.isSteal = model1.steal;
            view.isCurrent = NO;
        }
    }
}

#pragma mark PaopaoViewDelegate
- (void)selectTimeLimitedBtnAtIndex:(NSInteger)index withButton:(nonnull PaopaoButton *)btn
{
    if (btn.stealFlag) {        
        NSLog(@"红包id:%ld",btn.redId);
        WCApiManager *manager = [WCApiManager sharedManager];
        [[manager ApiStealGold:btn.redId] subscribeNext:^(RedPackageModel *redModel) {
            [PBCache shared].goldModel.goldCoins = [PBCache shared].goldModel.goldCoins + (int)redModel.stealMoney;
            [self.paopaoView removeRandomIndex:index];
            StealGoldView *goldView = [[StealGoldView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [goldView setData:(integer_t)redModel.stealMoney];
            [goldView showPopView:self];
        } error:^(NSError * _Nullable error) {
            
        }];
    }else{
        [MBProgressHUD showText:@"别着急还没到偷取时间" toView:self.view afterDelay:1.0];
    }
}

- (void)selectUnlimitedBtnAtIndex:(NSInteger)index
{
    [self.paopaoView removeRandomIndex:index];
}

- (void)allCollected
{
    NSLog(@"全都点完了");
    //全都点完了 不可偷取
//    self.userview.isSteal = NO;
    for (UIView *subview in self.paopaoView.subviews) {
        [subview removeFromSuperview];
    }
    [self loadData:self.currentUserid];
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.otherMuArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(154);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"TaoJinCell";
    TaoJinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[TaoJinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.otherMuArr.count) {
        [cell setData:self.otherMuArr[indexPath.row]];
    }
    return cell;;
}

#pragma mark 下拉、上拉刷新
//下拉

//上拉
- (void)footerRefresh{
    NSLog(@"上拉刷新");
    if (self.hasNext) {
        self.pageNum++;
        [self otherDataAction:self.sModel.userId];
    }
}

@end
