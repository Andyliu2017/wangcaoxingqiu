//
//  LimitBonusCell.h
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^expireBlock)(FotonExchangeModel *fotonModel);

@interface LimitBonusCell : UICollectionViewCell

@property (nonatomic,copy) expireBlock exblock;

- (void)setCellData:(FotonExchangeModel *)model;

@end

NS_ASSUME_NONNULL_END
