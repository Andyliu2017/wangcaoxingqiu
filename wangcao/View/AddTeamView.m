//
//  AddTeamView.m
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import "AddTeamView.h"

@implementation AddTeamView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        self.frame = frame;
        self.backgroundColor = RGBA(0, 0, 0, 0.75);
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.width.and.height.mas_equalTo(self);
        }];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    UIImageView *headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_select"]];
    [self addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(spaceHeight(395));
        make.width.mas_equalTo(ANDY_Adapta(528));
        make.height.mas_equalTo(ANDY_Adapta(99));
    }];
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(20) textColor:[UIColor whiteColor] text:@"请选择" Radius:0];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(headImg);
    }];
    
    UIView *yellowView1 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(196, 115, 42, 1) alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:yellowView1];
    [yellowView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImg.mas_bottom).offset(spaceHeight(68));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(169));
    }];
    UIView *yellowView2 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(254, 172, 56, 1) alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:yellowView2];
    [yellowView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImg.mas_bottom).offset(spaceHeight(58));
        make.left.and.width.and.height.mas_equalTo(yellowView1);
    }];
    
    UIImageView *createImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_createTeam"]];
    [yellowView2 addSubview:createImg];
    [createImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(103));
        make.centerY.mas_equalTo(yellowView2);
        make.width.and.height.mas_equalTo(ANDY_Adapta(84));
    }];
    UILabel *createLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(20) textColor:[UIColor whiteColor] text:@"创建自己的队伍" Radius:0];
    [yellowView2 addSubview:createLabel];
    [createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(yellowView2);
        make.left.mas_equalTo(createImg.mas_right).offset(ANDY_Adapta(27));
    }];
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createBtn addTarget:self action:@selector(createTeamAction) forControlEvents:UIControlEventTouchUpInside];
    [yellowView2 addSubview:createBtn];
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(yellowView2);
    }];
    
    UIView *violetView1 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(82, 50, 130, 1) alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:violetView1];
    [violetView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(yellowView1);
        make.top.mas_equalTo(yellowView1.mas_bottom).offset(spaceHeight(43));
    }];
    
    UIView *violetView2 = [GGUI ui_view:CGRectZero backgroundColor:RGBA(100, 83, 181, 1) alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:violetView2];
    [violetView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(violetView1);
        make.top.mas_equalTo(yellowView1.mas_bottom).offset(spaceHeight(33));
    }];
    
    UIImageView *addImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_addTeam"]];
    [violetView2 addSubview:addImg];
    [addImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(103));
        make.centerY.mas_equalTo(violetView2);
        make.width.and.height.mas_equalTo(ANDY_Adapta(84));
    }];
    UILabel *addLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(20) textColor:[UIColor whiteColor] text:@"加入已有队伍" Radius:0];
    [violetView2 addSubview:addLabel];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(violetView2);
        make.left.mas_equalTo(addImg.mas_right).offset(ANDY_Adapta(27));
    }];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addTeamAction) forControlEvents:UIControlEventTouchUpInside];
    [violetView2 addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(violetView2);
    }];
}

- (void)createTeamAction{
    [self closeAction];
    self.pkblock(1);
}
- (void)addTeamAction{
    [self closeAction];
    self.pkblock(2);
}
- (void)showAddView{
    self.hidden = NO;
}
- (void)closeAction{
    self.hidden = YES;
}

@end
