//
//  WCWebViewController.m
//  wangcao
//
//  Created by EDZ on 2020/5/22.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WCWebViewController.h"
#import <WebKit/WebKit.h>

@interface WCWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webview;
@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,copy) NSString *openUrl;
@property (nonatomic,copy) NSString *titleStr;

@end

@implementation WCWebViewController

- (instancetype)initWithOpenUrl:(NSString *)openUrl title:(NSString *)titleStr{
    self = [super init];
    if (self) {
        _openUrl = openUrl;
        _titleStr = titleStr;
    }
    return self;
}
//清缓存
- (void)clearcache{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self clearcache];
//    self.navigationController.navigationBar.hidden = NO;
    //设置界面frame从navigationBar的下面开始计算
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];    
    self.title = self.titleStr;
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
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.view);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.openUrl]];
    [self.webview loadRequest:request];
}
#pragma WKWebViewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载");
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.webview animated:YES];
    self.hud.label.text = @"加载中...";
    [self.hud showAnimated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.hud hideAnimated:YES];
    NSLog(@"加载完成");
}
//web界面中有弹出警告框时调用
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认"  style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}
//web界面中有弹出确定框时调用
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"是"  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}
//web界面中有弹出输入框时调用
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        //textField.placeholder = defaultText;
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

@end
