//
//  PaopaoButton.h
//  wangcao
//
//  Created by EDZ on 2020/6/2.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaopaoButton : UIButton

//金币、红包id
@property (nonatomic,assign) NSInteger redId;
//是否可以偷取
@property (nonatomic,assign) BOOL stealFlag;

//任务类型
@property (nonatomic,copy) NSString *taskcode;

@end

NS_ASSUME_NONNULL_END
