//
//  TabbarView.m
//  wangcao
//
//  Created by EDZ on 2020/6/1.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TabbarView.h"
#import "SQSectorButton.h"

@interface TabbarView()

@property (nonatomic,strong) SQSectorButton *droiyanBtn;
@property (nonatomic,strong) SQSectorButton *myBtn;
@property (nonatomic,strong) SQSectorButton *MyDynastyBtn;

@end

@implementation TabbarView

- (instancetype)init{
    if (self = [super init]) {
        self.droiyanBtn = [SQSectorButton buttonWithType:UIButtonTypeCustom];
        self.droiyanBtn.tag = 10;
        self.droiyanBtn.titleLabel.font = Font_(14);
        [self.droiyanBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_droiyanBg"] forState:UIControlStateNormal];
        [self.droiyanBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_droiyanBg"] forState:UIControlStateHighlighted];
        [self.droiyanBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_droiyanBg1"] forState:UIControlStateSelected];
        [self.droiyanBtn setImage:[UIImage imageNamed:@"tabbar_droiyan"] forState:UIControlStateNormal];
        [self.droiyanBtn setImage:[UIImage imageNamed:@"tabbar_droiyan_1"] forState:UIControlStateSelected];
        [self.droiyanBtn setTitle:@"战队" forState:UIControlStateNormal];
        [self.droiyanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.droiyanBtn setTitleColor:RGBA(255, 202, 20, 1) forState:UIControlStateSelected];
        [self.droiyanBtn addTarget:self action:@selector(customBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.droiyanBtn];
        [self.droiyanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(180))];
        [self.droiyanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(200))];
        [self.droiyanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(self);
//            make.top.mas_equalTo(self.mas_top).offset(ANDY_Adapta(60));
            make.width.mas_equalTo(ANDY_Adapta(375));
            make.height.mas_equalTo(ANDY_Adapta(114));
        }];

        self.myBtn = [SQSectorButton buttonWithType:UIButtonTypeCustom];
        self.myBtn.tag = 12;
        self.myBtn.titleLabel.font = Font_(14);
        [self.myBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_myBg"] forState:UIControlStateNormal];
        [self.myBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_myBg"] forState:UIControlStateHighlighted];
        [self.myBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_myBg1"] forState:UIControlStateSelected];
        [self.myBtn setImage:[UIImage imageNamed:@"tabbar_my"] forState:UIControlStateNormal];
        [self.myBtn setImage:[UIImage imageNamed:@"tabbar_my_1"] forState:UIControlStateSelected];
        [self.myBtn setTitle:@"我的" forState:UIControlStateNormal];
        [self.myBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.myBtn setTitleColor:RGBA(255, 202, 20, 1) forState:UIControlStateSelected];
        [self.myBtn addTarget:self action:@selector(customBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.myBtn];
        [self.myBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, ANDY_Adapta(200), 0, 0)];
        [self.myBtn setImageEdgeInsets:UIEdgeInsetsMake(0, ANDY_Adapta(180), 0, 0)];
        [self.myBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(self.droiyanBtn);
//            make.top.mas_equalTo(self.mas_top).offset(ANDY_Adapta(60));
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self.droiyanBtn.mas_right);
        }];
        //我的王朝按钮
        self.MyDynastyBtn = [SQSectorButton buttonWithType:UIButtonTypeCustom];
        self.MyDynastyBtn.tag = 11;
        [self.MyDynastyBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_mywcBg"] forState:UIControlStateNormal];
        [self.MyDynastyBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_mywcBg"] forState:UIControlStateHighlighted];
        [self.MyDynastyBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_mywcBg_1"] forState:UIControlStateSelected];
        [self.MyDynastyBtn setImage:[UIImage imageNamed:@"tabbar_mywc"] forState:UIControlStateNormal];
        [self.MyDynastyBtn setTitle:@"我的王朝" forState:UIControlStateNormal];
        [self.MyDynastyBtn addTarget:self action:@selector(customBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.MyDynastyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(10))];
        [self addSubview:self.MyDynastyBtn];
        [self.MyDynastyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.myBtn.mas_bottom).offset(-ANDY_Adapta(53));
//            make.top.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(ANDY_Adapta(360));
            make.height.mas_equalTo(ANDY_Adapta(120));
        }];
//        if (![WXApi isWXAppInstalled] || [PBCache shared].memberModel.userType == 2) {
//            self.droiyanBtn.selected = YES;
//            self.MyDynastyBtn.hidden = YES;
//            [self.droiyanBtn setTitle:@"我的王朝" forState:UIControlStateNormal];
//        }else{
            self.MyDynastyBtn.selected = YES;
//        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTabbrItem) name:GOMYCONTROLLER object:nil];
    }
    return self;
}

- (void)changeTabbrItem{
    [self customBtnClick:self.myBtn];
}

- (void)customBtnClick:(SQSectorButton *)btn{
//    if (![WXApi isWXAppInstalled] || [PBCache shared].memberModel.userType == 2) {
//        if (btn == self.droiyanBtn && !self.droiyanBtn.isSelected) {
//            self.droiyanBtn.selected = YES;
//            self.myBtn.selected = NO;
//            self.MyDynastyBtn.selected = NO;
//            [self.delegate tabbarAction:1];
//        }
//        if (btn == self.myBtn && !self.myBtn.selected) {
//            self.droiyanBtn.selected = NO;
//            self.myBtn.selected = YES;
//            self.MyDynastyBtn.selected = NO;
//            [self.delegate tabbarAction:2];
//        }
//    }else{
        if (btn == self.droiyanBtn && !self.droiyanBtn.isSelected) {
            self.droiyanBtn.selected = YES;
            self.myBtn.selected = NO;
            self.MyDynastyBtn.selected = NO;
            [self.delegate tabbarAction:0];
        }
        if (btn == self.myBtn && !self.myBtn.selected) {
            self.droiyanBtn.selected = NO;
            self.myBtn.selected = YES;
            self.MyDynastyBtn.selected = NO;
            [self.delegate tabbarAction:2];
        }
        if (btn == self.MyDynastyBtn && !self.MyDynastyBtn.selected) {
            self.droiyanBtn.selected = NO;
            self.myBtn.selected = NO;
            self.MyDynastyBtn.selected = YES;
            [self.delegate tabbarAction:1];
        }
//    }
}

@end
