//
//  ReflectConfigModel.h
//  wangcao
//
//  Created by EDZ on 2020/6/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReflectConfigModel : NSObject

//attentionMatters (string, optional): 注意事项 ,
@property (nonatomic,copy) NSString *attentionMatters;
//userWithdrawConfigVoList (Array[提现配置项], optional): 提现配置项列表 ,
@property (nonatomic,strong) NSArray *userWithdrawConfigVoList;
//withdrawRate (integer, optional): 提现手续费费率万分之
@property (nonatomic,assign) NSInteger withdrawRate;

@end

NS_ASSUME_NONNULL_END
