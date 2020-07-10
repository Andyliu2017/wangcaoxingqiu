//
//  AppDelegate.m
//  wangcao
//
//  Created by liu dequan on 2020/4/29.
//  Copyright © 2020 andy. All rights reserved.
//

#import "AppDelegate.h"
#import "WCNavigationController.h"
#import "WCLoginViewController.h"
#import "TabbarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//金币  k m g t p e b aa bb cc dd
//app密钥：E623BBD8FDD844F9BC71A3514054F4BD
//com.hctl.wangchaoxqiu

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化背景音乐 开启
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *bg_switch = [def valueForKey:BACKGROUNDMUSIC];
    if (bg_switch == nil) {
        [def setValue:@"1" forKey:BACKGROUNDMUSIC];
    }
    [def synchronize];
    //微信
    [[APHandleManager sharedManager] registerHandle];
    //穿山甲
    [[AdHandleManager sharedManager] registerBUAD];
    //sigmob
    [[AdHandleManager sharedManager] registerSigmob];
    //多游
    [[YLManager sharedManager] registerDyAd];
    //推啊
    [[YLManager sharedManager] registerTuia];
    
    //获取系统配置
    [self getSystemConfigs];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self showRootViewController];
    [self.window makeKeyAndVisible];
    
    [[AdHandleManager sharedManager] playSplashVideoWithBUAD:self.window];
//    [[AdHandleManager sharedManager] playSplashVideoWithGDT];
    
    return YES;
}
- (void)showRootViewController{
    if ([WCApiManager sharedManager].loginModel && [WCApiManager sharedManager].loginModel.isLogin)
    {
        [PBCache shared].memberModel = [WCApiManager sharedManager].loginModel;
        NSLog(@"%@",[WCApiManager sharedManager].loginModel );
        //之前登录过账号
        TabbarViewController *vc = [[TabbarViewController alloc] init];
        WCNavigationController *naviVC = [[WCNavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = naviVC;
    }
    else
    {
        WCLoginViewController *vc = [[WCLoginViewController alloc] init];
        WCNavigationController *naviVC = [[WCNavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = naviVC;
    }
}

- (void)getSystemConfigs{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiSystemConfigs] subscribeNext:^(SystemModel *model) {
        [PBCache shared].systemModel = model;
        //系统配置获取成功 通知去连接mqtt
        [[NSNotificationCenter defaultCenter] postNotificationName:MQTTCLIENTCONNECT object:self userInfo:nil];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [[APHandleManager sharedManager] handleOpenURL:url];;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[APHandleManager sharedManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[APHandleManager sharedManager] handleOpenURL:url];
}

@end
