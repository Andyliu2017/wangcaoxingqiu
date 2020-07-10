//
//  ShiMingController.h
//  wangcao
//
//  Created by EDZ on 2020/6/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShiMingController : WCBaseViewController
//是否已实名
@property (nonatomic,assign) BOOL isShiMing;
//实名对象
@property (nonatomic,strong) ShiMingModel *smModel;

@end

NS_ASSUME_NONNULL_END
