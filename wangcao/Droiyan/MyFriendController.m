//
//  MyFriendController.m
//  wangcao
//
//  Created by EDZ on 2020/5/14.
//  Copyright © 2020 andy. All rights reserved.
//

#import "MyFriendController.h"
#import <VTMagic.h>
#import "FriendTableController.h"
#import "FriendCell.h"
#import <LJContactManager.h>
#import <LJPerson.h>
#import "ReferView.h"
#import "QQWechatView.h"

@interface MyFriendController ()<VTMagicViewDataSource,VTMagicViewDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) VTMagicController *magicController;

@property (nonatomic,strong) UITableView *friendTable;
@property (nonatomic,strong) NSMutableArray *tableDataArr;
@property (nonatomic,strong) NSMutableArray *phoneData;
@property (nonatomic ,assign) BOOL isUpdata;
//当前选中好友类型
@property (nonatomic,assign) NSInteger oldItemIndex;
@property (nonatomic,assign) NSInteger pageNum;  //当前页数

@property(nonatomic,strong) NSError *error;//必须要重新加载
@property(nonatomic,assign) BOOL isRequest;

@end

@implementation MyFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的好友";
    self.view.backgroundColor = RGBA(247, 247, 247, 1);
    [self setupView];
    self.oldItemIndex = 0;
    self.pageNum = 1;
    [self getDataSubType:1];
}
- (NSMutableArray *)tableDataArr{
    if (!_tableDataArr) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}
- (NSMutableArray *)phoneData{
    if (!_phoneData) {
        _phoneData = [NSMutableArray array];
    }
    return _phoneData;
}
- (UITableView *)friendTable{
    if (!_friendTable) {
        _friendTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _friendTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _friendTable.showsVerticalScrollIndicator = NO;
        _friendTable.bounces = NO;
        _friendTable.delegate = self;
        _friendTable.dataSource = self;
        _friendTable.emptyDataSetSource = self;
        _friendTable.emptyDataSetDelegate = self;
        _friendTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        _friendTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _friendTable;
}
- (void)getDataSubType:(NSInteger)subType{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserFriendList:subType page:self.pageNum size:10] subscribeNext:^(WCBaseModel *model) {
        for (int i = 0; i < model.content.count; i++) {
            TeamNumberModel *teamModel = [TeamNumberModel mj_objectWithKeyValues:model.content[i]];
            [self.tableDataArr addObject:teamModel];
        }
        [self.friendTable reloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)contactFriend{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserContactFriend:nil page:self.pageNum limit:10] subscribeNext:^(WCBaseModel *model) {
        for (int i = 0; i < model.content.count; i++) {
            TeamNumberModel *teamModel = [TeamNumberModel mj_objectWithKeyValues:model.content[i]];
            [self.tableDataArr addObject:teamModel];
        }
        [self.friendTable reloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)setupView
{
    self.magicController = [[VTMagicController alloc] init];
    self.magicController.magicView.itemScale = 1;
    self.magicController.magicView.navigationHeight = ANDY_Adapta(100);
    self.magicController.magicView.sliderWidth = ANDY_Adapta(121);
    self.magicController.magicView.sliderHeight = ANDY_Adapta(8);
    self.magicController.magicView.sliderHidden = NO;
    self.magicController.magicView.separatorHidden = NO;
    self.magicController.magicView.navigationColor = [UIColor whiteColor];
    self.magicController.magicView.sliderColor = NavigationBarColor;
    self.magicController.magicView.layoutStyle = VTLayoutStyleDivide;
    self.magicController.magicView.dataSource = self;
    self.magicController.magicView.delegate = self;
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.magicController didMoveToParentViewController:self];
    [self.magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(100));
    }];
    [self.magicController.magicView reloadData];
    [self.magicController.magicView switchToPage:0 animated:NO];
    
    [self.view addSubview:self.friendTable];
    [self.friendTable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.and.bottom.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.magicController.magicView.mas_bottom);
        
        make.top.mas_equalTo(self.view).offset(ANDY_Adapta(100));
        make.left.and.right.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-spaceHeight(400));
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}
#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
//    return @[@"直邀好友",@"扩散好友",@"通讯录好友"];
    return @[@"直邀好友",@"扩散好友"];
}
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"MyFriendItem";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (menuItem == nil) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:MessageColor forState:UIControlStateNormal];
        [menuItem setTitleColor:TitleColor forState:UIControlStateSelected];
        menuItem.titleLabel.font = Font_(16);
    }
    return menuItem;
}
- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex{
    if (self.oldItemIndex == itemIndex) {
        return;
    }
    self.oldItemIndex = itemIndex;
    self.pageNum = 1;
    [self.tableDataArr removeAllObjects];
    switch (itemIndex) {
        case 0:
            [self getDataSubType:1];
            break;
        case 1:
            [self getDataSubType:2];
            break;;
        case 2:    //通讯录好友
            self.isUpdata = YES;
            [self phoneFriendList];
            [self contactFriend];
            break;
        default:
            break;
    }
}
//- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
//    FriendTableController *controller = [magicView dequeueReusablePageWithIdentifier:@"FriendTableController"];
//    if (!controller) {
//        controller = [[FriendTableController alloc] init];
//    }
//    return controller;
//}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(138);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"FriendCell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.tableDataArr.count > indexPath.row) {
        [cell setData:self.tableDataArr[indexPath.row] withType:self.oldItemIndex];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.oldItemIndex != 2) {
        if ([PBCache shared].userModel.weixin || [PBCache shared].userModel.qq) {
            ReferView *referview = [[ReferView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [referview setFriendView];
            [referview setFriendData:self.tableDataArr[indexPath.row]];
            [referview showPopView:self];
        }else{
            QQWechatView *qqwechatView = [[QQWechatView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [qqwechatView showPopView:self];
        }
    }
}
#pragma mark - DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"data_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *title = @"暂无相关内容";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontBold_(14),
                                 NSForegroundColorAttributeName:GrayColor
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark 上拉刷新、下拉刷新
- (void)headerRefresh{
    self.pageNum = 1;
    [self.tableDataArr removeAllObjects];
    if (self.oldItemIndex == 2) { //通讯录
        [self contactFriend];
    }else{
        [self getDataSubType:self.oldItemIndex];
    }
}
- (void)footerRefresh{
    self.pageNum++;
    if (self.oldItemIndex == 2) { //通讯录
        [self contactFriend];
    }else{
        [self getDataSubType:self.oldItemIndex];
    }
}

#pragma mark 用户通讯录数据
- (void)phoneFriendList
{
    [[LJContactManager sharedInstance] accessSectionContactsComplection:^(BOOL succeed, NSArray<LJSectionPerson *> *contacts, NSArray<NSString *> *keys) {
        
        [self.phoneData removeAllObjects];
        for (NSInteger i = 0; i < contacts.count; i++)
        {
            LJSectionPerson *sectionModel = contacts[i];
            NSArray *rows = sectionModel.persons;
            for (NSInteger j = 0; j < rows.count; j++)
            {
                LJPerson *personModel = rows[j];
                LJPhone *firstPhone = [personModel.phones firstObject];
                NSLog(@"personModel:%@,,firstPhone:%@",personModel.fullName,firstPhone.phone);
                if (personModel.fullName.length > 0 && firstPhone.phone.length > 0)
                {
                    NSString *name = personModel.fullName;
                    NSString *phone = firstPhone.phone;
                    NSDictionary *dic = @{@"contactName":name,
                                          @"phone":phone};
                    [self.phoneData addObject:dic];
                    
                }
                
            }
        }
        NSLog(@"self.phoneData:%@",self.phoneData);
        if (self.phoneData.count > 0 && self.isUpdata == YES)
        {
            self.isUpdata = NO;
            [self updataPhone];
        }
        else
        {
            self.error = nil;
            self.isRequest = YES;
        }
    }];
}
- (void)updataPhone
{
    NSDictionary *jsonDic = [self.phoneData mj_JSONObject];
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserSyncContacts:jsonDic] subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    }];
}

@end
