//
//  WithDrawController.m
//  wangcao
//
//  Created by EDZ on 2020/6/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WithDrawController.h"
#import "WithdrawCell.h"

@interface WithDrawController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation WithDrawController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"查看更多数据..." forState:MJRefreshStateIdle];
        [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提现明细";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    
    self.page = 1;
    [self getData];
}
//下拉刷新
- (void)headerRefresh{
    self.page = 1;
    [self.dataArr removeAllObjects];
    [self getData];
}
//上拉刷新
- (void)footerRefresh{
    self.page++;
    [self getData];
}
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiGetWithdrawDetail:self.page limit:10] subscribeNext:^(WCBaseModel *model) {
        for (int i = 0; i < model.content.count; i++) {
            WithdrawModel *recModel = [WithdrawModel mj_objectWithKeyValues:model.content[i]];
            [self.dataArr addObject:recModel];
        }
        [self.tableView reloadData];
        if (model.hasNext) {
            self.tableView.mj_footer.state = MJRefreshStateIdle;
        }else{
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    } error:^(NSError * _Nullable error) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    if (self.dataArr.count) {
        self.tableView.mj_footer.hidden = NO;
    }else{
        self.tableView.mj_footer.hidden = YES;
    }
}
#pragma mark - TableViewDelagete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(144);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"WithdrawCell";
    WithdrawCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[WithdrawCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.dataArr.count > indexPath.row) {
        [cell setData:self.dataArr[indexPath.row]];
    }
    return cell;
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
