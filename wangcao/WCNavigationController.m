//
//  WCNavigationController.m
//  wangcao
//
//  Created by EDZ on 2020/5/8.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WCNavigationController.h"

@interface WCNavigationController ()<UINavigationControllerDelegate>
//UINavigationBarDelegate

@end

@implementation WCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.hidden = YES;
    self.delegate = self;
    //    设置导航栏的背景颜色
    [self.navigationBar setBarTintColor:NavigationBarColor];
    //    设置导航栏上的标题字体的颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //    设置返回按钮的字体的颜色
    self.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationBar.translucent = NO;//关键点   它的作用是根据UINavigationBar设置，去判定是否添加透明度。
    //去掉导航栏下面的横线
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

@end
