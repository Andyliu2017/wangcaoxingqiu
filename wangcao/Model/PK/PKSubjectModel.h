//
//  PKSubjectModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKSubjectModel : NSObject

//options (Array[题库选项], optional): 选项 ,
@property (nonatomic,strong) NSArray *options;
//subjectId (integer, optional): 题目ID ,
@property (nonatomic,copy) NSString *subjectId;
//subjectInvokeId (string, optional): 题目唯一串 ,
@property (nonatomic,copy) NSString *subjectInvokeId;
//title (string, optional): 标题
@property (nonatomic,copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
