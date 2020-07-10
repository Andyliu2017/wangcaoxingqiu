//
//  FotonRecordController.m
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import "FotonRecordController.h"
#import "FotonCell.h"
#import "FotonModel.h"

@interface FotonRecordController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *fotonTable;
@property (nonatomic,strong) NSMutableArray *fotonArr;
@property (nonatomic,assign) NSInteger page;

@end

@implementation FotonRecordController

- (NSMutableArray *)fotonArr{
    if (!_fotonArr) {
        _fotonArr = [NSMutableArray array];
    }
    return _fotonArr;
}
- (UITableView *)fotonTable{
    if (!_fotonTable) {
        _fotonTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _fotonTable.bounces = NO;
        _fotonTable.showsVerticalScrollIndicator = NO;
        _fotonTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _fotonTable.backgroundColor = [UIColor clearColor];
        _fotonTable.delegate = self;
        _fotonTable.dataSource = self;
    }
    return _fotonTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"福豆明细";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.fotonTable];
    [self.fotonTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.view);
    }];
    self.page = 1;
    [self loadData];
}
#pragma mark 数据
- (void)loadData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiFotonRecordWithPage:self.page limit:10] subscribeNext:^(WCBaseModel *model) {
        for (int i = 0; i < model.content.count; i++) {
            FotonModel *fModel = [FotonModel mj_objectWithKeyValues:model.content[i]];
            [self.fotonArr addObject:fModel];
        }
        [self.fotonTable reloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fotonArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(144);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"FotonCell";
    FotonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[FotonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.fotonArr.count > indexPath.row) {
        [cell setData:self.fotonArr[indexPath.row]];
    }
    return cell;
}

@end
