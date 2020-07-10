//
//  TabbarViewController.m
//  wangcao
//
//  Created by EDZ on 2020/5/9.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TabbarViewController.h"
#import "WCNavigationController.h"
#import "DroiyanTeamController.h"
#import "MainViewController.h"
#import "MyViewController.h"
#import "WCLoginViewController.h"
#import "TabbarView.h"
#import "WCTabBar.h"

@interface TabbarViewController ()<UITabBarControllerDelegate,TabbarViewDelegate>

@property (nonatomic, strong) NSDate *lastSelectedDate;

@property (nonatomic,strong) UIButton *MyDynastyBtn;
@property (nonatomic,strong) UIButton *myBtn;
@property (nonatomic,strong) TabbarView *customTabbarView;
@property (nonatomic,strong) UIButton *clearBtn;

@end

@implementation TabbarViewController

+(void)initialize
{
    //Tabbar不透明
    [UITabBar appearance].translucent = NO;
    //Tabbar黑色
    [UITabBar appearance].backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    //隐藏Tabbar分割线
    UIImage *clearImage = [UIImage imageWithColor:RGBA(0, 0, 0, 0)];
    [[UITabBar appearance] setShadowImage:clearImage];
    //TableView适配
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    //ScrollView适配
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WCTabBar *wctabbar = [[WCTabBar alloc] init];
    wctabbar.tabBarView.delegate = self;
    [self setValue:wctabbar forKey:@"tabBar"];
    
    self.delegate = self;
    [self addChildViewControllers];
    self.selectedIndex = 1;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self resetLogin];
    });
}

- (void)tabbarAction:(NSInteger)index{
    self.selectedIndex = index;
}

- (void)changeTabbrItem{
    [self customBtnClick:self.myBtn];
}

- (void)customBtnClick:(UIButton *)btn{
    //选中没有变化
    if (self.selectedIndex == btn.tag-10) {
        return;
    }
    //改变原按钮选中状态
    NSInteger tagnum = self.selectedIndex;
    UIButton *btn1 = [self.customTabbarView viewWithTag:10+tagnum];
    btn1.selected = NO;
    self.selectedIndex = btn.tag-10;
    btn.selected = YES;
}

- (void)addChildViewControllers
{
    WCNavigationController *one = [[WCNavigationController alloc] initWithRootViewController:[DroiyanTeamController new]];
    
    WCNavigationController *two = [[WCNavigationController alloc] initWithRootViewController:[MainViewController new]];
    
    WCNavigationController *three = [[WCNavigationController alloc] initWithRootViewController:[MyViewController new]];
    
    self.viewControllers = @[one,
                             two,
                             three];
}

- (void)addTabarItems
{
    NSArray *titleNames = @[@"战队",
                            @"我的王朝",
                            @"我的"];
    
    NSArray *normalImages = @[@"tabbar_droiyan",
                              @"tabbar_mywc",
                              @"taaabr_my"];
    
    NSArray *selectedImages = @[@"tabbar_droiyan",
                                @"tabbar_mywc",
                                @"taaabr_my"];
    
    //SNJJSELF
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        
        obj.tabBarItem.title = [titleNames objectAtIndex:idx];
        obj.tabBarItem.image = [[UIImage imageNamed:normalImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        obj.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
    
    self.tabBar.tintColor = [UIColor whiteColor];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    // 确保当前在首页界面
    if ([tabBarController.selectedViewController isEqual:[tabBarController.viewControllers firstObject]])
    {
        // ! 即将选中的页面是之前上一次选中的控制器页面
        if (![viewController isEqual:tabBarController.selectedViewController])
        {
            return YES;
        }
        // 获取当前点击时间
        NSDate *currentDate = [NSDate date];
        CGFloat timeInterval = currentDate.timeIntervalSince1970 - _lastSelectedDate.timeIntervalSince1970;
        
        // 两次点击时间间隔少于 0.5S 视为一次双击
        if (timeInterval < 0.6)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TabRefresh" object:nil userInfo:nil];
            _lastSelectedDate = [NSDate dateWithTimeIntervalSince1970:0];
            return NO;
        }
        // 若是单击将当前点击时间复制给上一次单击时间
        _lastSelectedDate = currentDate;
    }
    return YES;
}

- (void)resetLogin
{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:gRelogin object:nil] subscribeNext:^(NSNotification *x) {
        @strongify(self);
        if (![self.navigationController.viewControllers.firstObject isKindOfClass:WCLoginViewController.class])
        {
//            NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
//            WCLoginViewController *loginController = [[WCLoginViewController alloc] init];
//            loginController.navigationController.navigationBar.hidden = YES;
//            [controllers insertObject:loginController atIndex:0];
//            self.navigationController.viewControllers = controllers;
            [self.navigationController.viewControllers.firstObject removeFromParentViewController];
            WCLoginViewController *vc = [[WCLoginViewController alloc] init];
            WCNavigationController *naviVC = [[WCNavigationController alloc] initWithRootViewController:vc];
            [UIApplication sharedApplication].keyWindow.rootViewController = naviVC;
        }
        //退出登录清除用户信息
        [[WCApiManager sharedManager] clearUserInfo];
        [[MQTTHandleManager sharedManager] disconnect];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
