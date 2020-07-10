//
//  InvitaView.h
//  wangcao
//
//  Created by EDZ on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvitaView : UIView

//type 1有数据 2无数据
- (void)setData:(TeamNumberModel *)model withType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
