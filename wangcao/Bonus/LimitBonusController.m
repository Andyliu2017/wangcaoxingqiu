//
//  LimitBonusController.m
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import "LimitBonusController.h"
#import "LimitBonusCell.h"
#import "LimitBonusView.h"

@interface LimitBonusController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *LimitBonusArr;
@property (nonatomic,strong) UICollectionView *LimitBonusCollection;

@end

@implementation LimitBonusController

- (NSMutableArray *)LimitBonusArr{
    if (!_LimitBonusArr) {
        _LimitBonusArr = [NSMutableArray array];
    }
    return _LimitBonusArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NavigationBarColor;
    [self createUI];
    [self getData];
}
#pragma mark 界面
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
    UIImageView *headrImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"limit_bonus"]];
    [self.view addSubview:headrImg];
    [headrImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(spaceHeight(88));
        make.width.mas_equalTo(ANDY_Adapta(202));
        make.height.mas_equalTo(ANDY_Adapta(47));
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //同一行相邻两个cell的最小间距
    flowLayout.minimumInteritemSpacing = 0;
    //最小两行之间的间距
    flowLayout.minimumLineSpacing = 0;
    //设置CollectionView的属性
    self.LimitBonusCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.LimitBonusCollection.backgroundColor = [UIColor clearColor];
    self.LimitBonusCollection.delegate = self;
    self.LimitBonusCollection.dataSource = self;
    self.LimitBonusCollection.scrollEnabled = YES;
    self.LimitBonusCollection.bounces = NO;
    self.LimitBonusCollection.showsVerticalScrollIndicator = NO;
    [self.LimitBonusCollection registerClass:LimitBonusCell.class forCellWithReuseIdentifier:@"LimitBonusCell"];
    [self.view addSubview:self.LimitBonusCollection];
    [self.LimitBonusCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(headrImg.mas_bottom).offset(ANDY_Adapta(40));
        make.width.mas_equalTo(ANDY_Adapta(735));
        make.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark 设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
#pragma mark 设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.LimitBonusArr.count;
}
#pragma mark 设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"LimitBonusCell";
    LimitBonusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (self.LimitBonusArr.count > indexPath.row) {
        [cell setCellData:self.LimitBonusArr[indexPath.row]];
    }
    __block LimitBonusController *weakSelf = self;
    cell.exblock = ^(FotonExchangeModel * _Nonnull fotonModel) {
        [weakSelf loadExpireBonusData];
        [weakSelf getData];
    };
    return cell;
}
#pragma mark 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(ANDY_Adapta(245),ANDY_Adapta(341));
}
#pragma mark 定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
#pragma mark 定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return ANDY_Adapta(20);
}
#pragma mark 数据
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserLimitBonusList] subscribeNext:^(NSArray *array) {
        [self.LimitBonusArr removeAllObjects];
        for (int i = 0; i < array.count; i++) {
            FotonExchangeModel *model = [FotonExchangeModel mj_objectWithKeyValues:array[i]];
            [self.LimitBonusArr addObject:model];
        }
        [self.LimitBonusCollection reloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 获取限时分红结束的数据
- (void)loadExpireBonusData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiUserExpireBonusList] subscribeNext:^(NSArray *array) {
        for (int i = 0; i < array.count; i++) {
            FotonExchangeModel *fotonModel = [FotonExchangeModel mj_objectWithKeyValues:array[i]];
            LimitBonusView *expireView = [[LimitBonusView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [expireView expireBonusView];
            [expireView setExpireBonusData:fotonModel];
            [expireView showPopView:self];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
