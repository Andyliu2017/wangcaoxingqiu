//
//  RecordListModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordListModel : NSObject

//数据内容
@property(nonatomic,strong) NSArray *content;
//是否有下页
@property(nonatomic,assign) BOOL hasNext;
//页号,1开始
@property(nonatomic,assign) NSInteger number;
//页尺寸,大于0
@property(nonatomic,assign) NSInteger size;


@end

NS_ASSUME_NONNULL_END
