//
//  FotonCell.h
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FotonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FotonCell : UITableViewCell

//福豆
- (void)setData:(FotonModel *)model;
//资金明细
- (void)setMoneyDetailData:(MoneyRecordModel *)model;

@end

NS_ASSUME_NONNULL_END
