//
//  TaskViewController.m
//  wangcao
//
//  Created by EDZ on 2020/5/16.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TaskViewController.h"
#import <VTMagic.h>
#import "TaskCell.h"
#import "PKViewController.h"
#import "SharePopView.h"

#define TaskBgColor RGBA(247, 247, 247, 1)

@interface TaskViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *taskDataArr;
@property (nonatomic,strong) UITableView *taskTable;


@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"赚钱大厅";
    self.view.backgroundColor = TaskBgColor;
    [self getData];
    [self.view addSubview:self.taskTable];
    [self.taskTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
}
- (NSMutableArray *)taskDataArr{
    if (!_taskDataArr) {
        _taskDataArr = [NSMutableArray array];
    }
    return _taskDataArr;
}
- (UITableView *)taskTable{
    if (!_taskTable) {
        _taskTable = [[UITableView alloc] init];
        _taskTable.bounces = NO;
        _taskTable.showsVerticalScrollIndicator = NO;
        _taskTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _taskTable.delegate = self;
        _taskTable.dataSource = self;
    }
    return _taskTable;
}
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiTaskList:0 type:@"LIST"] subscribeNext:^(NSArray *array) {
        for (int i = 0; i < array.count; i++) {
            TaskDetailModel *taskModel = [TaskDetailModel mj_objectWithKeyValues:array[i]];
            [self.taskDataArr addObject:taskModel];
        }
        [self.taskTable reloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(126);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"TaskCell";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.taskDataArr.count) {
        [cell setData:self.taskDataArr[indexPath.row]];
    }
    __block TaskViewController *weakSelf = self;
    cell.taskblock = ^(TaskDetailModel * _Nonnull model) {
        NSLog(@"model.taskCode:%@",model.taskCode);
        if ([model.taskCode isEqualToString:TASKVIDEO]) {   //视频广告
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }
        if ([model.taskCode isEqualToString:TASKANSWER]) {   //答题
            PKViewController *vc = [[PKViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        if ([model.taskCode isEqualToString:TASKSHARE]) {    //分享
//            if (![WXApi isWXAppInstalled]) {
//                return;
//            }
            SharePopView *shareView = [[SharePopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [shareView setDataWithImg:[UIImage imageNamed:@"share_invate_bg"] type:1 teamNum:[PBCache shared].userModel.invitecode nickName:[PBCache shared].userModel.nickName qrcode:[PBCache shared].userModel.qrcode];
            [shareView showView];
        }
        if ([model.taskCode isEqualToString:TASKTARGET_URL]) {   //跳转url
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
        }
        if ([model.taskCode isEqualToString:TASKDUOYOU]) {
            [[YLManager sharedManager] goToYuleControllerWithTaskCode:model.taskCode viewController:self userId:[PBCache shared].memberModel.userId advertType:0];
        }
        if ([model.taskCode isEqualToString:TASKTUIA]) {
            [[YLManager sharedManager] showInterstitialAd];
        }
        if ([model.taskCode isEqualToString:TASKIBX]) {
            [[YLManager sharedManager] showIBXgame:self];
        }
    };
    return cell;
}

@end
