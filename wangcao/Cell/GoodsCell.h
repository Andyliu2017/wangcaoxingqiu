//
//  GoodsCell.h
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^goodsBlock)(FotonExchangeModel *fotonGoodsModel);

@interface GoodsCell : UICollectionViewCell

@property (nonatomic,copy) goodsBlock goodsblock;

- (void)setCellData:(FotonExchangeModel *)model;

@end

NS_ASSUME_NONNULL_END
