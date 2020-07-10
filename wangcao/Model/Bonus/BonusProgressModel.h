//
//  BonusProgressModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/22.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BonusProgressModel : NSObject

//answerProcess (number, optional): 答题进度0-100 ,
@property (nonatomic,assign) NSInteger answerProcess;
//canDraw (boolean, optional): 是否可以领取限时分红 ,
@property (nonatomic,assign) BOOL canDraw;
//friendProcess (number, optional): 好友进度0-100 ,
@property (nonatomic,assign) NSInteger friendProcess;
//incomeProcess (number, optional): 收入进度0-100 ,
@property (nonatomic,assign) NSInteger incomeProcess;
//totalProcess (number, optional): 总进度0-100 ,
@property (nonatomic,assign) NSInteger totalProcess;
//userId (integer, optional),
@property (nonatomic,assign) NSInteger userId;
//videoProcess (number, optional): 视频进度0-100
@property (nonatomic,assign) NSInteger videoProcess;

@end

NS_ASSUME_NONNULL_END
