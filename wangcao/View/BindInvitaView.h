//
//  BindInvitaView.h
//  wangcao
//
//  Created by EDZ on 2020/5/25.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^bindBlock)(void);

@interface BindInvitaView : UIView

@property (nonatomic,copy) bindBlock bindblock;

- (void)showPopView:(UIViewController *)ViewController;

@end

NS_ASSUME_NONNULL_END
