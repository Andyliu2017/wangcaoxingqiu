//
//  DgkView.h
//  wangcao
//
//  Created by EDZ on 2020/5/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DgkViewDelegate <NSObject>

- (void)diangukaPopView:(DianGuKaModel *)model;

@end

@interface DgkView : UIView

@property (nonatomic,weak) id<DgkViewDelegate> delegate;

@property (nonatomic,strong) DianGuKaModel *model;

- (void)setSubView;
- (void)setDgkStarLevelData:(NSInteger)starlevel;
- (void)setDgkViewData:(DianGuKaModel *)model;

@end

NS_ASSUME_NONNULL_END
