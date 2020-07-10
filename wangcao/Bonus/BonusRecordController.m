//
//  BonusRecordController.m
//  wangcao
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 andy. All rights reserved.
//

#import "BonusRecordController.h"
#import "FSCalendar.h"
#import "AMPopTip.h"
#import "BonusRecordModel.h"
#import "BonusRecordCell.h"

@interface BonusRecordController ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) FSCalendar *fscalendar;
@property (nonatomic,strong) UITableView *bonusTable;
@property (nonatomic,strong) NSMutableArray *bonusTableData;
@property (nonatomic,strong) UIButton *dateBtn;
@property (nonatomic,strong) AMPopTip *amptp;

@property (nonatomic,copy) NSString *dateStr;
@property (nonatomic,assign) NSInteger pageNum;

@end

@implementation BonusRecordController

- (NSMutableArray *)bonusTableData{
    if (!_bonusTableData) {
        _bonusTableData = [NSMutableArray array];
    }
    return _bonusTableData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(247, 247, 247, 1);
    self.title = @"分红记录";
    self.pageNum = 1;
    self.dateStr = [Tools getProfitDateStringOfDate:[NSDate date]];
    [self createHeadUI];
    [self getData];
}
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiTodayBonusRecordWithDateStr:self.dateStr page:self.pageNum limit:10] subscribeNext:^(WCBaseModel *model) {
        for (int i = 0; i < model.content.count; i++) {
            BonusRecordModel *recordModel = [BonusRecordModel mj_objectWithKeyValues:model.content[i]];
            [self.bonusTableData addObject:recordModel];
        }
        if (model.hasNext) {
            self.bonusTable.mj_footer.hidden = NO;;
        }else{
            self.bonusTable.mj_footer.hidden = YES;
        }
        if ([self.bonusTable.mj_header isRefreshing]) {
            [self.bonusTable.mj_header endRefreshing];
        }
        if ([self.bonusTable.mj_footer isRefreshing]) {
            [self.bonusTable.mj_footer endRefreshing];
        }
        [self.bonusTable reloadData];
    } error:^(NSError * _Nullable error) {
        if ([self.bonusTable.mj_header isRefreshing]) {
            [self.bonusTable.mj_header endRefreshing];
        }
        if ([self.bonusTable.mj_footer isRefreshing]) {
            [self.bonusTable.mj_footer endRefreshing];
        }
    }];
}
#pragma mark UI
- (void)createHeadUI{
    self.headView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(244, 244, 255, 1) alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(88));
    }];
    //前一天
    UIImageView *lastImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bonus_lastday"]];
    [self.headView addSubview:lastImg];
    [lastImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(26));
        make.centerY.mas_equalTo(self.headView);
        make.width.and.height.mas_equalTo(ANDY_Adapta(20));
    }];
    UILabel *lastLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:GrayColor text:@"前一天" Radius:0];
    [self.headView addSubview:lastLabel];
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lastImg.mas_right).offset(ANDY_Adapta(11));
        make.top.and.bottom.mas_equalTo(self.headView);
        make.width.mas_equalTo(ANDY_Adapta(100));
    }];
    UIButton *lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastBtn addTarget:self action:@selector(lastAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:lastBtn];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lastImg.mas_left);
        make.right.mas_equalTo(lastLabel.mas_right);
        make.top.and.bottom.mas_equalTo(self.headView);
    }];
    //后一天
    UIImageView *nextImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bonus_nextday"]];
    [self.headView addSubview:nextImg];
    [nextImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headView.mas_right).offset(-ANDY_Adapta(26));
        make.centerY.mas_equalTo(self.headView);
        make.width.and.height.mas_equalTo(ANDY_Adapta(20));
    }];
    UILabel *nextLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(14) textColor:GrayColor text:@"后一天" Radius:0];
    [self.headView addSubview:nextLabel];
    [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(nextImg.mas_left).offset(-ANDY_Adapta(11));
        make.top.and.bottom.mas_equalTo(self.headView);
        make.width.mas_equalTo(ANDY_Adapta(100));
    }];
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(nextImg.mas_right);
        make.left.mas_equalTo(nextLabel.mas_left);
        make.top.and.bottom.mas_equalTo(self.headView);
    }];
    
    self.dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dateBtn setTitle:[Tools getProfitDateStringOfDate:[NSDate date]] forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:RGBA(100, 83, 181, 1) forState:UIControlStateNormal];
    [[self.dateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self showCalendar];
    }];
    [self.headView addSubview:self.dateBtn];
    [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.centerX.mas_equalTo(self.headView);
    }];
    
    self.fscalendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-ANDY_Adapta(20), ANDY_Adapta(400))];
    self.fscalendar.dataSource = self;
    self.fscalendar.delegate = self;
    self.fscalendar.backgroundColor = [UIColor whiteColor];
    self.fscalendar.layer.cornerRadius = 10;
    
    self.fscalendar.appearance.titleFont = Font_(14);
    self.fscalendar.appearance.headerTitleFont = Font_(15);
    self.fscalendar.appearance.weekdayFont = Font_(15);
    self.fscalendar.appearance.subtitleFont = Font_(10);
    
    self.fscalendar.appearance.headerMinimumDissolvedAlpha = 0;
    self.fscalendar.appearance.headerDateFormat = @"yyyy 年 MM 月";
    
    self.fscalendar.appearance.headerTitleColor = NavigationBarColor;
    self.fscalendar.appearance.weekdayTextColor = NavigationBarColor;
    self.fscalendar.appearance.selectionColor =  NavigationBarColor;
    self.fscalendar.appearance.titleSelectionColor = [UIColor whiteColor];
    
    UILabel *nickNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(13) textColor:GrayColor text:@"昵称" Radius:0];
    [self.view addSubview:nickNameLabel];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH/3.0);
        make.height.mas_equalTo(ANDY_Adapta(100));
    }];
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = LineColor;
    [self.view addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nickNameLabel);
        make.left.mas_equalTo(nickNameLabel.mas_right);
        make.width.mas_equalTo(ANDY_Adapta(2));
        make.height.mas_equalTo(ANDY_Adapta(40));
    }];
    
    UILabel *yuxiLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(13) textColor:GrayColor text:@"分红玉玺数" Radius:0];
    [self.view addSubview:yuxiLabel];
    [yuxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineImg.mas_right);
        make.width.and.height.and.top.mas_equalTo(nickNameLabel);
    }];
    
    UILabel *todayProfit = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(13) textColor:GrayColor text:@"今日分红" Radius:0];
    [self.view addSubview:todayProfit];
    [todayProfit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yuxiLabel.mas_right);
        make.top.and.bottom.mas_equalTo(yuxiLabel);
        make.right.mas_equalTo(self.view);
    }];
    [self.view addSubview:self.bonusTable];
    [self.bonusTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nickNameLabel.mas_bottom);
        make.left.and.right.and.bottom.mas_equalTo(self.view);
    }];
}
- (UITableView *)bonusTable{
    if (!_bonusTable) {
        _bonusTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _bonusTable.showsVerticalScrollIndicator = NO;
//        _bonusTable.bounces = NO;
        _bonusTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _bonusTable.backgroundColor = [UIColor clearColor];
        _bonusTable.delegate = self;
        _bonusTable.dataSource = self;
        _bonusTable.emptyDataSetSource = self;
        _bonusTable.emptyDataSetDelegate = self;
        _bonusTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
//        [footer setTitle:@"查看更多数据..." forState:MJRefreshStateIdle];
//        [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//        [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
        _bonusTable.mj_footer = footer;
    }
    return _bonusTable;
}
//下拉
- (void)headerRefresh{
    self.pageNum = 1;
    [self.bonusTableData removeAllObjects];
    [self getData];
}
//上拉
- (void)footerRefresh{
    self.pageNum++;
    [self getData];
}
#pragma mark Action
//前一天
- (void)lastAction{
    NSDate *nowDate = [Tools dateFromString:self.dateStr];
    NSString *yesterday = [Tools Getyesterday:nowDate];
    self.dateStr = yesterday;
    [self.dateBtn setTitle:self.dateStr forState:UIControlStateNormal];
    [self.bonusTableData removeAllObjects];
    self.pageNum = 1;
    [self getData];
}
//后一天
- (void)nextAction{
    if ([self.dateStr isEqualToString:[Tools getProfitDateStringOfDate:[NSDate date]]]) {
        [MBProgressHUD showText:@"已经是最后一天了" toView:self.view afterDelay:1.0];
        return;
    }
    NSDate *nowDate = [Tools dateFromString:self.dateStr];
    NSString *tomorrow = [Tools GetTomorrow:nowDate];
    self.dateStr = tomorrow;
    [self.dateBtn setTitle:self.dateStr forState:UIControlStateNormal];
    [self.bonusTableData removeAllObjects];
    self.pageNum = 1;
    [self getData];
}
//显示日历
- (void)showCalendar{
    if (!self.amptp) {
        self.amptp = [AMPopTip popTip];
    }
    if (![self.amptp isVisible] && ![self.amptp isAnimating]) {
        [self.amptp showCustomView:self.fscalendar
                 direction:AMPopTipDirectionDown
                    inView:self.view
                 fromFrame:CGRectOffset(self.dateBtn.frame, 23, 0)]; //这个23咋回事
        
        self.amptp.textColor = [UIColor whiteColor];
        self.amptp.tintColor = NavigationBarColor;
        self.amptp.popoverColor = NavigationBarColor;
        self.amptp.borderColor = [UIColor whiteColor];
        
        self.amptp.radius = ANDY_Adapta(15);
        
        [self.amptp setDismissHandler:^{
            self.amptp = NULL;
        }];
    }
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bonusTableData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(103);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"BonusRecordCell";
    BonusRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[BonusRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.bonusTableData.count > indexPath.row) {
        [cell setData:self.bonusTableData[indexPath.row]];
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
#pragma mark FSCalendarDelegate
//最大时间今天
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate date];
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    self.dateStr = [Tools getProfitDateStringOfDate:date];
    [self.dateBtn setTitle:self.dateStr forState:UIControlStateNormal];
    [self.amptp hide];
    self.pageNum = 1;
    [self.bonusTableData removeAllObjects];
    [self getData];
}

@end
