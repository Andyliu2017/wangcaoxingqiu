//
//  WCApiManager.h
//  wangcao
//
//  Created by EDZ on 2020/5/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <ReactiveObjC.h>
#import "WCPublicModel.h"
#import "WCLoginModel.h"
#import <YYCache.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    APICachePloy_Server = 0, //获取服务器数据
    APICachePloy_Normal = 1, //先获取缓存数据,如果没有再获取服务器数据
    APICachePloy_Cache  = 2  //获取缓存数据
} APICachePloy;

extern NSString *kHostUrl;
extern NSString *const gRelogin;
extern NSString *const kExtractMethodBank;
extern NSString *const kExtractMethodWachat;
extern NSString *const kExtractMethodAlipay;
extern NSString *const kErrorDomain;
extern NSInteger const kErrorException;

//无网络
extern NSInteger const kNotNetwordException;

@interface WCApiManager : AFHTTPSessionManager

@property (nonatomic,strong) YYCache *cache;

@property (nonatomic,assign) NSInteger sep;

///网络状态
@property (nonatomic,strong) AFNetworkReachabilityManager *networkManager;
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

//请求方式
@property(nonatomic, assign) APICachePloy cachePloy;
//登录信息
@property(nonatomic,strong) WCLoginModel *loginModel;
//系统配置信息
//@property(nonatomic,strong) SystemModel *systemModel;
//
//@property(nonatomic,strong) WinLotteryModel *winLotteryModel;
//
//@property (nonatomic ,strong) UserMessageModel *userMessageModel;
//
////系统配置信息
//@property(nonatomic,strong) FruitSystemModel *fruitsystemModel;

+ (instancetype)sharedManager;

- (void)clearUserInfo;

- (NSDictionary *)headerParameters;

- (void)getHttp:(NSString *)url dic:(NSDictionary *)parameters block:(void(^)(id sth,id sth2))block;

- (void)postHttp:(NSString *)url dic:(NSDictionary *)parameters block:(void(^)(id sth,id sth2))block;

@end

#pragma mark 登录相关
@interface WCApiManager (Login)

//微信登录
//- (RACSignal *)ApiLoginWithWX:(NSString *)authCode;

/**
 用户登录是否需要验证码
 
 @param mobile 手机号
 @return RACSignal
 */
- (RACSignal *)fetchLoginHasCodeWithMobile:(NSString *)mobile;

/**
 发送验证码
 
 @param mobile 手机号
 @return RACSignal
 */
- (RACSignal *)sendVerifyCodeWithMobile:(NSString *)mobile;


- (RACSignal *)gotoBindDic:(NSDictionary *)dic;



/// 手机号登录
/// @param mobile 手机号码
/// @param invitecode 邀请码
/// @param verifycode 验证码
/// @param wxLoginId 微信临时ID
- (RACSignal *)loginWithMobile:(NSString *)mobile
                    invitecode:(NSString *)invitecode
                    verifycode:(NSString *)verifycode
                     wxLoginId:(NSString *)wxLoginId;

/// 绑定手机号
/// @param mobile 手机号
/// @param invitecode 手机号
/// @param verifycode 验证码
- (RACSignal *)updateMobile:(NSString *)mobile
                 invitecode:(NSString *)invitecode
                 verifycode:(NSString *)verifycode;

//  发送验证码
- (RACSignal *)ApiSendVerifyCodeWithMobile:(NSString *)mobile;

@end

#pragma mark 其他
@interface WCApiManager(other)

//获取离线收益(如果返回空对象。则没有收益)
- (RACSignal *)ApiOfflineProfit;

#pragma mark 建筑
//获取朝代信息
- (RACSignal *)getFetchDynastyInfo;
//升级建筑
- (RACSignal *)updateStructure:(NSInteger)structureid;
//下一个朝代
- (RACSignal *)ApiNextDynasty:(NSInteger)dynasty;
//朝代翻篇
- (RACSignal *)ApiDynastyFanPian;
//朝代重置
- (RACSignal *)ApiDynastyReset;
//获取典故卡信息
- (RACSignal *)ApiAllusionInfo;
//兑换典故卡
- (RACSignal *)ApiAllusionMergeWithType:(NSString *)mergeType starLevel:(NSInteger)number;
//获取金币不足视频
- (RACSignal *)ApiGoldNotEnoughVideo;

#pragma mark 授权
//获取阿里授权账户
- (RACSignal *)ApiGetAliAutoAccount;

#pragma mark account用户
//获取未领取现金红包
- (RACSignal *)ApiNoReceiveCashBonus;
//领取现金红包
- (RACSignal *)ApiReceiveCashBonusWithCashId:(NSInteger)cashid;
//获取未领取福豆
- (RACSignal *)ApiNoReceiveFoton;
//领取福豆
- (RACSignal *)ApiReceiveFotonWithFotonId:(NSInteger)fotonid;

//获取金币、福豆信息
- (RACSignal *)ApiGlodAndFudou;

/// 今日分红记录
/// @param limit 每页大小
/// @param page 起始页
- (RACSignal *)fetchDateProfitRecord:(NSInteger)limit
                                page:(NSInteger)page;
/// 获取用户通信录记录
/// @param page 起始页
/// @param limit 页面大小
- (RACSignal *)fetchUserContacts:(NSInteger)page
                           limit:(NSInteger)limit;
//修改手机号
- (RACSignal *)ApiUpdateMobilePhone:(NSString *)phoneNumber code:(NSString *)code;

//获取提现配置
- (RACSignal *)ApiReflectConfig;
//获取用户账户信息
- (RACSignal *)ApiUserAccountInfo;
//获取用户实名信息
- (RACSignal *)ApiUserShiMingInfo;
//提现
- (RACSignal *)ApiWithdrawalWithPayType:(NSString *)withdrawType userBankId:(NSString *)userBankId userWithdrawConfigId:(NSInteger)userWithdrawConfigId;
//收支明细
- (RACSignal *)ApiGetIncomeDetail:(NSInteger)page limit:(NSInteger)limit;
//提现明细
- (RACSignal *)ApiGetWithdrawDetail:(NSInteger)page limit:(NSInteger)limit;
//实名
- (RACSignal *)ApiShiMing:(NSString *)name idcard:(NSString *)idcard aliAccount:(NSString *)aliAccount;

#pragma mark 抽奖
//获取抽奖列表
- (RACSignal *)fetchLotteryList;
/// 领抽奖券
- (RACSignal *)receiveVoucher;
/// 抽奖
- (RACSignal *)winLottery;

#pragma mark 排行榜
/// 获取排行榜
/// @param rankType 排行榜类型, GOLD_COINS:金币排行，PROFIT：财神果排行，EARNINGS：收益排行
- (RACSignal *)ApiFetchRank:(NSString *)rankType;



#pragma mark 签到
//签到详情
- (RACSignal *)ApiSignInInfo;
//签到
- (RACSignal *)ApiSignIn;
#pragma mark 视频
- (RACSignal *)WatchFinish:(NSString *)advertId;

#pragma mark 我的
//消息
- (RACSignal *)ApiMessage:(NSInteger)page limit:(NSInteger)limit;
//系统公告
- (RACSignal *)ApiSystemContent;

#pragma mark 淘金
//获取用户可收取金币信息
- (RACSignal *)ApiUserGold;
//收取金币
- (RACSignal *)ApiCollectGold:(NSInteger)GoldId;
//偷取金币
- (RACSignal *)ApiStealGold:(NSInteger)GoldId;
//获取可夺金币用户
- (RACSignal *)ApiTakeRedList;
//获取用户可偷金币信息
- (RACSignal *)ApiUserStealGoldInfo:(NSInteger)userid;
//获取用户红包被偷取记录 userid用户id  page页码  limit每页数据数量
- (RACSignal *)ApiStealRedLogs:(NSInteger)userid page:(NSInteger)page limit:(NSInteger)limit;

#pragma mark 战队
//用户下级/间推人数
- (RACSignal *)ApiTeamSubCount;
//未实名收益及人数
- (RACSignal *)ApiTeamUncertMoney;
//战队收益
- (RACSignal *)ApiTeamIncome;
//今日战队收益
- (RACSignal *)ApiTeamIncomeToday;
//好友列表
/*
 下级类型 1-直推 2-间推subType
 page,1开始
 size 页面大小
 */
- (RACSignal *)ApiUserFriendList:(NSInteger)subType page:(NSInteger)page size:(NSInteger)size;
//通讯录好友  type 1:已注册用户 0 未注册用户 不传所有
- (RACSignal *)ApiUserContactFriend:(NSInteger)type page:(NSInteger)page limit:(NSInteger)limit;
//同步通讯录好友 上传服务器
- (RACSignal *)ApiUserSyncContacts:(NSDictionary *)parameters;
//战友今日贡献  今日收益明细
/*
 type  1今天 2所有
 */
- (RACSignal *)ApiTeamTodayProfitDetail:(NSInteger)type page:(NSInteger)page limit:(NSInteger)limit;
//是否是合伙人
- (RACSignal *)ApiTeamPartnerInfo;

#pragma mark 任务
//获取任务列表 type  LIST:任务列表：PAPAW：泡泡池子：INDEX：首页没金币推荐
- (RACSignal *)ApiTaskList:(NSInteger)limit type:(NSString *)type;
//娱乐页面轮播信息
- (RACSignal *)ApiYuLeScrollNews;
//获取娱乐列表
- (RACSignal *)ApiYuleListWithLimit:(NSInteger)limit;

#pragma mark 答题、PK
//pk首页
- (RACSignal *)ApiPKShouYe;
//个人pk信息
- (RACSignal *)ApiPKPersonInfo;
//创建战队
- (RACSignal *)ApiPKCreateTeam;
//获取战队pk信息
- (RACSignal *)ApiPKTeamInfo;
//获取团队简单信息
- (RACSignal *)ApiPKTeamSinpleInfo:(NSInteger)teamid;
//开始挑战
- (RACSignal *)ApiPKStart:(NSString *)subType;
//获取题目
- (RACSignal *)ApiPKGetSubject:(NSString *)subType code:(NSString *)code limit:(NSInteger)limit;
//答题
- (RACSignal *)ApiPKAnswerWithCode:(NSString *)code subjectInvokeId:(NSString *)subjectInvokeId optionId:(NSInteger)optionId battleType:(NSString *)battleType;
//获取战队用户信息
- (RACSignal *)ApiPKTeamUserInfo:(NSInteger)groupId;
//获取复活卡数量
- (RACSignal *)ApiPKRebirthCount;
//加入战队
- (RACSignal *)ApiPKJoinTeamGroupid:(NSInteger)groupId;
//获取复活信息
- (RACSignal *)ApiPkRebirthInfo:(NSString *)battleType;
//复活
- (RACSignal *)ApiPKRebirtn:(NSString *)battleType;
//用户领取复活卡信息
- (RACSignal *)ApiPKRecevieCardInfo;
//领取复活卡
- (RACSignal *)ApiPKRecevieCard;
//个人pk排行
- (RACSignal *)ApiPKPersonRankInfo:(NSString *)dateStr;
//团队pk排行
- (RACSignal *)ApiPKTeamRankInfo:(NSString *)dateStr;

#pragma mark 用户
//获取用户复杂信息
- (RACSignal *)ApiUserInfo:(NSInteger)userid;
//修改用户信息
- (RACSignal *)ApiModifyUserInfoWithAvatar:(NSString *)avatar nickname:(NSString *)nickname qq:(NSString *)qq weixin:(NSString *)weixin;
//意见反馈
- (RACSignal *)ApiFeedBack:(NSString *)feedBack;
//绑定邀请码
- (RACSignal *)ApiBindInviteCode:(NSString *)invitecode;

#pragma mark 分红
//我的分红
- (RACSignal *)ApiMyBonus;
//分红进度
- (RACSignal *)ApiBonusProgress;
//平台分红
- (RACSignal *)ApiPlatformBonus;
//福豆兑换商品  商品信息
- (RACSignal *)ApiGetFotonGoodsWithPage:(NSInteger)page size:(NSInteger)size;
//福豆兑换商品
- (RACSignal *)ApiFotonExchangeGoods:(NSInteger)goodsid;
//获取福豆明细
- (RACSignal *)ApiFotonRecordWithPage:(NSInteger)page limit:(NSInteger)limit;
//获取当前用户的的限时分红列表
- (RACSignal *)ApiUserLimitBonusList;
//获取当前用户的到期的限时分红列表
- (RACSignal *)ApiUserExpireBonusList;
//今日分红记录
- (RACSignal *)ApiTodayBonusRecordWithDateStr:(NSString *)date page:(NSInteger)page limit:(NSInteger)limit;

#pragma mark 系统配置
//获取系统配置
- (RACSignal *)ApiSystemConfigs;
#pragma mark 获取用户任务完成进度列表
- (RACSignal *)ApiUserFinishTask:(NSInteger)page limit:(NSInteger)limit;
//获取用户任务完成提示列表
- (RACSignal *)ApiUserFinishTaskLog;

#pragma mark 版本更新
- (RACSignal *)ApiVersionUpdate;

@end

NS_ASSUME_NONNULL_END
