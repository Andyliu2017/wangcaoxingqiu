//
//  DianGuKaController.m
//  wangcao
//
//  Created by EDZ on 2020/5/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import "DianGuKaController.h"
#import "DgkView.h"
#import "LimitBonusView.h"
#import "DianGuKaView.h"

@interface DianGuKaController ()<DgkViewDelegate>

@property (nonatomic,strong) UIScrollView *dgkScrollView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UIView *whiteView1;
@property (nonatomic,strong) UIView *whiteView2;
@property (nonatomic,strong) UIView *whiteView3;
@property (nonatomic,strong) UIView *whiteView4;
@property (nonatomic,strong) UIView *whiteView5;
@property (nonatomic,strong) UIView *whiteView6;
@property (nonatomic,strong) UIView *whiteView7;
@property (nonatomic,strong) UIView *whiteView8;
@property (nonatomic,strong) UIView *whiteView9;
@property (nonatomic,strong) UIView *whiteView10;
//横排按钮
@property (nonatomic,strong) UIButton *hengBtn1;
@property (nonatomic,strong) UIButton *hengBtn2;
@property (nonatomic,strong) UIButton *hengBtn3;
@property (nonatomic,strong) UIButton *hengBtn4;
@property (nonatomic,strong) UIButton *hengBtn5;
@property (nonatomic,strong) UIButton *hengBtn6;
@property (nonatomic,strong) UIButton *hengBtn7;
@property (nonatomic,strong) UIButton *hengBtn8;
@property (nonatomic,strong) UIButton *hengBtn9;
@property (nonatomic,strong) UIButton *hengBtn10;
//底部控件
@property (nonatomic,strong) UIButton *shuBtn1;
@property (nonatomic,strong) UILabel *shuLabel1;
@property (nonatomic,strong) UIButton *shuBtn2;
@property (nonatomic,strong) UILabel *shuLabel2;
@property (nonatomic,strong) UIButton *shuBtn3;
@property (nonatomic,strong) UILabel *shuLabel3;
@property (nonatomic,strong) UIButton *shuBtn4;
@property (nonatomic,strong) UILabel *shuLabel4;
@property (nonatomic,strong) UIButton *shuBtn5;
@property (nonatomic,strong) UILabel *shuLabel5;

@property (nonatomic,strong) NSArray *whiteViewArr;
@property (nonatomic,strong) NSArray *hengBtnArr;
@property (nonatomic,strong) NSArray *shuBtnArr;
@property (nonatomic,strong) NSArray *shuLabelArr;
@property (nonatomic,strong) NSArray *titleArr;
//朝代名称
@property (nonatomic,strong) UILabel *dynastyName1;
@property (nonatomic,strong) UILabel *dynastyName2;
@property (nonatomic,strong) UILabel *dynastyName3;
@property (nonatomic,strong) UILabel *dynastyName4;
@property (nonatomic,strong) UILabel *dynastyName5;
@property (nonatomic,strong) UILabel *dynastyName6;
@property (nonatomic,strong) UILabel *dynastyName7;
@property (nonatomic,strong) UILabel *dynastyName8;
@property (nonatomic,strong) UILabel *dynastyName9;
@property (nonatomic,strong) UILabel *dynastyName10;
//记录横排能否兑换 ==5 能兑换 <5不能
@property (nonatomic,assign) NSInteger hengNum;
//记录竖排能否兑换 =10能 < 10不能
@property (nonatomic,assign) NSInteger shuNum;

@end

@implementation DianGuKaController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    AutoLayout机制，在viewDidLoad函数被执行后，AutoLayout会重新把contentSize修改为符合屏幕大小的数值（也就是说，现在的contentSize又适合了屏幕大小，并没有大于UIScrollView本身的大小，当然也就不能滚动了）。解决办法是在viewDidAppear:(BOOL)animated方法中设置contentSize
    self.dgkScrollView.contentSize = CGSizeMake(SCREENWIDTH, ANDY_Adapta(2764));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(65, 64, 194, 1);
    
    [self createBottomView];
    [self createScrollView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"dgk_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(31));
        make.top.mas_equalTo(ANDY_Adapta(73));
    }];
    
    [self getData];
}
- (void)createBottomView{
    self.bottomView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(200));
    }];
    
    self.shuLabel1 = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentCenter font:FontBold_(10) textColor:GrayColor text:@"暂未集齐" Radius:0];
    self.shuLabel2 = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentCenter font:FontBold_(10) textColor:GrayColor text:@"暂未集齐" Radius:0];
    self.shuLabel3 = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentCenter font:FontBold_(10) textColor:GrayColor text:@"暂未集齐" Radius:0];
    self.shuLabel4 = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentCenter font:FontBold_(10) textColor:GrayColor text:@"暂未集齐" Radius:0];
    self.shuLabel5 = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentCenter font:FontBold_(10) textColor:GrayColor text:@"暂未集齐" Radius:0];
    self.shuLabelArr = @[self.shuLabel1,self.shuLabel2,self.shuLabel3,self.shuLabel4,self.shuLabel5];
    for (int i = 0; i < self.shuLabelArr.count; i++) {
        UILabel *shulabel = self.shuLabelArr[i];
        [self.bottomView addSubview:shulabel];
        [shulabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ANDY_Adapta(20));
            make.width.mas_equalTo(ANDY_Adapta(112));
            make.left.mas_equalTo(ANDY_Adapta(47)+i*ANDY_Adapta(136));
        }];
    }
    
    self.shuBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shuBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shuBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shuBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shuBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shuBtnArr = @[self.shuBtn1,self.shuBtn2,self.shuBtn3,self.shuBtn4,self.shuBtn5];
    for (int i = 0; i < self.shuBtnArr.count; i++) {
        UIButton *shubtn = self.shuBtnArr[i];
        shubtn.hidden = YES;
        shubtn.layer.cornerRadius = ANDY_Adapta(27);
        shubtn.layer.masksToBounds = YES;
        [shubtn setBackgroundColor:RGBA(254, 172, 56, 1)];
        [shubtn setTitle:@"兑换" forState:UIControlStateNormal];
        shubtn.titleLabel.font = FontBold_(12);
        [shubtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [shubtn addTarget:self action:@selector(shuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:shubtn];
        UILabel *shulabel = self.shuLabelArr[i];
        [shubtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(shulabel.mas_centerX);
            make.top.mas_equalTo(ANDY_Adapta(89));
            make.width.mas_equalTo(ANDY_Adapta(107));
            make.height.mas_equalTo(ANDY_Adapta(54));
        }];
    }
}
- (void)createScrollView{
    self.dgkScrollView = [[UIScrollView alloc] init];
    self.dgkScrollView.scrollEnabled = YES;
    self.dgkScrollView.userInteractionEnabled = YES;
    self.dgkScrollView.showsVerticalScrollIndicator = NO;
    self.dgkScrollView.bounces = NO;
    [self.view addSubview:self.dgkScrollView];
    [self.dgkScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    UIImageView *topBgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dgk_top"]];
    topBgImg.userInteractionEnabled = YES;
    [self.dgkScrollView addSubview:topBgImg];
    [topBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.dgkScrollView);
        make.height.mas_equalTo(ANDY_Adapta(399));
    }];
    
    for (int i = 0; i < 10; i++) {
        UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(26, 25, 127, 1) alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
        [self.dgkScrollView addSubview:blackView];
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.dgkScrollView);
            make.width.mas_equalTo(ANDY_Adapta(690));
            make.height.mas_equalTo(ANDY_Adapta(215));
            make.top.mas_equalTo(ANDY_Adapta(363)+ANDY_Adapta(235)*i);
        }];
    }
    //白色view
    self.whiteView1 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView2 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView3 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView4 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView5 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView6 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView7 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView8 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView9 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView10 = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteViewArr = @[self.whiteView1,self.whiteView2,self.whiteView3,self.whiteView4,self.whiteView5,self.whiteView6,self.whiteView7,self.whiteView8,self.whiteView9,self.whiteView10];
    for (int i = 0; i < self.whiteViewArr.count; i++) {
        UIView *whiteview = self.whiteViewArr[i];
        [self.dgkScrollView addSubview:whiteview];
        [whiteview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.dgkScrollView);
            make.width.mas_equalTo(ANDY_Adapta(690));
            make.height.mas_equalTo(ANDY_Adapta(215));
            make.top.mas_equalTo(ANDY_Adapta(353)+ANDY_Adapta(235)*i);
        }];
    }
    //兑换按钮
    self.hengBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hengBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hengBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hengBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hengBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hengBtn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hengBtn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hengBtn8 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hengBtn9 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hengBtn10 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hengBtnArr = @[self.hengBtn1,self.hengBtn2,self.hengBtn3,self.hengBtn4,self.hengBtn5,self.hengBtn6,self.hengBtn7,self.hengBtn8,self.hengBtn9,self.hengBtn10];
    for (int i = 0; i < self.hengBtnArr.count; i++) {
        UIButton *btn = self.hengBtnArr[i];
        UIView *whiteview = self.whiteViewArr[i];
        [btn setBackgroundImage:[UIImage imageNamed:@"dgk_duihuan2"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"dgk_duihuan1"] forState:UIControlStateDisabled];
        [btn setTitle:@"兑换" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hengBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = FontBold_(16);
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, ANDY_Adapta(10), 0)];
        [self.dgkScrollView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(whiteview.mas_top).offset(-ANDY_Adapta(14));
            make.right.mas_equalTo(whiteview.mas_right).offset(ANDY_Adapta(14));
            make.width.mas_equalTo(ANDY_Adapta(107));
            make.height.mas_equalTo(ANDY_Adapta(62));
        }];
    }
    //朝代名称
    self.dynastyName1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    self.dynastyName2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    self.dynastyName3 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    self.dynastyName4 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    self.dynastyName5 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    self.dynastyName6 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    self.dynastyName7 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    self.dynastyName8 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    self.dynastyName9 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    self.dynastyName10 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    self.titleArr = @[self.dynastyName1,self.dynastyName2,self.dynastyName3,self.dynastyName4,self.dynastyName5,self.dynastyName6,self.dynastyName7,self.dynastyName8,self.dynastyName9,self.dynastyName10];
    for (int i = 0; i < self.titleArr.count; i++) {
        UILabel *titlelabel = self.titleArr[i];
        UIView *whiteview = self.whiteViewArr[i];
        [whiteview addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ANDY_Adapta(20));
            make.top.mas_equalTo(ANDY_Adapta(25));
            make.height.mas_equalTo(ANDY_Adapta(35));
        }];
    }
    
    for (int i = 0; i < self.whiteViewArr.count; i++) {
        for (int j = 0; j < 5; j++) {
            DgkView * dgkview = [[DgkView alloc] init];
            dgkview.delegate = self;
            UIView *whiteview = self.whiteViewArr[i];
            dgkview.tag = 10*(i+1)+j+1;
            [dgkview setDgkStarLevelData:j+1];
            [whiteview addSubview:dgkview];
            [dgkview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(whiteview.mas_bottom).offset(-ANDY_Adapta(15));
                make.width.mas_equalTo(ANDY_Adapta(113));
                make.height.mas_equalTo(ANDY_Adapta(127));
                make.left.mas_equalTo(ANDY_Adapta(20)+j*ANDY_Adapta(133));
            }];
        }
    }
}
#pragma mark 数据
- (void)getData{
    [self.dataArr removeAllObjects];
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiAllusionInfo] subscribeNext:^(NSArray *array) {
        for (int i = 0; i < array.count; i++) {
            AllusionListModel *allModel = [AllusionListModel mj_objectWithKeyValues:array[i]];
            [self.dataArr addObject:allModel];
        }
        [self setData];
    } error:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark 设置数据
- (void)setData{
    //按朝代等级排序
    NSArray *arr = [self.dataArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        AllusionListModel *model1 = obj1;
        AllusionListModel *model2 = obj2;
        if (model1.dynastyVo.dynasty >model2.dynastyVo.dynasty) {
            return NSOrderedDescending;
        }else if (model1.dynastyVo.dynasty < model2.dynastyVo.dynasty){
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
        }
    }];
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:arr];
    for (int i = 0; i < self.dataArr.count; i++) {
        AllusionListModel *allModel = self.dataArr[i];
        UILabel *titleLabel = self.titleArr[i];
        titleLabel.text = allModel.dynastyVo.dynastyName;
    }
    //记录竖排能否兑换 =10能 < 10不能
    self.shuNum = 0;
    NSInteger shuNum1 = 0;
    NSInteger shuNum2 = 0;
    NSInteger shuNum3 = 0;
    NSInteger shuNum4 = 0;
    NSInteger shuNum5 = 0;
    for (int i = 0; i < self.dataArr.count; i++) {
        AllusionListModel *allModel = self.dataArr[i];
        NSArray *dgkarr = [allModel.allusions sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            DianGuKaModel *model1 = obj1;
            DianGuKaModel *model2 = obj2;
            if (model1.star >model2.star) {
                return NSOrderedDescending;
            }else if (model1.star < model2.star){
                return NSOrderedAscending;
            }else{
                return NSOrderedSame;
            }
        }];
        //记录横排能否兑换 ==5 能兑换 <5不能
        NSInteger hengNum = 0;
        for (int j = 0; j < dgkarr.count; j++) {
            DianGuKaModel *model = dgkarr[j];
            DgkView *dgkview = [self.view viewWithTag:10*(i+1)+j+1];
            [dgkview setDgkViewData:model];
            if (model.number > 0) {
                hengNum++;
            }
            if (j == 0 && model.number > 0) {
                shuNum1++;
            }
            if (j == 1 && model.number > 0) {
                shuNum2++;
            }
            if (j == 2 && model.number > 0) {
                shuNum3++;
            }
            if (j == 3 && model.number > 0) {
                shuNum4++;
            }
            if (j == 4 && model.number > 0) {
                shuNum5++;
            }
        }
        UIButton *hengbtn = self.hengBtnArr[i];
        if (hengNum == 5) {
            hengbtn.enabled = YES;
        }else{
            hengbtn.enabled = NO;
        }
    }
    if (shuNum1 == 10) {
        UILabel *shulabel = self.shuLabelArr[0];
        UIButton *shubtn = self.shuBtnArr[0];
        shulabel.text = @"已集齐1星级典故卡";
        shulabel.textColor = RGBA(254, 172, 56, 1);
        shubtn.hidden = NO;
    }else{
        UILabel *shulabel = self.shuLabelArr[0];
        UIButton *shubtn = self.shuBtnArr[0];
        shulabel.text = @"暂未集齐";
        shulabel.textColor = GrayColor;
        shubtn.hidden = YES;
    }
    if (shuNum2 == 10) {
        UILabel *shulabel = self.shuLabelArr[1];
        UIButton *shubtn = self.shuBtnArr[1];
        shulabel.text = @"已集齐2星级典故卡";
        shulabel.textColor = RGBA(254, 172, 56, 1);
        shubtn.hidden = NO;
    }else{
        UILabel *shulabel = self.shuLabelArr[1];
        UIButton *shubtn = self.shuBtnArr[1];
        shulabel.text = @"暂未集齐";
        shulabel.textColor = GrayColor;
        shubtn.hidden = YES;
    }
    if (shuNum3 == 10) {
        UILabel *shulabel = self.shuLabelArr[2];
        UIButton *shubtn = self.shuBtnArr[2];
        shulabel.text = @"已集齐3星级典故卡";
        shulabel.textColor = RGBA(254, 172, 56, 1);
        shubtn.hidden = NO;
    }else{
        UILabel *shulabel = self.shuLabelArr[2];
        UIButton *shubtn = self.shuBtnArr[2];
        shulabel.text = @"暂未集齐";
        shulabel.textColor = GrayColor;
        shubtn.hidden = YES;
    }
    if (shuNum4 == 10) {
        UILabel *shulabel = self.shuLabelArr[3];
        UIButton *shubtn = self.shuBtnArr[3];
        shulabel.text = @"已集齐4星级典故卡";
        shulabel.textColor = RGBA(254, 172, 56, 1);
        shubtn.hidden = NO;
    }else{
        UILabel *shulabel = self.shuLabelArr[3];
        UIButton *shubtn = self.shuBtnArr[3];
        shulabel.text = @"暂未集齐";
        shulabel.textColor = GrayColor;
        shubtn.hidden = YES;
    }
    if (shuNum5 == 10) {
        UILabel *shulabel = self.shuLabelArr[4];
        UIButton *shubtn = self.shuBtnArr[4];
        shulabel.text = @"已集齐5星级典故卡";
        shulabel.textColor = RGBA(254, 172, 56, 1);
        shubtn.hidden = NO;
    }else{
        UILabel *shulabel = self.shuLabelArr[4];
        UIButton *shubtn = self.shuBtnArr[4];
        shulabel.text = @"暂未集齐";
        shulabel.textColor = GrayColor;
        shubtn.hidden = YES;
    }
}

#pragma mark 横排兑换
- (void)hengBtnAction:(UIButton *)btn{
    NSInteger starNum = 0;
    if (btn == self.hengBtn1) {
        starNum = 1;
    }else if (btn == self.hengBtn2){
        starNum = 2;
    }else if (btn == self.hengBtn3){
        starNum = 3;
    }else if (btn == self.hengBtn4){
        starNum = 4;
    }else if (btn == self.hengBtn5){
        starNum = 5;
    }else if (btn == self.hengBtn6){
        starNum = 6;
    }else if (btn == self.hengBtn7){
        starNum = 7;
    }else if (btn == self.hengBtn8){
        starNum = 8;
    }else if (btn == self.hengBtn9){
        starNum = 9;
    }else if (btn == self.hengBtn10){
        starNum = 10;
    }
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiAllusionMergeWithType:@"DYNASTY" starLevel:starNum] subscribeNext:^(MergeSuccessModel *model) {
        //兑换成功 刷新ui
        [self getData];
        //限时分红兑换成功 通知首页拉取用户显示分红数据
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHLIMITTAMEDATA object:self userInfo:nil];
        FotonExchangeModel *model1 = [FotonExchangeModel new];
        model1.profitTime = model.number*60;
        LimitBonusView *limitview = [[LimitBonusView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [limitview limitBonusView];
        [limitview setLimitBonusData:model1 withType:0];
        [limitview showPopView:self];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 竖排兑换
- (void)shuBtnAction:(UIButton *)btn{
    NSInteger levelNum = 0;
    if (btn == self.shuBtn1) {
        levelNum = 1;
    }else if (btn == self.shuBtn2){
        levelNum = 2;
    }else if (btn == self.shuBtn3){
        levelNum = 3;
    }else if (btn == self.shuBtn4){
        levelNum = 4;
    }else if (btn == self.shuBtn5){
        levelNum = 5;
    }
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiAllusionMergeWithType:@"STAR" starLevel:levelNum] subscribeNext:^(MergeSuccessModel *model) {
        [self getData];
        //限时分红兑换成功 通知首页拉取用户显示分红数据
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHLIMITTAMEDATA object:self userInfo:nil];
        FotonExchangeModel *model1 = [FotonExchangeModel new];
        model1.profitTime = model.number*60;
        LimitBonusView *limitview = [[LimitBonusView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [limitview limitBonusView];
        [limitview setLimitBonusData:model1 withType:0];
        [limitview showPopView:self];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark DgkViewDelegate
- (void)diangukaPopView:(DianGuKaModel *)model{
    DianGuKaView *dianguka = [[DianGuKaView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [dianguka setData:model withType:2];
    [dianguka showPopView:self];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
