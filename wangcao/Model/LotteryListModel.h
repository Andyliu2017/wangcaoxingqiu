//
//  LotteryListModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/26.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryListModel : NSObject

//lotteryLists (Array[奖项信息], optional): 抽奖选项 ,
@property (nonatomic,strong) NSArray *lotteryLists;
//remainRecevieVoucherNum (integer, optional): 剩余领券次数 ,
@property (nonatomic,assign) NSInteger remainRecevieVoucherNum;
//remainVoucher (integer, optional): 剩余抽奖次数
@property (nonatomic,assign) NSInteger remainVoucher;

@end

NS_ASSUME_NONNULL_END
