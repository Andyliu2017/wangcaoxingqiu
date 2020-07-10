//
//  dianGuKaModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/16.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DianGuKaModel : NSObject

//allusionBackgroundImg (string, optional): 典故卡背景图 ,
//allusionDesc (string, optional): 典故卡描述 ,
//allusionName (string, optional): 典故卡名称 ,
//dynasty (integer, optional): 典故卡所属朝代 ,
//id (integer, optional): 典故卡ID ,
//star (integer, optional): 典故卡星级
@property (nonatomic,copy) NSString *allusionBackgroundImg;
@property (nonatomic,copy) NSString *allusionDesc;
@property (nonatomic,copy) NSString *allusionName;
@property (nonatomic,assign) NSInteger dynasty;
@property (nonatomic,assign) NSInteger dgk_id;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,assign) NSInteger star;

@end

NS_ASSUME_NONNULL_END
