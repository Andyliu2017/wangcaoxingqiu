//
//  FriendCell.h
//  wangcao
//
//  Created by EDZ on 2020/5/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendCell : UITableViewCell

- (void)setData:(TeamNumberModel *)model withType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
