//
//  AddOtherTeamView.h
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^otherBlock)(NSString *groupId);

@interface AddOtherTeamView : UIView

@property (nonatomic,copy) otherBlock otherblock;

- (void)showAddOtherView;

@end

NS_ASSUME_NONNULL_END
