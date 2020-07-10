//
//  WechatController.m
//  wangcao
//
//  Created by liu dequan on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WechatController.h"

@interface WechatController ()

@property (nonatomic,strong) UIImageView *wechatImg;

@end

@implementation WechatController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"官方公众号";
//    [self createUI];
    [self createNewUI];
}

- (void)createNewUI{
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(50));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(600));
    }];
    
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(40));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(600));
    }];
    
    UIImageView *wechatImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_wechat_img"]];
    [whiteView addSubview:wechatImg];
    [wechatImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(20));
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(632));
        make.height.mas_equalTo(ANDY_Adapta(316));
    }];
    [wechatImg setImageWithURL:[NSURL URLWithString:[PBCache shared].systemModel.gzhQrcodeUrl] options:YYWebImageOptionProgressive];
    
//    UIButton *btn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(16) normalColor:[UIColor whiteColor] normalText:@"复制公众号" click:^(id  _Nonnull x) {
//        if ([PBCache shared].systemModel.gzhName) {
//            UIPasteboard *paste = [UIPasteboard generalPasteboard];
//            paste.string = [PBCache shared].systemModel.gzhName;
//            [MBProgressHUD showText:@"复制成功" toView:[UIApplication sharedApplication].keyWindow afterDelay:1.0];
//        }
//    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"复制公众号" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = FontBold_(16);
    [btn setBackgroundImage:[UIImage imageNamed:@"my_wechat_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pasteAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wechatImg.mas_bottom).offset(ANDY_Adapta(20));
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(577));
        make.height.mas_equalTo(ANDY_Adapta(99));
    }];
    
    UILabel *descLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentCenter font:FontBold_(16) textColor:TitleColor text:@"微信扫一扫，关注游戏官方公众号更多福利等你来拿" Radius:0];
    [whiteView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).offset(ANDY_Adapta(30));
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(460));
    }];
}
//复制
- (void)pasteAction{
    if ([PBCache shared].systemModel.gzhName) {
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = [PBCache shared].systemModel.gzhName;
        [MBProgressHUD showText:@"复制成功" toView:self.view afterDelay:1.0];
    }
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
    UIView *borderView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:ANDY_Adapta(10) borderColor:RGBA(201, 123, 39, 1)];
    [whiteView addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView);
        make.top.mas_equalTo(spaceHeight(69));
        make.width.and.height.mas_equalTo(ANDY_Adapta(260));
    }];
    self.wechatImg = [[UIImageView alloc] init];
    [borderView addSubview:self.wechatImg];
    [self.wechatImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(borderView);
        make.width.and.height.mas_equalTo(ANDY_Adapta(240));
    }];
    UILabel *label = [GGUI ui_label:CGRectZero lines:2 align:NSTextAlignmentCenter font:FontBold_(16) textColor:TitleColor text:@"微信扫一扫，关注游戏官方公众号更多福利等你来拿" Radius:0];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(borderView.mas_bottom);
        make.bottom.mas_equalTo(whiteView);
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(498));
    }];
}

@end
