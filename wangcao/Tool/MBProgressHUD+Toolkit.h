//
//  MBProgressHUD+Toolkit.h
//  LFBaseKit
//
//  Created by 刘峰 on 2018/10/15.
//  Copyright © 2018年 刘峰. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Toolkit)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

+ (void)showError:(NSString *)error toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

+ (void)showText:(NSString *)text toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUDForView:(UIView *)view;

@end
