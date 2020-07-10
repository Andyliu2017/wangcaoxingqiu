//
//  ReflectListModel.h
//  wangcao
//
//  Created by EDZ on 2020/6/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReflectListModel : NSObject

//firstFlag (integer, optional): 是否支持首次 ,
@property (nonatomic,assign) NSInteger firstFlag;
//id (integer, optional): 主键 ,
@property (nonatomic,assign) NSInteger reflect_id;
//money (number, optional): 提现金额(元)
@property (nonatomic,assign) double money;

@end

NS_ASSUME_NONNULL_END
