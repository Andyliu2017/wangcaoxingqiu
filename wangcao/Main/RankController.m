//
//  RankController.m
//  wangcao
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 andy. All rights reserved.
//

#import "RankController.h"
#import <VTMagic.h>
#import "RankCell.h"
#import "SharePopView.h"

#define BlueBgCorol RGBA(82, 50, 130, 1)

@interface RankController ()<VTMagicViewDataSource,VTMagicViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic,strong) UIView *rankView;

@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) NSMutableArray *menuItemArr;

@property (nonatomic,strong) UITableView *rankTable;
@property (nonatomic,strong) NSMutableArray *rankDataArr;
@property (nonatomic,copy) NSString *rankType;
 
@end

@implementation RankController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"luck_bg"]];
    [self.view addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    
    [self createUI];
    self.rankType = GOLDRANK;
    [self getDataWithType:GOLDRANK];
}
- (void)getDataWithType:(NSString *)type{
    [self.rankDataArr removeAllObjects];
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiFetchRank:type] subscribeNext:^(NSArray *dataArr) {
        NSLog(@"dataArr:%@",dataArr);
        for (int i = 0; i < dataArr.count; i++) {
            RankModel *model = [RankModel mj_objectWithKeyValues:dataArr[i]];
            [self.rankDataArr addObject:model];
        }
        [self.rankTable reloadData];
        if ([self.rankTable.mj_header isRefreshing]) {
            [self.rankTable.mj_header endRefreshing];
        }
    } error:^(NSError * _Nullable error) {
        if ([self.rankTable.mj_header isRefreshing]) {
            [self.rankTable.mj_header endRefreshing];
        }
    }];
}
- (void)createUI{
    UIImageView *headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rank_head"]];
    [self.view addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(300));
    }];
    
    UIButton *backBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(0) normalColor:[UIColor clearColor] normalText:@"" click:^(id  _Nonnull x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [backBtn setImage:[UIImage imageNamed:@"luck_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(23));
        make.top.mas_equalTo(spaceHeight(88));
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    
    UIButton *inviteBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(16) normalColor:[UIColor whiteColor] normalText:@"邀请好友" click:^(id  _Nonnull x) {
        [self inviatAction];
    }];
    [inviteBtn setBackgroundImage:[UIImage imageNamed:@"rank_invite"] forState:UIControlStateNormal];
    [self.view addSubview:inviteBtn];
    [inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(642));
        make.height.mas_equalTo(ANDY_Adapta(110));
        make.bottom.mas_equalTo(self.view).inset(spaceHeight(84));
    }];
//    if (![WXApi isWXAppInstalled]) {
//        inviteBtn.hidden = YES;
//    }
    
    UIImageView *blueBgImg = [[UIImageView alloc] init];
    blueBgImg.backgroundColor = BlueBgCorol;
    blueBgImg.layer.cornerRadius = ANDY_Adapta(20);
    blueBgImg.layer.masksToBounds = YES;
    [self.view addSubview:blueBgImg];
    [blueBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImg.mas_bottom).offset(ANDY_Adapta(13));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(650));
        make.bottom.mas_equalTo(inviteBtn.mas_top).inset(spaceHeight(41));
    }];
    
    self.rankView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.rankView.clipsToBounds = YES;
    [self.view addSubview:self.rankView];
    [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImg.mas_bottom);
        make.left.and.width.mas_equalTo(blueBgImg);
        make.bottom.mas_equalTo(blueBgImg.mas_bottom).inset(ANDY_Adapta(13));
    }];
    
    [self setupView];
}
- (void)setupView
{
    self.magicController = [[VTMagicController alloc] init];
    self.magicController.magicView.layer.cornerRadius = ANDY_Adapta(20);
    self.magicController.magicView.layer.masksToBounds = YES;
    self.magicController.magicView.itemScale = 1;
    self.magicController.magicView.navigationHeight = ANDY_Adapta(94);
    self.magicController.magicView.sliderHidden = YES;
    self.magicController.magicView.separatorHidden = NO;
    self.magicController.magicView.navigationColor = RankColor;
    self.magicController.magicView.layoutStyle = VTLayoutStyleDivide;
    self.magicController.magicView.dataSource = self;
    self.magicController.magicView.delegate = self;
    [self addChildViewController:self.magicController];
    [self.rankView addSubview:self.magicController.view];
    [self.magicController didMoveToParentViewController:self];
    [self.magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.equalTo(self.rankView);
    }];
    [self.magicController.magicView reloadData];
    [self.magicController.magicView switchToPage:self.pageIndex animated:NO];
    
    [self.rankView addSubview:self.rankTable];
    [self.rankTable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.magicController.magicView.mas_bottom);
        make.top.mas_equalTo(self.rankView).offset(ANDY_Adapta(94));
        make.left.and.right.and.bottom.mas_equalTo(self.rankView);
    }];
}
- (UITableView *)rankTable{
    if (!_rankTable) {
        _rankTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _rankTable.bounces = NO;
        _rankTable.showsVerticalScrollIndicator = NO;
        _rankTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rankTable.backgroundColor = [UIColor clearColor];
        _rankTable.delegate = self;
        _rankTable.dataSource = self;
        _rankTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    }
    return _rankTable;
}
- (void)headerRefresh{
    [self getDataWithType:self.rankType];
}
- (NSMutableArray *)menuItemArr{
    if (!_menuItemArr) {
        _menuItemArr = [NSMutableArray array];
    }
    return _menuItemArr;
}
- (NSMutableArray *)rankDataArr{
    if (!_rankDataArr) {
        _rankDataArr = [NSMutableArray array];
    }
    return _rankDataArr;
}
//邀请好友
- (void)inviatAction{
    SharePopView *shareView = [SharePopView new];
    [shareView setDataWithImg:[UIImage imageNamed:@"share_invate_bg"] type:1 teamNum:[PBCache shared].userModel.invitecode nickName:[PBCache shared].userModel.nickName qrcode:[PBCache shared].userModel.qrcode];
    [shareView showView];
}
#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return @[@"金币榜",@"典故卡",@"收益榜"];
}
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (menuItem == nil) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [menuItem setTitleColor:RankColor forState:UIControlStateSelected];
        menuItem.titleLabel.font = Font_(16);
        if (itemIndex == 0) {
            [menuItem setBackgroundColor:[UIColor whiteColor]];
        }else{
            [menuItem setBackgroundColor:RankColor];
        }
        [self.menuItemArr addObject:menuItem];
    }
    return menuItem;
}
- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex{
    for (int i = 0; i < self.menuItemArr.count; i++) {
        UIButton *menuItem = self.menuItemArr[i];
        if (itemIndex == i) {
            [menuItem setBackgroundColor:[UIColor whiteColor]];
        }else{
            [menuItem setBackgroundColor:RankColor];
        }
    }
    switch (itemIndex) {
        case 0:
            self.rankType = GOLDRANK;
            [self getDataWithType:GOLDRANK];
            break;
        case 1:
            self.rankType = DIANGUKARANK;
            [self getDataWithType:DIANGUKARANK];
            break;
        case 2:
            self.rankType = PROFITRANK;
            [self getDataWithType:PROFITRANK];
            break;
        default:
            break;
    }
}
#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rankDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(118);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"RankCell";
    RankCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[RankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.rankDataArr.count>0) {
        [cell setData:self.rankDataArr[indexPath.row] index:indexPath.row+1 type:self.rankType];
    }
    return cell;
}

@end
