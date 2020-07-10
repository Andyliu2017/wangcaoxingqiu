//
//  InvitaController.m
//  wangcao
//
//  Created by EDZ on 2020/6/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import "InvitaController.h"
#import "InviteCell.h"
#import "SharePopView.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>

@interface InvitaController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UIScrollView *invitaScroll;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger pageNum;
//分享弹窗
@property (nonatomic,strong) SharePopView *shareView;
//是否有下一批
@property (nonatomic,assign) BOOL isMoreData;
@property (nonatomic,weak) JhtVerticalMarquee *marqueeView;

@end

@implementation InvitaController

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] init];
        _tableview.bounces = NO;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
    }
    return _tableview;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NavigationBarColor;
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.bounces = NO;
    [self.view addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    scrollview.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1790));
    self.invitaScroll = scrollview;
    
    [self cgreateScrollUI];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"luck_back"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeCenter];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(70));
        make.left.mas_equalTo(ANDY_Adapta(0));
        make.width.and.height.mas_equalTo(ANDY_Adapta(55));
    }];
    self.pageNum = 1;
    self.isMoreData = YES;
    [self getData];
    [self getAnnounceData];
}

- (void)cgreateScrollUI{
    UIImageView *topImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invite_topimg"]];
    [self.invitaScroll addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(80));
        make.left.mas_equalTo(ANDY_Adapta(70));
        make.width.mas_equalTo(ANDY_Adapta(632));
        make.height.mas_equalTo(ANDY_Adapta(257));
    }];
    
    UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteBtn setBackgroundImage:[UIImage imageNamed:@"invite_inbtn"] forState:UIControlStateNormal];
    [inviteBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
    [inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    inviteBtn.titleLabel.font = FontBold_(16);
    [inviteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, ANDY_Adapta(10), 0)];
    [inviteBtn addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.invitaScroll addSubview:inviteBtn];
    [inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(topImg.mas_bottom).offset(-ANDY_Adapta(13));
        make.left.mas_equalTo(topImg.mas_left).offset(-ANDY_Adapta(11));
        make.width.mas_equalTo(ANDY_Adapta(263));
        make.height.mas_equalTo(ANDY_Adapta(82));
    }];
    
    UIImageView *annountImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invite_annount"]];
    [self.invitaScroll addSubview:annountImg];
    [annountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(45));
        make.top.mas_equalTo(topImg.mas_bottom).offset(ANDY_Adapta(35));
        make.width.and.height.mas_equalTo(ANDY_Adapta(35));
    }];
    
    JhtVerticalMarquee *marqueeView1 = [[JhtVerticalMarquee alloc] initWithFrame:CGRectMake(CGRectGetMaxX(annountImg.frame)+ANDY_Adapta(20), annountImg.frame.origin.y, ANDY_Adapta(580), annountImg.frame.size.height)];
    marqueeView1.textColor = [UIColor whiteColor];
    marqueeView1.textFont = Font_(12);
    [self.invitaScroll addSubview:marqueeView1];
    self.marqueeView = marqueeView1;
    
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.invitaScroll addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.invitaScroll);
        make.top.mas_equalTo(annountImg.mas_bottom).offset(ANDY_Adapta(33));
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(693));
    }];
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    whiteView.clipsToBounds = YES;
    [self.invitaScroll addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.invitaScroll);
        make.top.mas_equalTo(annountImg.mas_bottom).offset(ANDY_Adapta(23));
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(693));
    }];
    [self myFriendView:whiteView];
    
    UIImageView *skillImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invite_skill"]];
    [self.invitaScroll addSubview:skillImg];
    [skillImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.invitaScroll);
        make.top.mas_equalTo(blackView.mas_bottom).offset(ANDY_Adapta(13));
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(360));
    }];
    
    UILabel *number1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"1" Radius:0];
    number1.layer.cornerRadius = ANDY_Adapta(17);
    number1.layer.masksToBounds = YES;
    number1.backgroundColor = RankColor;
    [self.invitaScroll addSubview:number1];
    [number1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(skillImg.mas_left);
        make.top.mas_equalTo(skillImg.mas_bottom).offset(ANDY_Adapta(30));
        make.width.and.height.mas_equalTo(ANDY_Adapta(34));
    }];
    UILabel *setup1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:[UIColor whiteColor] text:@"邀请您的家人、朋友、同学、同事成功率高；" Radius:0];
    [self.invitaScroll addSubview:setup1];
    [setup1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(number1.mas_right).offset(ANDY_Adapta(12));
        make.top.mas_equalTo(number1);
        make.right.mas_equalTo(skillImg.mas_right);
    }];
    
    UILabel *number2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"2" Radius:0];
    number2.layer.cornerRadius = ANDY_Adapta(17);
    number2.layer.masksToBounds = YES;
    number2.backgroundColor = RankColor;
    [self.invitaScroll addSubview:number2];
    [number2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(number1.mas_left);
        make.top.mas_equalTo(number1.mas_bottom).offset(ANDY_Adapta(20));
        make.width.and.height.mas_equalTo(ANDY_Adapta(34));
    }];
    UILabel *setup2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:[UIColor whiteColor] text:@"分享到3个以上微信群/QQ群，邀请成功率提升200%；" Radius:0];
    [self.invitaScroll addSubview:setup2];
    [setup2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(number2.mas_right).offset(ANDY_Adapta(12));
        make.top.mas_equalTo(number2);
        make.right.mas_equalTo(skillImg.mas_right);
    }];
    
    UILabel *number3 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"3" Radius:0];
    number3.layer.cornerRadius = ANDY_Adapta(17);
    number3.layer.masksToBounds = YES;
    number3.backgroundColor = RankColor;
    [self.invitaScroll addSubview:number3];
    [number3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(number2.mas_left);
        make.top.mas_equalTo(number2.mas_bottom).offset(ANDY_Adapta(20));
        make.width.and.height.mas_equalTo(ANDY_Adapta(34));
    }];
    UILabel *setup3 = [GGUI ui_label:CGRectZero lines:2 align:NSTextAlignmentLeft font:FontBold_(12) textColor:[UIColor whiteColor] text:@"如果在微信分享时弹出“发生异常，无法分享”的提示，只需要将微信退出重新登录，就可以正常分享；" Radius:0];
    [self.invitaScroll addSubview:setup3];
    [setup3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(number3.mas_right).offset(ANDY_Adapta(12));
        make.top.mas_equalTo(number3);
        make.right.mas_equalTo(skillImg.mas_right);
    }];
    
    UILabel *number4 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"4" Radius:0];
    number4.layer.cornerRadius = ANDY_Adapta(17);
    number4.layer.masksToBounds = YES;
    number4.backgroundColor = RankColor;
    [self.invitaScroll addSubview:number4];
    [number4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(number3.mas_left);
        make.top.mas_equalTo(setup3.mas_bottom).offset(ANDY_Adapta(20));
        make.width.and.height.mas_equalTo(ANDY_Adapta(34));
    }];
    UILabel *setup4 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:[UIColor whiteColor] text:@"为了防止遗漏，记得提醒好友填写邀请码哦。" Radius:0];
    [self.invitaScroll addSubview:setup4];
    [setup4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(number4.mas_right).offset(ANDY_Adapta(12));
        make.top.mas_equalTo(number4);
        make.right.mas_equalTo(skillImg.mas_right);
    }];
}
- (void)myFriendView:(UIView *)whiteView{
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"我的好友（近7日）" Radius:0];
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(38));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(ANDY_Adapta(97));
    }];
    
    UIImageView *refreshImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invite_refresh"]];
    [whiteView addSubview:refreshImg];
    [refreshImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(whiteView.mas_right).offset(-ANDY_Adapta(36));
        make.centerY.mas_equalTo(titleLabel);
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    UILabel *refreshLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(14) textColor:NavigationBarColor text:@"换一批" Radius:0];
    [whiteView addSubview:refreshLabel];
    [refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(refreshImg.mas_left).offset(-ANDY_Adapta(10));
        make.centerY.and.height.mas_equalTo(titleLabel);
    }];
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.height.mas_equalTo(refreshLabel);
        make.right.mas_equalTo(refreshImg.mas_right);
    }];
    
    [whiteView addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.left.and.right.and.bottom.mas_equalTo(whiteView);
    }];
}
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserFinishTask:self.pageNum limit:4] subscribeNext:^(WCBaseModel *model) {
        for (int i = 0; i < model.content.count; i++) {
            InviteModel *inModel = [InviteModel mj_objectWithKeyValues:model.content[i]];
            [self.dataArr addObject:inModel];
        }
        [self.tableview reloadData];
        self.isMoreData = model.hasNext;
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 获取滚动公告
- (void)getAnnounceData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserFinishTaskLog] subscribeNext:^(NSArray *arr) {
        if (arr.count > 0) {
            self.marqueeView.sourceArray = arr;
            // 开始滚动
            [self.marqueeView marqueeOfSettingWithState:MarqueeStart_V];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 换一批
- (void)refreshAction{
    if (!self.isMoreData) {
        [MBProgressHUD showText:@"没有更多数据了" toView:self.view afterDelay:1.0];
        return;
    }
    self.pageNum++;
    [self.dataArr removeAllObjects];
    [self getData];
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ANDY_Adapta(147);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"InviteCell";
    InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[InviteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.dataArr.count > indexPath.row) {
        [cell setData:self.dataArr[indexPath.row]];
    }
    cell.inviteblock = ^{
        [self sharePopView];
    };
    return cell;
}
- (void)sharePopView{
    if (self.shareView) {
        [self.shareView removeFromSuperview];
    }
    self.shareView = [SharePopView new];
    [self.shareView setDataWithImg:[UIImage imageNamed:@"share_invate_bg"] type:1 teamNum:[PBCache shared].userModel.invitecode nickName:[PBCache shared].userModel.nickName qrcode:[PBCache shared].userModel.qrcode];
    [self.shareView showView];
}
#pragma mark DZNEmptyDataSetDelegate
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

- (void)inviteAction{
    [self sharePopView];
//    if (self.shareView) {
//        [self.shareView removeFromSuperview];
//    }
//    self.shareView = [SharePopView new];
//    [self.shareView setDataWithImg:[UIImage imageNamed:@"share_invate_bg"] type:1 teamNum:[PBCache shared].userModel.invitecode nickName:[PBCache shared].userModel.nickName qrcode:[PBCache shared].userModel.qrcode];
//    [self.shareView showView];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
