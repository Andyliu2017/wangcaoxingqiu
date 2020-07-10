//
//  YinSiView.m
//  wangcao
//
//  Created by EDZ on 2020/6/1.
//  Copyright © 2020 andy. All rights reserved.
//

#import "YinSiView.h"
#import <WebKit/WebKit.h>

@interface YinSiView()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) UIView *yinsiView;
@property (nonatomic,strong) WKWebView *webview;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation YinSiView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self setSubview];
    }
    return self;
}

- (void)setSubview{
    self.yinsiView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    self.yinsiView.clipsToBounds = YES;
    [self addSubview:self.yinsiView];
    [self.yinsiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(ANDY_Adapta(330));
        make.width.mas_equalTo(ANDY_Adapta(672));
        make.height.mas_equalTo(ANDY_Adapta(812));
    }];
    
    UIButton *closeBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(0) normalColor:[UIColor clearColor] normalText:@"" click:^(id  _Nonnull x) {
        [self closeAction];
        [self.delegate noAgreeYinsiBack];
    }];
    [closeBtn setImage:[UIImage imageNamed:@"login_ys_close"] forState:UIControlStateNormal];
    [self.yinsiView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(30));
        make.right.mas_equalTo(-ANDY_Adapta(30));
        make.width.and.height.mas_equalTo(ANDY_Adapta(30));
    }];
    
    UILabel *titleLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(18) textColor:TitleColor text:@"用户协议及隐私条款" Radius:0];
    [self.yinsiView addSubview:titleLabel1];
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(46));
        make.top.mas_equalTo(ANDY_Adapta(80));
    }];
    self.titleLabel = titleLabel1;
    
    UIButton *noAgreeBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(16) normalColor:GrayColor normalText:@"不同意" click:^(id  _Nonnull x) {
        [self closeAction];
        [self.delegate noAgreeYinsiBack];
    }];
    [noAgreeBtn setBackgroundColor:[UIColor whiteColor]];
    [self.yinsiView addSubview:noAgreeBtn];
    [noAgreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(self.yinsiView);
        make.height.mas_equalTo(ANDY_Adapta(103));
        make.width.mas_equalTo(ANDY_Adapta(336));
    }];
    
    UIButton *agreeBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(16) normalColor:[UIColor whiteColor] normalText:@"同意" click:^(id  _Nonnull x) {
        [self closeAction];
        [self.delegate agreeYinsiBack];
    }];
    [agreeBtn setBackgroundColor:RankColor];
    [self.yinsiView addSubview:agreeBtn];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(noAgreeBtn.mas_right);
        make.bottom.and.right.mas_equalTo(self.yinsiView);
        make.height.mas_equalTo(ANDY_Adapta(103));
    }];
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 1;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.allowsInlineMediaPlayback = YES;
    self.webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webview.backgroundColor = [UIColor whiteColor];
    self.webview.UIDelegate = self;
    self.webview.navigationDelegate = self;
    [self.yinsiView addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.yinsiView);
        make.top.mas_equalTo(titleLabel1.mas_bottom).offset(ANDY_Adapta(50));
        make.width.mas_equalTo(ANDY_Adapta(582));
        make.bottom.mas_equalTo(noAgreeBtn.mas_top).offset(-ANDY_Adapta(50));
    }];
}
#pragma WKWebViewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载");
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.webview animated:YES];
//    self.hud.label.text = @"加载中...";
//    [self.hud showAnimated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [self.hud hideAnimated:YES];
    NSLog(@"加载完成");
}

- (void)setWebViewUrl:(NSString *)webUrl withTitle:(NSString *)title{
    self.titleLabel.text = title;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]];
    [self.webview loadRequest:request];
}

- (void)closeAction{
    [UIView animateWithDuration:0.6f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.yinsiView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
/**
 添加Alert入场动画
 @param alert 添加动画的View
 */
- (void)showWithAlert:(UIView*)alert
{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.6;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

@end
