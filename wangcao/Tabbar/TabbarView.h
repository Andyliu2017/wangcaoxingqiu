//
//  TabbarView.h
//  wangcao
//
//  Created by EDZ on 2020/6/1.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TabbarViewDelegate <NSObject>

- (void)tabbarAction:(NSInteger)index;

@end

@interface TabbarView : UIView

@property (nonatomic,weak) id<TabbarViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
