//
//  MBProgressHUD+Toolkit.m
//  LFBaseKit
//
//  Created by 刘峰 on 2018/10/15.
//  Copyright © 2018年 刘峰. All rights reserved.
//

#import "MBProgressHUD+Toolkit.h"

@implementation MBProgressHUD (Toolkit)

/**
 *  =======显示信息
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    if (view == nil){
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:16.0];
    hud.userInteractionEnabled = NO;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];  // 设置图片
    //hud.bezelView.backgroundColor = [UIColor blackColor];    //背景颜色
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

/**
 *  =======显示
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    [self show:success icon:@"success" view:view afterDelay:delay];
}

+ (void)showError:(NSString *)error toView:(UIView *)view afterDelay:(NSTimeInterval)delay{
    [self show:error icon:@"error" view:view afterDelay:delay];
}

+ (void)showText:(NSString *)text toView:(UIView *)view afterDelay:(NSTimeInterval)delay{
    [self show:text icon:nil view:view afterDelay:delay];
}


/**
 *  显示一些信息
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

/**
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [self hideHUDForView:view animated:YES];
}

//+ (void)showLoadingWithImages:(NSArray *)images status:(NSString *)status toView:(UIView *)view{
//    UIImage *image = [images lastObject];
//    UIImageView *loadingView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
//    loadingView.animationImages = images;
//    loadingView.animationDuration = images.count * 0.05;
//    [loadingView startAnimating];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.layer.shadowOffset = CGSizeMake(1, 1);
//    hud.layer.shadowColor = [UIColor blackColor].CGColor;
//    hud.layer.shadowOpacity = 0.2;
//    hud.labelFont = Font_(16);
//    hud.customView = loadingView;
//    hud.labelText = status;
//    hud.labelColor = [UIColor grayColor];
//    hud.opacity = 0.85;
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.color = [UIColor whiteColor];
//}

@end
