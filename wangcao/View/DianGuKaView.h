//
//  DianGuKaView.h
//  wangcao
//
//  Created by EDZ on 2020/5/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DianGuKaView : UIView

- (void)showPopView:(UIViewController *)ViewController;
//type 1  收下典故卡   2 确定
- (void)setData:(DianGuKaModel *)model withType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
