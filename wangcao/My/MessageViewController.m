//
//  MessageViewController.m
//  wangcao
//
//  Created by EDZ on 2020/5/8.
//  Copyright © 2020 andy. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *messageTableView;
@property (nonatomic,strong) NSMutableArray *messageArr;
@property (nonatomic,assign) NSInteger pageNum;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"消息中心";
    
    [self.view addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.view);
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageNum = 1;
    [self loadData];
}
- (void)loadData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiMessage:self.pageNum limit:10] subscribeNext:^(WCBaseModel *model) {
        for (int i = 0; i < model.content.count; i++) {
            MessageModel *messModel = [MessageModel mj_objectWithKeyValues:model.content[i]];
            [self.messageArr addObject:messModel];
        }
        [self.messageTableView reloadData];
        if ([self.messageTableView.mj_header isRefreshing]) {
            [self.messageTableView.mj_header endRefreshing];
        }
        if ([self.messageTableView.mj_footer isRefreshing]) {
            [self.messageTableView.mj_footer endRefreshing];
        }
        if (model.hasNext) {
            self.messageTableView.mj_footer.hidden = NO;
        }else{
            self.messageTableView.mj_footer.hidden = YES;
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (NSMutableArray *)messageArr{
    if (!_messageArr) {
        _messageArr = [NSMutableArray array];
    }
    return _messageArr;
}
- (UITableView *)messageTableView{
    if (!_messageTableView) {
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.rowHeight = UITableViewAutomaticDimension;
        _messageTableView.estimatedRowHeight = ANDY_Adapta(190);
        _messageTableView.allowsSelection = NO;
        _messageTableView.backgroundColor = [UIColor clearColor];
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.showsVerticalScrollIndicator = NO;
        _messageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        _messageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _messageTableView;
}
#pragma mark 下拉
- (void)headerRefresh{
    self.pageNum = 1;
    [self.messageArr removeAllObjects];
    [self loadData];
}
#pragma mark 上拉
- (void)footerRefresh{
    self.pageNum++;
    [self loadData];
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArr.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return ANDY_Adapta(190);
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.messageArr.count > indexPath.row) {
        [cell setMessageData:self.messageArr[indexPath.row]];
    }
    return cell;
}

@end
