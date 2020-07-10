//
//  WCBaseViewController.m
//  wangcao
//
//  Created by liu dequan on 2020/5/8.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WCBaseViewController.h"

@interface WCBaseViewController ()

@end

@implementation WCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.topItem.title = @"";
    self.view.backgroundColor = NavigationBarColor;
    [self.navigationController.navigationBar setBarTintColor:NavigationBarColor];
    self.navigationController.navigationBar.hidden = NO;
    //设置界面frame从navigationBar的下面开始计算
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


@end
