//
//  TaskCell.h
//  wangcao
//
//  Created by EDZ on 2020/5/16.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^taskBlock)(TaskDetailModel *model);

@interface TaskCell : UITableViewCell

@property (nonatomic,copy) taskBlock taskblock;

- (void)setData:(TaskDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
