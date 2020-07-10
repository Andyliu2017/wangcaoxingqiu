//
//  PKAnswerModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKAnswerModel : NSObject

//msg (string, optional): 回答错误信息 ,
@property (nonatomic,copy) NSString *msg;
//right (boolean, optional): 是否回答正确
@property (nonatomic,assign) BOOL right;

@end

NS_ASSUME_NONNULL_END
