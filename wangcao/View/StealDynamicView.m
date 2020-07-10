//
//  StealDynamicView.m
//  wangcao
//
//  Created by liu dequan on 2020/5/18.
//  Copyright © 2020 andy. All rights reserved.
//

#import "StealDynamicView.h"
#import "TaojinCell1.h"

@interface StealDynamicView()

@property (nonatomic,strong) UIView *myStealView;

@property (nonatomic,strong) UITableView *stealTableView;
@property (nonatomic,strong) NSMutableArray *tableDataArr;

@end

@implementation StealDynamicView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        self.hidden = YES;
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    self.myStealView = [GGUI ui_view:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, SCREENWIDTH, spaceHeight(1067)) backgroundColor:RGBA(250, 240, 224, 1) alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:self.myStealView];
    
    UILabel *dtLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(16) textColor:RGBA(153, 58, 20, 1) text:@"动态" Radius:0];
    [self.myStealView addSubview:dtLabel];
    [dtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.myStealView);
        make.height.mas_equalTo(spaceHeight(97));
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(closeStealView) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"bonus_close"] forState:UIControlStateNormal];
    [self.myStealView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.myStealView.mas_right).offset(-ANDY_Adapta(33));
        make.top.mas_equalTo(spaceHeight(33));
        make.width.and.height.mas_equalTo(ANDY_Adapta(25));
    }];
    
    [self addSubview:self.stealTableView];
    [self.stealTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self);
        make.top.mas_equalTo(closeBtn.mas_bottom).offset(ANDY_Adapta(40));
    }];
}

- (void)setData:(NSArray *)arr{
    [self.tableDataArr addObjectsFromArray:arr];
    [self.stealTableView reloadData];
}

- (NSMutableArray *)tableDataArr{
    if (!_tableDataArr) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}
- (UITableView *)stealTableView{
    if (!_stealTableView) {
        _stealTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _stealTableView.backgroundColor = [UIColor clearColor];
        _stealTableView.bounces = NO;
        _stealTableView.showsVerticalScrollIndicator = NO;
        _stealTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _stealTableView.delegate = self;
        _stealTableView.dataSource = self;
    }
    return _stealTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:RGBA(153, 58, 20, 1) text:@"2020-05-29" Radius:0];
    [tableView.tableHeaderView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.and.bottom.mas_equalTo(tableView.tableHeaderView);
        make.left.mas_equalTo(ANDY_Adapta(30));
    }];
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(152);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"TaojinCell1";
    TaojinCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[TaojinCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.tableDataArr.count > indexPath.row) {
        [cell setData:self.tableDataArr[indexPath.row]];
    }
    return cell;
}

- (void)showAnimation{
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.myStealView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-spaceHeight(1067), SCREENWIDTH, spaceHeight(1067));
    } completion:^(BOOL finished) {
        
    }];
}
- (void)closeStealView{
    [UIView animateWithDuration:0.3 animations:^{
        self.myStealView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, SCREENWIDTH, spaceHeight(1067));
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

@end
