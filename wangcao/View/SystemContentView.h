//
//  SystemContentView.h
//  wangcao
//
//  Created by EDZ on 2020/5/30.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemContentView : UIView

- (void)showPopView:(UIViewController *)ViewController;
- (void)setContent:(NSString *)contentStr;

@end

NS_ASSUME_NONNULL_END
