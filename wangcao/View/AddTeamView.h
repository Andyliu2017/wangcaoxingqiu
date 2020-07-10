//
//  AddTeamView.h
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^pkBlock)(NSInteger type);  //type 1 创建队伍 2 加入队伍

@interface AddTeamView : UIView

@property (nonatomic,copy) pkBlock pkblock;

- (void)showAddView;

@end

NS_ASSUME_NONNULL_END
