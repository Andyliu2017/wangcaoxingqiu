//
//  AllusionListModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllusionListModel : NSObject

//allusions (Array[典故卡信息], optional): 典故卡信息 ,
@property (nonatomic,strong) NSArray *allusions;
//dynastyVo (朝代对象, optional): 朝代信息
@property (nonatomic,strong) DynastyModel *dynastyVo;

@end

NS_ASSUME_NONNULL_END
