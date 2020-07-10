//
//  FotonExchangeModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FotonExchangeModel : NSObject

/**************  限时分红商品信息 ************/
//blessBean (integer, optional): 需要福豆 ,
@property (nonatomic,assign) NSInteger blessBean;
//id (integer, optional): id ,
@property (nonatomic,assign) NSInteger goods_id;
//name (string, optional): 名称 ,
@property (nonatomic,copy) NSString *name;
//stock (integer, optional): 库存 ,
@property (nonatomic,assign) NSInteger stock;
//time (integer, optional): 时长（分）
@property (nonatomic,assign) NSInteger time;


/**************** 限时分红信息 ****************/
//desc (string, optional): 描述 ,
@property (nonatomic,copy) NSString *desc;
//profitTime (integer, optional): 总分红时长(s) ,
@property (nonatomic,assign) NSInteger profitTime;
//sencondProfit (number, optional): 每秒分红的金额(保留5位小数) ,
@property (nonatomic,assign) double sencondProfit;
//surplusProfitTime (integer, optional): 剩余分红时长(s) ,
@property (nonatomic,assign) NSInteger surplusProfitTime;
//totalProfit (number, optional): 分红金额
@property (nonatomic,assign) double totalProfit;

@end

NS_ASSUME_NONNULL_END
