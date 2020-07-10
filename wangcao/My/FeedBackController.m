//
//  FeedBackController.m
//  wangcao
//
//  Created by liu dequan on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import "FeedBackController.h"

@interface FeedBackController ()

@property (nonatomic,strong) UITextView *textView;

@end

@implementation FeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    [self createUI];
}
- (void)createUI{
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(82, 50, 130, 1) alpha:1 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(spaceHeight(43));
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(540));
    }];
    
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(spaceHeight(33));
        make.width.and.height.mas_equalTo(blackView);
    }];
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"反馈意见" Radius:0];
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(5));
        make.right.mas_equalTo(whiteView);
        make.height.mas_equalTo(ANDY_Adapta(85));
        make.width.mas_equalTo(ANDY_Adapta(628));
    }];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_back"]];
    [whiteView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel);
        make.right.mas_equalTo(titleLabel.mas_left);
        make.width.and.height.mas_equalTo(ANDY_Adapta(27));
    }];
    self.textView = [[UITextView alloc] init];
    self.textView.layer.cornerRadius = ANDY_Adapta(20);
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    self.textView.layer.masksToBounds = YES;
    [whiteView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.width.mas_equalTo(ANDY_Adapta(640));
        make.height.mas_equalTo(ANDY_Adapta(413));
    }];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"rank_invite"] forState:UIControlStateNormal];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(blackView.mas_bottom).offset(ANDY_Adapta(41));
        make.width.mas_equalTo(ANDY_Adapta(642));
        make.height.mas_equalTo(ANDY_Adapta(110));
    }];
}

- (void)commitAction{
    if (![self.textView.text isNotBlank]) {
        [MBProgressHUD showText:@"反馈信息不能为空!" toView:self.view afterDelay:2.0];
        return;
    }
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiFeedBack:self.textView.text] subscribeNext:^(id  _Nullable x) {
        [MBProgressHUD showText:@"你的意见已提交,谢谢您的反馈" toView:[UIApplication sharedApplication].keyWindow afterDelay:2.0];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError * _Nullable error) {
        
    }];
}

@end
