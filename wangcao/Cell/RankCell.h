//
//  RankCell.h
//  wangcao
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RankCell : UITableViewCell

- (void)setData:(RankModel *)model index:(NSInteger)index type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
