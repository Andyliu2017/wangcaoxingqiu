//
//  RecviedRedModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/13.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecviedRedModel : NSObject

//用户红包被收取model
/*
 amount (number, optional): 收取金额 ,
 createTime (string, optional): 收取时间 ,
 id (integer, optional): 被收取记录ID ,
 nickName (string, optional): 收取人昵称 ,
 type (integer, optional): 0:待拆红包、1：现金
 */
@property (nonatomic,assign) NSInteger amount;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,assign) NSInteger red_id;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
