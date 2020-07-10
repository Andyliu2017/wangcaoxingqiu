//
//  MyViewController.m
//  wangcao
//
//  Created by EDZ on 2020/5/7.
//  Copyright © 2020 andy. All rights reserved.
//

#import "MyViewController.h"
#import "MessageViewController.h"
#import "SetViewController.h"
#import "WechatController.h"
#import "FeedBackController.h"
#import "FeedController.h"
#import "FotonShopController.h"
#import "ModifyController.h"
#import "DianGuKaController.h"
#import "SharePopView.h"
#import "MyWalletController.h"
#import "InvitaController.h"

@interface MyViewController ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIScrollView *myScrollView;
//我的信息
@property (nonatomic,strong) UIImageView *myinfoImg;
@property (nonatomic,strong) UIImageView *myHeadImg;  //头像
@property (nonatomic,strong) UILabel *partnerLabel;   //合伙人
@property (nonatomic,strong) UILabel *userNameLabel;  //用户名
@property (nonatomic,strong) UILabel *idLabel;   //ID
//分红玉玺
@property (nonatomic,strong) UIImageView *bonusBgImg;
@property (nonatomic,strong) UIProgressView *bonusProgress;  //分红玉玺加速
@property (nonatomic,strong) UILabel *bonusLabel;  //分红解锁进度
//其他  福豆商城 钱包 典故卡
@property (nonatomic,strong) UIImageView *otherBgImg;
//去加速
@property (nonatomic,strong) UIView *goFeedView;
//福豆数量
@property (nonatomic,strong) UILabel *fudouLabel;

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myHeadImg setImageWithURL:[NSURL URLWithString:[PBCache shared].userModel.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.userNameLabel.text = [PBCache shared].userModel.nickName;
    self.idLabel.text = [NSString stringWithFormat:@"ID:%ld",[PBCache shared].userModel.user_id];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.myScrollView.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1430));
    self.fudouLabel.text = [NSString stringWithFormat:@"我的福豆:%@",[GGUI goldConversion:[NSString stringWithFormat:@"%ld",[PBCache shared].goldModel.blessBean]]] ;
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
#pragma mark 界面
- (void)createUI{
    self.view.backgroundColor = NavigationBarColor;
    self.myScrollView = [[UIScrollView alloc] init];
    self.myScrollView.scrollEnabled = YES;
    self.myScrollView.userInteractionEnabled = YES;
    self.myScrollView.bounces = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.myScrollView];
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.view);
    }];
//    self.myScrollView.contentOffset = CGPointMake(0, 0);
//    self.myScrollView.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(1374));
    
    UIImageView *floorImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_floor"]];
    [self.myScrollView addSubview:floorImg];
    [floorImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        }else{
//            make.top.mas_equalTo(ANDY_Adapta(39));
//        }
        make.top.mas_equalTo(ANDY_Adapta(59));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(630));
        make.height.mas_equalTo(ANDY_Adapta(216));
    }];
    
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(24) textColor:RGBA(255, 223, 110, 1) text:@"" Radius:0];
    [floorImg addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(floorImg);
        make.top.mas_equalTo(ANDY_Adapta(50));
        make.height.mas_equalTo(ANDY_Adapta(50));
    }];
    //个人信息
    [self createInfoUI];
    //分红玉玺
    [self bonusUI];
    //福豆商城、钱包、典故卡等
    [self otherUI];
}

#pragma mark 界面
//个人信息
- (void)createInfoUI{
    self.myinfoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_info"]];
    self.myinfoImg.userInteractionEnabled = YES;
    [self.myScrollView addSubview:self.myinfoImg];
    [self.myinfoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(ANDY_Adapta(27));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(188));
    }];
    //头像
    self.myHeadImg = [[UIImageView alloc] init];
    self.myHeadImg.layer.cornerRadius = ANDY_Adapta(60);
    self.myHeadImg.layer.masksToBounds = YES;
    self.myHeadImg.layer.borderWidth = ANDY_Adapta(3);
    self.myHeadImg.layer.borderColor = RankColor.CGColor;
    [self.myinfoImg addSubview:self.myHeadImg];
    [self.myHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myinfoImg).offset(ANDY_Adapta(24));
        make.right.mas_equalTo(self.myinfoImg).inset(22);
        make.width.and.height.mas_equalTo(ANDY_Adapta(120));
    }];
    
    self.partnerLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"合伙人" Radius:0];
    self.partnerLabel.backgroundColor = RankColor;
    self.partnerLabel.layer.cornerRadius = ANDY_Adapta(15);
    self.partnerLabel.layer.masksToBounds = YES;
    self.partnerLabel.hidden = YES;
    [self.myinfoImg addSubview:self.partnerLabel];
    [self.partnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self.myHeadImg);
        make.height.mas_equalTo(ANDY_Adapta(30));
        make.width.mas_equalTo(ANDY_Adapta(80));
    }];
    
    self.userNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(18) textColor:RGBA(0, 0, 51, 1) text:@"" Radius:0];
    [self.myinfoImg addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myHeadImg);
        make.left.mas_equalTo(ANDY_Adapta(39));
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
    self.idLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:RGBA(0, 0, 51, 1) text:@"" Radius:0];
    [self.myinfoImg addSubview:self.idLabel];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.height.mas_equalTo(self.userNameLabel);
        make.top.mas_equalTo(self.userNameLabel.mas_bottom);
    }];
    
    UIImageView *modifyImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_modify"]];
    [self.myinfoImg addSubview:modifyImg];
    [modifyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNameLabel.mas_right).offset(ANDY_Adapta(17));
        make.centerY.mas_equalTo(self.userNameLabel);
    }];
    
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyBtn addTarget:self action:@selector(modifyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.myinfoImg addSubview:modifyBtn];
    [modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.myinfoImg);
    }];
}
//分红玉玺
- (void)bonusUI{
    self.bonusBgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_bonusBg"]];
    [self.myScrollView addSubview:self.bonusBgImg];
    [self.bonusBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myinfoImg.mas_bottom).offset(ANDY_Adapta(20));
        make.left.and.width.mas_equalTo(self.myinfoImg);
        make.height.mas_equalTo(ANDY_Adapta(155));
    }];
    //去加速
    self.goFeedView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(254, 172, 56, 1) alpha:1.0 cornerRadius:ANDY_Adapta(30) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.myScrollView addSubview:self.goFeedView];
    [self.goFeedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bonusBgImg.mas_right);
        make.top.mas_equalTo(self.bonusBgImg.mas_top).offset(-ANDY_Adapta(13));
        make.width.mas_equalTo(ANDY_Adapta(156));
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
    UIImageView *feedImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_feedImg"]];
    [self.goFeedView addSubview:feedImg];
    [feedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.goFeedView);
        make.left.mas_equalTo(ANDY_Adapta(18));
    }];
    UILabel *goFeedLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(13) textColor:[UIColor whiteColor] text:@"去加速" Radius:0];
    [self.goFeedView addSubview:goFeedLabel];
    [goFeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self.goFeedView);
        make.left.mas_equalTo(feedImg.mas_right).offset(ANDY_Adapta(4));
    }];
    UIButton *feedBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(0) normalColor:[UIColor clearColor] normalText:@"" click:^(id  _Nonnull x) {
        FeedController *feedVc = [[FeedController alloc] init];
        feedVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedVc animated:YES];
    }];
    [self.goFeedView addSubview:feedBtn];
    [feedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.goFeedView);
    }];
    //玉玺图标
    UIImageView *bonusImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_bonus"]];
    [self.bonusBgImg addSubview:bonusImg];
    [bonusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(39));
        make.top.mas_equalTo(ANDY_Adapta(6));
        make.width.mas_equalTo(ANDY_Adapta(110));
        make.height.mas_equalTo(ANDY_Adapta(124));
    }];
    UILabel *feedLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(15) textColor:MYTEXT_COLOR text:@"分红玉玺加速" Radius:0];
    [self.bonusBgImg addSubview:feedLabel];
    [feedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bonusImg.mas_right).offset(ANDY_Adapta(37));
        make.top.mas_equalTo(ANDY_Adapta(7));
        make.width.mas_equalTo(ANDY_Adapta(342));
        make.height.mas_equalTo(ANDY_Adapta(60));
    }];
    //分红玉玺进度条
    self.bonusProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.bonusProgress.layer.cornerRadius = ANDY_Adapta(6);
    self.bonusProgress.layer.masksToBounds = YES;
    self.bonusProgress.progress = 0;
    //已过进度条颜色
    self.bonusProgress.progressTintColor = ProgressSelectColor;
    //未过
    self.bonusProgress.trackTintColor = ProgressNoColor;
    [self.bonusBgImg addSubview:self.bonusProgress];
    [self.bonusProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(feedLabel);
        make.top.mas_equalTo(feedLabel.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(423));
        make.height.mas_equalTo(ANDY_Adapta(12));
    }];
    self.bonusLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(11) textColor:MYTEXT_COLOR text:@"已解锁4.485%，解锁后必得分红玉玺" Radius:0];
    [self.bonusBgImg addSubview:self.bonusLabel];
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bonusProgress);
        make.right.mas_equalTo(self.bonusBgImg);
        make.top.mas_equalTo(self.bonusProgress.mas_bottom).offset(ANDY_Adapta(19));
        make.height.mas_equalTo(ANDY_Adapta(22));
    }];
}
//福豆商城、钱包、典故卡
- (void)otherUI{
    self.otherBgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_other"]];
    self.otherBgImg.userInteractionEnabled = YES;
    [self.myScrollView addSubview:self.otherBgImg];
    [self.otherBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bonusBgImg.mas_bottom).offset(ANDY_Adapta(10));
        make.left.and.width.mas_equalTo(self.bonusBgImg);
        make.height.mas_equalTo(ANDY_Adapta(816));
    }];
    NSArray *iconArr;
    NSArray *titleArr;
//    if (![WXApi isWXAppInstalled]) {
//        iconArr = @[@"my_fudou",@"my_money",@"my_diangu",@"",@"my_message",@"",@"my_help",@"my_set"];
//        titleArr = @[[NSString stringWithFormat:@"我的福豆:%ld",[PBCache shared].goldModel.blessBean],@"我的钱包",@"我的典故卡",@"",@"消息通知",@"",@"帮助与反馈",@"设置"];
//    }else{
        iconArr = @[@"my_fudou",@"my_money",@"my_diangu",@"my_invitation",@"my_message",@"my_wx",@"my_help",@"my_set"];
        titleArr = @[[NSString stringWithFormat:@"我的福豆:%@",[GGUI goldConversion:[NSString stringWithFormat:@"%ld",[PBCache shared].goldModel.blessBean]]],@"我的钱包",@"我的典故卡",@"邀请有奖",@"消息通知",@"关注公众号",@"帮助与反馈",@"设置"];
//    }
    for (int i = 0; i < iconArr.count; i++) {
//        UIView *otherView = [GGUI myOtherViewWithIcon:[UIImage imageNamed:iconArr[i]] title:titleArr[i] withLabel:self.fudouLabel index:i click:^(id x) {
//            [self otherViewClick:i];
//        }];
        UIView *otherView = [self myOtherViewWithIcon:[UIImage imageNamed:iconArr[i]] title:titleArr[i] index:i];
        [self.otherBgImg addSubview:otherView];
//        if (i == 1 && [PBCache shared].memberModel.userType == 2) {
//            otherView.hidden = YES;
//        }
//        if (![WXApi isWXAppInstalled] || [PBCache shared].memberModel.userType == 2) {
//            if (i == 1 || i == 3 || i == 5) {
//                otherView.hidden = YES;
//            }
//        }
        [otherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            if (i == 0) {
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(ANDY_Adapta(110));
            }else{
//                if (![WXApi isWXAppInstalled]) {
//                    if (i == 1) {
//                        make.top.mas_equalTo(ANDY_Adapta(110)+(i-1)*ANDY_Adapta(98));
//                        make.height.mas_equalTo(ANDY_Adapta(0));
//                    }else if (i == 2){
//                        make.top.mas_equalTo(ANDY_Adapta(110)+(i-2)*ANDY_Adapta(98));
//                        make.height.mas_equalTo(ANDY_Adapta(98));
//                    }else if (i == 3){
//                        make.top.mas_equalTo(ANDY_Adapta(110)+(i-1)*ANDY_Adapta(98));
//                        make.height.mas_equalTo(0);
//                    }else if (i == 4){
//                        make.top.mas_equalTo(ANDY_Adapta(110)+(i-3)*ANDY_Adapta(98));
//                        make.height.mas_equalTo(ANDY_Adapta(98));
//                    }else if (i == 5){
//                        make.top.mas_equalTo(ANDY_Adapta(110)+(i-3)*ANDY_Adapta(98));
//                        make.height.mas_equalTo(ANDY_Adapta(0));
//                    }else{
//                        make.top.mas_equalTo(ANDY_Adapta(110)+(i-4)*ANDY_Adapta(98));
//                        make.height.mas_equalTo(ANDY_Adapta(98));
//                    }
//                }else{
                    make.top.mas_equalTo(ANDY_Adapta(110)+(i-1)*ANDY_Adapta(98));
                    make.height.mas_equalTo(ANDY_Adapta(98));
//                }
            }
        }];
    }
}

- (UIView *)myOtherViewWithIcon:(UIImage *)iconimage title:(NSString *)title index:(int)index{
    UIView *otherview = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    //图标
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:iconimage];
    [otherview addSubview:iconImg];
    //文字
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(16) textColor:MYTEXT_COLOR text:title Radius:0];
    [otherview addSubview:titleLabel];
    //箭头
    UIImageView *jtImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_jiantou"]];
    [otherview addSubview:jtImg];
    //福豆商城
    if (index == 0) {
        self.fudouLabel = titleLabel;
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ANDY_Adapta(22));
            make.centerY.mas_equalTo(0);
            make.width.and.height.mas_equalTo(ANDY_Adapta(30));
        }];
        titleLabel.textColor = RGBA(143, 67, 11, 1);
        titleLabel.font = FontBold_(16);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconImg.mas_right).offset(ANDY_Adapta(12));
            make.top.and.height.mas_equalTo(otherview);
            make.width.mas_equalTo(ANDY_Adapta(367));
        }];
        UILabel *titleLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(15) textColor:RGBA(143, 67, 11, 1) text:@"福豆商城" Radius:0];
        [otherview addSubview:titleLabel1];
        [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right);
            make.top.and.height.mas_equalTo(otherview);
            make.width.mas_equalTo(ANDY_Adapta(200));
        }];
        jtImg.image = [UIImage imageNamed:@"my_fdJiantou"];
        [jtImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel1.mas_right);
            make.centerY.mas_equalTo(0);
            make.width.and.height.mas_equalTo(ANDY_Adapta(32));
        }];
//        if (![WXApi isWXAppInstalled] || [PBCache shared].memberModel.userType == 2) {
//            titleLabel1.hidden = YES;
//            jtImg.hidden = YES;
//        }
    }else{   //钱包、典故卡等
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ANDY_Adapta(31));
            make.centerY.mas_equalTo(0);
            make.width.and.height.mas_equalTo(ANDY_Adapta(36));
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconImg.mas_right).offset(ANDY_Adapta(31));
            make.top.and.height.mas_equalTo(otherview);
            make.width.mas_equalTo(ANDY_Adapta(533));
        }];
        [jtImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right);
            make.centerY.mas_equalTo(0);
            make.width.and.height.mas_equalTo(ANDY_Adapta(32));
        }];
        //线
        UIImageView *lineImg = [[UIImageView alloc] init];
        lineImg.backgroundColor = RGBA(204, 204, 204, 1);
        [otherview addSubview:lineImg];
        [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ANDY_Adapta(26));
            make.bottom.mas_equalTo(otherview);
            make.width.mas_equalTo(ANDY_Adapta(638));
            make.height.mas_equalTo(ANDY_Adapta(1));
        }];
    }
    //添加点击
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherview addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(otherview);
    }];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self otherViewClick:index];
    }];
    return otherview;
}

#pragma mark 我的页面的点击事件
- (void)otherViewClick:(int)index{
    switch (index) {
        case 0:  //福豆商城
        {
//            if (![WXApi isWXAppInstalled] || [PBCache shared].memberModel.userType == 2) {
//                return;
//            }
            FotonShopController *fotonVc = [[FotonShopController alloc] init];
            fotonVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fotonVc animated:YES];
        }
            break;
        case 1:  //我的钱包
        {
            MyWalletController *vc = [[MyWalletController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:  //我的典故卡
        {
            DianGuKaController *vc = [[DianGuKaController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:  //邀请
        {
//            SharePopView *shareView = [SharePopView new];
//            [shareView setDataWithImg:[UIImage imageNamed:@"share_invate_bg"] type:1 teamNum:[PBCache shared].userModel.invitecode nickName:[PBCache shared].userModel.nickName qrcode:[PBCache shared].userModel.qrcode];
//            [shareView showView];
            InvitaController *vc = [[InvitaController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:  //消息通知
        {
            MessageViewController *messVC = [[MessageViewController alloc] init];
            messVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:messVC animated:YES];
        }
            break;
        case 5:  //关注公众号
        {
            WechatController *wechatVc = [[WechatController alloc] init];
            wechatVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wechatVc animated:YES];
        }
            break;
        case 6:  //帮助
        {
            FeedBackController *vc = [[FeedBackController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:  //设置
        {
            SetViewController *setVC = [[SetViewController alloc] init];
            setVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        default:
            break;
    }
}
//修改用户信息
- (void)modifyAction{
    ModifyController *modifyVC = [[ModifyController alloc] init];
    modifyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:modifyVC animated:YES];
}
#pragma mark 数据
- (void)loadData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiBonusProgress] subscribeNext:^(BonusProgressModel *model) {
        self.bonusProgress.progress = model.totalProcess / 100.0;
        self.bonusLabel.text = [NSString stringWithFormat:@"已解锁%ld%@，解锁后必得分红玉玺",model.totalProcess,@"%"];
    } error:^(NSError * _Nullable error) {
        
    }];
    //获取朝代信息
    [[manager getFetchDynastyInfo] subscribeNext:^(DynastyModel *model) {
        self.titleLabel.text = model.dynastyName;
    } error:^(NSError * _Nullable error) {
        
    }];
    //获取合伙人信息
    [[manager ApiTeamPartnerInfo] subscribeNext:^(id  _Nullable x) {
        NSLog(@"是否是合伙人：%@",x);
//        BOOL ispartner = x;
        Boolean ispartner = (Boolean)x;
        if (ispartner == 1) {
            self.partnerLabel.hidden = NO;
        }else{
            self.partnerLabel.hidden = YES;
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}

@end
