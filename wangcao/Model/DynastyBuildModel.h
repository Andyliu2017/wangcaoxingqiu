//
//  DynastyBuildModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/6.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynastyBuildModel : NSObject

@property (nonatomic,copy) NSString *backgroundImg;   //背景图
@property (nonatomic,assign) NSInteger buyNumber;   //已购买数量
@property (nonatomic,assign) NSInteger dynasty;  //最大购买数量
@property (nonatomic,assign) NSInteger build_id; //ID
@property (nonatomic,assign) BOOL unlock;   //是否已解锁
@property (nonatomic,assign) NSInteger maxNumber;  //最大购买数量
@property (nonatomic,copy) NSString *name;  //建筑名称
@property (nonatomic,assign) NSInteger nextBuyGold;  //下一次购买的金币数
@property (nonatomic,assign) NSInteger preLockNumber;  //前置解锁数量
@property (nonatomic,copy) NSString *preLockStructureCode;   //前置解锁编码['POPULATION', 'GRANARY', 'BUSINESS', 'WEAPONS']
@property (nonatomic,copy) NSString *structureCode;   //编码 = ['POPULATION', 'GRANARY', 'BUSINESS', 'WEAPONS']

@property (nonatomic,copy) NSString *process;   //建筑升级进度

@end

NS_ASSUME_NONNULL_END
