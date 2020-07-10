//
//  StealView.h
//  wangcao
//
//  Created by EDZ on 2020/5/13.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StealView : UIView

@property (nonatomic,strong) UIImageView *borderImg;  //边框
@property (nonatomic,strong) UILabel *currentLabel;  //当前
@property (nonatomic,strong) UIImageView *handImg;   //手
@property (nonatomic,assign) BOOL isSteal;   //是否能偷取
@property (nonatomic,assign) BOOL isCurrent;  //是否是当前选中状态

@end

NS_ASSUME_NONNULL_END
