//
//  SystemModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/22.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SystemModel : NSObject

//agreementUrl (string, optional): 用户协议链接 ,
@property (nonatomic,copy) NSString *agreementUrl;

//appStartAdPic (string, optional): 启动广告 ,
@property (nonatomic,copy) NSString *appStartAdPic;

//bankServiceCharge (银行手续费信息, optional): 银行卡提现手续费 ,
@property (nonatomic,strong) BankInfoModel *bankServiceCharge;

//bankWithdrawDesc (string, optional): 银行卡提现描述语 ,
@property (nonatomic,copy) NSString *bankWithdrawDesc;

//bankWithdrawMaxMoney (integer, optional): 银行卡提现最大金额（元） ,
@property (nonatomic,assign) NSInteger bankWithdrawMaxMoney;

//bankWithdrawMinMoney (integer, optional): 银行卡提现最小金额（元） ,
@property (nonatomic,assign) NSInteger bankWithdrawMinMoney;

//battleRewardRuleUrl (string, optional): 决战-奖励规则链接 
@property (nonatomic,copy) NSString *battleRewardRuleUrl;

//certFee (integer, optional): 实名认证金额（分） ,
@property (nonatomic,assign) NSInteger certFee;

//friendsPlayRule (string, optional): 果友团玩法规则 ,
@property (nonatomic,copy) NSString *friendsPlayRule;

//helpCenterUrl (string, optional): 帮助中心 ,
@property (nonatomic,copy) NSString *helpCenterUrl;

//indexPlayRule (string, optional): 首页玩法规则 ,
@property (nonatomic,copy) NSString *indexPlayRule;

//kf400 (string, optional): 客服电话 ,
@property (nonatomic,copy) NSString *kf400;

//kfUrl (string, optional): 客服跳转链接 ,
@property (nonatomic,copy) NSString *kfUrl;

//levelUrl (string, optional): 等级页面链接 ,
@property (nonatomic,copy) NSString *levelUrl;

//mqttIp (string, optional): mqttIP地址 ,
@property (nonatomic,copy) NSString *mqttIp;

//mqttPort (string, optional): mqtt端口 ,
@property (nonatomic,copy) NSString *mqttPort;

//newsUrl (string, optional): 资讯跳转H5地址 ,
@property (nonatomic,copy) NSString *newsUrl;

//privacyAgreementUrl (string, optional): 隐私协议链接 ,
@property (nonatomic,copy) NSString *privacyAgreementUrl;

//profitInfoUrl (string, optional): 玉玺分红说明 ,
@property (nonatomic,copy) NSString *profitInfoUrl;

//qqGroupAndroidConfig (string, optional): 安卓跳转QQ群配置 ,
@property (nonatomic,copy) NSString *qqGroupAndroidConfig;

//qqGroupIosConfig (string, optional): IOS跳转QQ群配置 ,
@property (nonatomic,copy) NSString *qqGroupIosConfig;

//qqGroupNumber (string, optional): QQ群号 ,
@property (nonatomic,copy) NSString *qqGroupNumber;

//rechargeLower (string, optional): 充值金额下限 ,
@property (nonatomic,copy) NSString *rechargeLower;

//rechargeShowHide (string, optional): 充值自定义显示状态 true 显示，false 不显示 ,
@property (nonatomic,copy) NSString *rechargeShowHide;

//rechargeUpper (string, optional): 充值金额上限 ,
@property (nonatomic,copy) NSString *rechargeUpper;

//shareToXcx (boolean, optional): 是否分享跳转小程序 ,
@property (nonatomic,assign) BOOL shareToXcx;

//siginSendScore (integer, optional): 签到送多少积分 ,
@property (nonatomic,assign) NSInteger siginSendScore;

//speedScore (integer, optional): 加速消耗积分(>=0的整数) ,
@property (nonatomic,assign) NSInteger speedScore;

//speedScoreByuser (integer, optional): 转拍加速消耗积分(>=0的整数) ,
@property (nonatomic,assign) NSInteger speedScoreByuser;

//systemNotice (string, optional): 系统公告 ,
@property (nonatomic,copy) NSString *systemNotice;

//withdrawBindBankNumber (integer, optional): 系统绑定银行卡数
@property (nonatomic,assign) NSInteger withdrawBindBankNumber;

//gzhName (string, optional): 公众号名称 ,
@property (nonatomic,copy) NSString *gzhName;

//gzhQrcodeUrl  公众号二维码链接 ,
@property (nonatomic,copy) NSString *gzhQrcodeUrl;

@end

NS_ASSUME_NONNULL_END
