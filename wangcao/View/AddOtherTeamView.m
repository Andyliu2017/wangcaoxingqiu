//
//  AddOtherTeamView.m
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import "AddOtherTeamView.h"

@interface AddOtherTeamView()

@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) UITextField *searchField;
//所搜索的团队是否存在  存在能加入  不存在不能加入
@property (nonatomic,assign) BOOL isExist;

@property (nonatomic,strong) UIView *owerView;
@property (nonatomic,strong) UIImageView *owerImg;  //房主头像
@property (nonatomic,strong) UILabel *owerLabel;    //房主昵称
@property (nonatomic,strong) UILabel *descLabel;

@end

@implementation AddOtherTeamView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.hidden = YES;
        self.isExist = NO;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.whiteView = [GGUI ui_view:CGRectMake(ANDY_Adapta(65), spaceHeight(472), ANDY_Adapta(620), ANDY_Adapta(426)) backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.whiteView.clipsToBounds = YES;
    [self addSubview:self.whiteView];
//    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self);
//        make.top.mas_equalTo(spaceHeight(472));
//        make.width.mas_equalTo(ANDY_Adapta(620));
//        make.height.mas_equalTo(ANDY_Adapta(443));
//    }];
    
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:TitleColor text:@"请输入战队号" Radius:0];
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(ANDY_Adapta(7));
        make.height.mas_equalTo(ANDY_Adapta(126));
    }];
    
    self.searchView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1.0 cornerRadius:ANDY_Adapta(13) borderWidth:ANDY_Adapta(1) borderColor:LineColor];
    self.searchView.clipsToBounds = YES;
    [self.whiteView addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.centerX.mas_equalTo(self.whiteView);
        make.width.mas_equalTo(ANDY_Adapta(507));
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    self.searchField = [[UITextField alloc] init];
    [self.searchView addSubview:self.searchField];
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(self.searchView);
        make.width.mas_equalTo(ANDY_Adapta(394));
    }];
    
//    UIView *searchBtnView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(254, 172, 56, 1) alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
//    [self.searchView addSubview:searchBtnView];
//    [searchBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.searchField.mas_right);
//        make.top.and.bottom.and.right.mas_equalTo(self.searchView);
//    }];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    [searchBtn setImage:[UIImage imageNamed:@"pk_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searchField.mas_right);
        make.top.and.bottom.and.right.mas_equalTo(self.searchView);
    }];
    
    self.owerView = [GGUI ui_view:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), self.whiteView.frame.size.width, 1) backgroundColor:[UIColor clearColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    self.owerView.hidden = YES;
    [self.whiteView addSubview:self.owerView];
    self.owerImg = [[UIImageView alloc] init];
    self.owerImg.layer.cornerRadius = ANDY_Adapta(46);
    self.owerImg.layer.masksToBounds = YES;
    [self.owerView addSubview:self.owerImg];
    [self.owerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.owerView).offset(-ANDY_Adapta(80));
        make.top.mas_equalTo(ANDY_Adapta(10));
        make.width.and.height.mas_equalTo(ANDY_Adapta(92));
    }];
    UILabel *fangzhuLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(13) textColor:RGBA(153, 58, 20, 1) text:@"房主" Radius:0];
    [self.owerView addSubview:fangzhuLabel];
    [fangzhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.owerImg);
        make.bottom.mas_equalTo(self.owerView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(28));
    }];
    self.owerLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(13) textColor:TitleColor text:@"" Radius:0];
    [self.owerView addSubview:self.owerLabel];
    [self.owerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.owerImg.mas_top).offset(ANDY_Adapta(10));
        make.left.mas_equalTo(self.owerImg.mas_right).offset(ANDY_Adapta(30));
        make.right.mas_equalTo(self.owerView.mas_right);
        make.height.mas_equalTo(ANDY_Adapta(40));
    }];
    
    self.descLabel = [GGUI ui_label:CGRectMake(0, self.owerView.frame.size.height+ANDY_Adapta(229), self.whiteView.frame.size.width, ANDY_Adapta(100)) lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:MessageColor text:@"加入房间后今日不可更换战队" Radius:0];
    [self.whiteView addSubview:self.descLabel];
//    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(self.whiteView);
////        make.top.mas_equalTo(self.searchView.mas_bottom);
//        make.top.mas_equalTo(self.owerView.frame.size.height+ANDY_Adapta(229));
//        make.height.mas_equalTo(ANDY_Adapta(100));
//    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = Font_(16);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MessageColor forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(self.whiteView);
        make.width.mas_equalTo(ANDY_Adapta(310));
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.titleLabel.font = Font_(16);
    [commitBtn setTitle:@"加入" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    [commitBtn addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(self.whiteView);
        make.left.mas_equalTo(cancelBtn.mas_right);
        make.height.mas_equalTo(cancelBtn);
    }];
}

- (void)showAddOtherView{
    self.hidden = NO;
}
- (void)closeAction{
    self.hidden = YES;
}
- (void)searchAction{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKTeamSinpleInfo:[self.searchField.text integerValue]] subscribeNext:^(PKTeamInfoModel *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.whiteView.frame = CGRectMake(ANDY_Adapta(65), spaceHeight(472), ANDY_Adapta(620), ANDY_Adapta(546));
            self.owerView.hidden = NO;
            self.owerView.frame = CGRectMake(0, CGRectGetMaxY(self.searchView.frame), self.owerView.frame.size.width, ANDY_Adapta(120));
            [self.owerImg setImageWithURL:[NSURL URLWithString:model.ower.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
            self.descLabel.frame = CGRectMake(0, ANDY_Adapta(229)+self.owerView.frame.size.height, self.whiteView.frame.size.width, ANDY_Adapta(100));
            self.owerLabel.text = model.ower.nickName;
        });
        self.isExist = YES;
    } error:^(NSError * _Nullable error) {
        
    }];
}
//加入战队
- (void)joinAction{
    if (self.isExist) {
        self.otherblock(self.searchField.text);
        [self closeAction];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {//触摸事件中的触摸结束时会调用
    if (![self.searchField isExclusiveTouch]) {//判断点击是否在textfield和键盘以外
        [self.searchField resignFirstResponder];//收起键盘
    }
}

@end
