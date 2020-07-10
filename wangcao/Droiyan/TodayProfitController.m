//
//  TodayProfitController.m
//  wangcao
//
//  Created by EDZ on 2020/5/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TodayProfitController.h"
#import "ProfitDetailModel.h"
#import "TodayPofitCell.h"
#import "ReferView.h"
#import "QQWechatView.h"

@interface TodayProfitController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *profitTable;
@property (nonatomic,strong) NSMutableArray *profitDataArr;
@property (nonatomic,assign) NSInteger pageNum;

@end

@implementation TodayProfitController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"战友今日贡献";
    [self.view addSubview:self.profitTable];
    [self.profitTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-ANDY_Adapta(400));
    }];
    self.pageNum = 1;
    [self getData];
}
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiTeamTodayProfitDetail:1 page:self.pageNum limit:10] subscribeNext:^(WCBaseModel *model) {
        for (int i = 0; i < model.content.count; i++) {
            ProfitDetailModel *detailModel = [ProfitDetailModel mj_objectWithKeyValues:model.content[i]];
            [self.profitDataArr addObject:detailModel];
        }
        [self.profitTable reloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (NSMutableArray *)profitDataArr{
    if (!_profitDataArr) {
        _profitDataArr = [NSMutableArray array];
    }
    return _profitDataArr;
}
- (UITableView *)profitTable{
    if (!_profitTable) {
        _profitTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _profitTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _profitTable.showsVerticalScrollIndicator = NO;
        _profitTable.bounces = NO;
        _profitTable.delegate = self;
        _profitTable.dataSource = self;
        _profitTable.emptyDataSetSource = self;
        _profitTable.emptyDataSetDelegate = self;
        _profitTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        _profitTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _profitTable;
}
#pragma mark Action
- (void)headerRefresh{
    
}
- (void)footerRefresh{
    
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.profitDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(150);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"TodayPofitCell";
    TodayPofitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[TodayPofitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.profitDataArr.count > indexPath.row) {
        [cell setData:self.profitDataArr[indexPath.row]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([PBCache shared].userModel.weixin || [PBCache shared].userModel.qq) {
        ProfitDetailModel *detailModel = self.profitDataArr[indexPath.row];
        ReferView *referview = [[ReferView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [referview setFriendView];
        [referview setFriendData:detailModel.userInfo];
        [referview showPopView:self];
    }else{
        QQWechatView *qqwechatView = [[QQWechatView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [qqwechatView showPopView:self];
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

@end
