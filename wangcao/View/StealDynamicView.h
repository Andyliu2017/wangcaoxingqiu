//
//  StealDynamicView.h
//  wangcao
//
//  Created by liu dequan on 2020/5/18.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StealDynamicView : UIView<UITableViewDelegate,UITableViewDataSource>

- (void)showAnimation;

- (void)setData:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
