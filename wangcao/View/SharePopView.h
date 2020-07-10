//
//  SharePopView.h
//  wangcao
//
//  Created by liu dequan on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharePopView : UIView

- (void)showView;
- (void)setDataWithImg:(UIImage *)bgImg type:(NSInteger)type teamNum:(NSString *)teamnum nickName:(NSString *)nickName qrcode:(NSString *)qrcode;

@end

NS_ASSUME_NONNULL_END
