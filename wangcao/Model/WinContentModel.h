//
//  WinContentModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WinContentModel : NSObject

@property (nonatomic ,strong) NSString *icon;
@property (nonatomic ,assign) NSInteger luck_Id;
@property (nonatomic ,strong) NSString *name;
//type (integer, optional): 0:金币 1:宝箱 2:福豆
@property (nonatomic ,assign) NSInteger type;

//下标
@property (nonatomic,assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
