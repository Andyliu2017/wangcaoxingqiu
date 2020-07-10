//
//  YuleModel.h
//  wangcao
//
//  Created by EDZ on 2020/6/16.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YuleModel : NSObject

//coverImg (string, optional): 封面图 ,
@property (nonatomic,copy) NSString *coverImg;
//desc (string, optional): 描述 ,
@property (nonatomic,copy) NSString *desc;
//osType (string, optional): 操作系统 = ['ALL', 'ANDROID', 'IOS']
@property (nonatomic,copy) NSString *osType;
//sort (integer, optional): 排序值 ,
@property (nonatomic,assign) NSInteger sort;
//status (integer, optional): 状态 ,
@property (nonatomic,assign) NSInteger status;
//taskCode (string, optional): 编码 = ['XIQU', 'DOWNLOAD', 'TARGET_URL', 'VIDEO', 'XIANYU', 'DUOYOU', 'HK_VIDEO', 'ZRB', 'ANSWER', 'TUIYA', 'ABX', 'XIANWAN', 'SHARE'],
@property (nonatomic,copy) NSString *taskCode;
//title (string, optional): 标题
@property (nonatomic,copy) NSString *title;


@end

NS_ASSUME_NONNULL_END
