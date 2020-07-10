//
//  MessageCell.h
//  wangcao
//
//  Created by EDZ on 2020/5/8.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *contentLabel;

- (void)setMessageData:(MessageModel *)model;

@end

NS_ASSUME_NONNULL_END
