//
//  FotonShopController.m
//  wangcao
//
//  Created by EDZ on 2020/5/22.
//  Copyright © 2020 andy. All rights reserved.
//

#import "FotonShopController.h"
#import "GoodsCell.h"
#import "LimitBonusView.h"
#import "FotonRecordController.h"

@interface FotonShopController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *goodsArr;
@property (nonatomic,strong) UICollectionView *goodsCollection;
//限时分红
@property (nonatomic,strong) LimitBonusView *limitView;

@end

@implementation FotonShopController

- (NSMutableArray *)goodsArr{
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NavigationBarColor;
    [self createUI];
    [self loadData];
}

- (void)createUI{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"luck_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(23));
        make.top.mas_equalTo(ANDY_Adapta(88));
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    UIImageView *headrImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foton_title"]];
    [self.view addSubview:headrImg];
    [headrImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(spaceHeight(88));
        make.width.mas_equalTo(ANDY_Adapta(202));
        make.height.mas_equalTo(ANDY_Adapta(47));
    }];
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_arrow"]];
    [self.view addSubview:arrowImg];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headrImg);
        make.right.mas_equalTo(-ANDY_Adapta(27));
        make.width.and.height.mas_equalTo(ANDY_Adapta(30));
    }];
    UILabel *mingxiLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(13) textColor:[UIColor whiteColor] text:@"明细" Radius:0];
    [self.view addSubview:mingxiLabel];
    [mingxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrowImg.mas_left).offset(-ANDY_Adapta(5));
        make.centerY.mas_equalTo(arrowImg);
        make.height.mas_equalTo(ANDY_Adapta(40));
    }];
    UIButton *mingxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mingxiBtn addTarget:self action:@selector(mingxiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mingxiBtn];
    [mingxiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(mingxiLabel);
        make.right.mas_equalTo(arrowImg.mas_right);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //同一行相邻两个cell的最小间距
    flowLayout.minimumInteritemSpacing = 0;
    //最小两行之间的间距
    flowLayout.minimumLineSpacing = 0;
    //设置CollectionView的属性
    self.goodsCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.goodsCollection.backgroundColor = [UIColor clearColor];
    self.goodsCollection.delegate = self;
    self.goodsCollection.dataSource = self;
    self.goodsCollection.scrollEnabled = YES;
    self.goodsCollection.bounces = NO;
    self.goodsCollection.showsVerticalScrollIndicator = NO;
    [self.goodsCollection registerClass:GoodsCell.class forCellWithReuseIdentifier:@"GoodsCell"];
    [self.view addSubview:self.goodsCollection];
    [self.goodsCollection mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(headrImg.mas_bottom).offset(ANDY_Adapta(40));
//        make.width.mas_equalTo(ANDY_Adapta(726));
        make.bottom.mas_equalTo(self.view);
        make.left.and.right.mas_equalTo(self.view);
    }];
}
//福豆明细
- (void)mingxiAction{
    FotonRecordController *fotonVc = [[FotonRecordController alloc] init];
    [self.navigationController pushViewController:fotonVc animated:YES];
}
#pragma mark 数据
- (void)loadData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiGetFotonGoodsWithPage:1 size:10] subscribeNext:^(WCBaseModel *model) {
        for (int i = 0; i < model.content.count; i++) {
            FotonExchangeModel *goodsModel = [FotonExchangeModel mj_objectWithKeyValues:model.content[i]];
            [self.goodsArr addObject:goodsModel];
        }
        [self.goodsCollection reloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
#pragma mark 设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsArr.count;
}
#pragma mark 设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"GoodsCell";
    GoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (self.goodsArr.count > indexPath.row) {
        [cell setCellData:self.goodsArr[indexPath.row]];
    }
    __block FotonShopController *weakSelf = self;
    cell.goodsblock = ^(FotonExchangeModel * _Nonnull fotonGoodsModel) {
        [weakSelf exchangeGoods:fotonGoodsModel];
    };
    return cell;
}
#pragma mark 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(SCREENWIDTH/2.0,ANDY_Adapta(515));
}
#pragma mark 定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
#pragma mark 定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return ANDY_Adapta(20);
}

#pragma mark 兑换限时分红玉玺
- (void)exchangeGoods:(FotonExchangeModel *)goodsmodel{
    self.limitView = [[LimitBonusView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.limitView limitBonusView];
    [self.limitView setLimitBonusData:goodsmodel withType:1];
    [self.limitView showPopView:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHLIMITTAMEDATA object:self userInfo:nil];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
