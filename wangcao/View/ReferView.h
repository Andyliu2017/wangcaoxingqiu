//
//  ReferView.h
//  wangcao
//
//  Created by EDZ on 2020/5/27.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReferView : UIView

- (void)showPopView:(UIViewController *)ViewController;

#pragma mark 我的邀请人
- (void)setRefreUserView;
- (void)setRefreUserData:(UserTeamModel *)model;

#pragma mark 我的好友
- (void)setFriendView;
- (void)setFriendData:(TeamNumberModel *)model;

@end

NS_ASSUME_NONNULL_END
