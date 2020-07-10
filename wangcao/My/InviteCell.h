//
//  InviteCell.h
//  wangcao
//
//  Created by EDZ on 2020/6/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^inviteBlock)(void);

@interface InviteCell : UITableViewCell

@property (nonatomic,copy) inviteBlock inviteblock;

- (void)setData:(InviteModel *)model;

@end

NS_ASSUME_NONNULL_END
