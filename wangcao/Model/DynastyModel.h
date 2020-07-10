//
//  DynastyModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/6.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynastyModel : NSObject

@property (nonatomic,copy) NSString *animationUrl;  //动画url
@property (nonatomic,copy) NSString *backgroundImg; //朝代背景图
@property (nonatomic,assign) NSInteger dynasty;  //朝代编号
@property (nonatomic,copy) NSString *dynastyName;  //朝代名称
@property (nonatomic,copy) NSString *process;    //朝代中的经验升级进度
@property (nonatomic,assign) NSInteger status;  //状态：0:当前朝代升级中 1:可以进行跨一下朝代 2:可以重置朝代
@property (nonatomic,strong) NSArray *structures;  //(Array[朝代建筑物信息], optional): 建筑信息
@property (nonatomic,assign) double outGold;  //朝代产出

@end

NS_ASSUME_NONNULL_END
