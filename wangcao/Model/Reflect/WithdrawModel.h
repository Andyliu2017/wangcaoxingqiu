//
//  WithdrawModel.h
//  wangcao
//
//  Created by EDZ on 2020/6/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawModel : NSObject

//accountName (string, optional): 账户名 ,
@property (nonatomic,copy) NSString *accountName;

//accountNo (string, optional): 银行账号 ,
@property (nonatomic,copy) NSString *accountNo;

//applyTime (string, optional): 申请时间 ,
@property (nonatomic,copy) NSString *applyTime;

//approveStatus (integer, optional): 审批状态：0待审批 1审批成功 -1审批不通过 ,
@property (nonatomic,assign) NSInteger approveStatus;

//bankId (integer, optional): 银行ID ,
@property (nonatomic,assign) NSInteger bankId;

//bankName (string, optional): 银行名称 ,
@property (nonatomic,copy) NSString *bankName;

//id (integer, optional): ID ,
@property (nonatomic,assign) NSInteger withdraw_id;

//money (integer, optional): 提现金额总含手续费单位分 ,
@property (nonatomic,assign) NSInteger money;

//payNo (string, optional): 支付流水号 ,
@property (nonatomic,copy) NSString *payNo;

//payStatus (integer, optional): 支付状态：0待银行打款 2支付成功 -1支付失败 ,
@property (nonatomic,assign) NSInteger payStatus;

//payTime (string, optional): 支付时间 ,
@property (nonatomic,copy) NSString *payTime;

//realMoney (integer, optional): 到账金额单位分 ,
@property (nonatomic,assign) NSInteger realMoney;

//remark (string, optional): 描述 ,
@property (nonatomic,copy) NSString *remark;

//serviceMoney (integer, optional): 手续费单位分 ,
@property (nonatomic,assign) NSInteger serviceMoney;

//traceNo (string, optional): 交易号 ,
@property (nonatomic,copy) NSString *traceNo;

//userId (integer, optional): 用户ID ,
@property (nonatomic,assign) NSInteger userId;

//withdrawType (integer, optional): 提现方式
@property (nonatomic,assign) NSInteger withdrawType;

@end

NS_ASSUME_NONNULL_END
