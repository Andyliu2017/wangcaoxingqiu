//
//  AdSlotView.h
//  wangcao
//
//  Created by EDZ on 2020/6/10.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdHandleManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdSlotView : UIView <AdHandleManagerDelegate>

@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIView *slotView;

@property (nonatomic,strong) dispatch_source_t adTimer;

- (void)CreateSlotView:(UIViewController *)viewcontroller;

- (void)setViewBtnStatus;

@end

NS_ASSUME_NONNULL_END
