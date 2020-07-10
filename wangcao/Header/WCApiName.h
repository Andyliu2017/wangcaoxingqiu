//
//  WCApiName.h
//  wangcao
//
//  Created by EDZ on 2020/5/4.
//  Copyright © 2020 andy. All rights reserved.
//

#ifndef WCApiName_h
#define WCApiName_h

//微信登陆，通过authcode登陆
static NSString *WeChatLogin_URL = @"/login/loginByWxCode";
/// 手机号号码登录
static NSString *iPhoneLogin_URL = @"/login/loginByMobile";
//发送验证码
static NSString *SendVerifyCode_URL = @"/login/sendVerifyCode";
//获取离线收益
static NSString *OfflineProfit_URL = @"/login/fetchOfflineEarnings";
//修改手机号
static NSString *UpdateMobilePhone_URL = @"/login/updateMobile";
#pragma mark dynasty朝代
//我的朝代信息
static NSString *FetchDynasty_URL = @"/dynasty/fetchMyDynasty";
//升级建筑
static NSString *UpdateStructure_URL = @"/dynasty/upgradeStructure";
//下一个朝代
static NSString *NextDynasty_URL = @"/dynasty/getNextDynastyByDynasty";
//朝代翻篇
static NSString *DynastyFanPian_URL = @"/dynasty/goNextDynasty";
//朝代重置
static NSString *DynastyReset_URL = @"/dynasty/resetDynasty";
//典故卡信息
static NSString *Allusion_URL = @"/dynasty/fetchUserAllusionsByUid";
//典故卡兑换
static NSString *AllusionMerge_URL = @"/dynasty/allusionMerge";
//获取金币不足视频
static NSString *GoldNotEnough_URL = @"/dynasty/fetchAdVideo";

#pragma mark 授权
static NSString *AliAutoAccount_URL = @"/auth/getAliStsRole";

#pragma mark account用户
//金币、福豆信息
static NSString *GoldAndFudou_URL = @"/account/getGoldAndBlessBeanByUid";
//获取未领取现金红包
static NSString *NoReceiveCashBonus_URL = @"/account/fetchNoAcquireMoney";
//领取现金红包
static NSString *ReceiveCashBonus_URL = @"/account/acquireMoney";
//获取未领取福豆
static NSString *NoReceiveFoton_URL = @"/account/fetchNoAcquireBlessBean";
//领取福豆
static NSString *ReceiveFoton_URL = @"/account/acquireBlessBean";
//获取提现配置
static NSString *ReflectConfig_URL = @"/account/fetchWithDrawInfo";
//获取用户账户信息
static NSString *UserAccount_URL = @"/account/getAccountByUid";
//获取用户实名信息
static NSString *UserShiMing_URL = @"/user/fetchUserCertInfo";
//提现
static NSString *Withdrawal_URL = @"/account/withdraw2";
//收支明细
static NSString *IncomeDetail_URL = @"/account/fetchMoneyLogs";
//提现明细
static NSString *WithdrawDetail_URL = @"/account/getWithdrawList";
//实名
static NSString *ShiMing_URL = @"/user/saveUserCert";

//今日分红记录
static NSString *FetchDateProfitRecord_URL = @"/fruit/fetchDateProfitRecord";
//获取用户通信录记录
static NSString *FetchUserContacts_RUL = @"/user/fetchUserContacts";
// 抽奖
// 获取奖项列表
static NSString *LotteryList_URL = @"/lottery/fetchLotteryList";
//领抽奖卷
static NSString *ReceiveVoucher_URL = @"/lottery/receiveVoucher";
//抽奖
static NSString *WinLottery_URL = @"/lottery/winLottery";
//获取排行榜
static NSString *FetchRank_URL = @"/rank/fetchRank";
//签到详情
static NSString *SignInInfo_URL = @"/user/signinInfo";
//签到
static NSString *SignIn_URL = @"/user/signin";
/// 广告看完回调
static NSString *WatchFinish_URL = @"/advert/watchFinish";


//消息
static NSString *Message_URL = @"/message/fetchUserMessages";
//系统公告
static NSString *SystemContent_URL = @"/message/fetchUserNotices";


//获取用户可收金币信息
static NSString *UserPick_URL = @"/stealPool/fetchUserPickPools";
//收取金币
static NSString *PickRed_URL = @"/stealPool/pickRedPack";
//偷取红包
static NSString *StealRed_URL = @"/stealPool/stealRedPack";
//可夺红包名单
static NSString *TakeRedList_URL = @"/stealPool/fetchStealPoolMembers";
//获取用户可偷金币信息
static NSString *StealUserGold_URL = @"/stealPool/fetchUserStealPools";
//获取用户红包被偷取记录
static NSString *StealRedLogs_URL = @"/stealPool/fetchUserStealPoolLogs";

#pragma mark 战队
//用户下级/间推人数
static NSString *TeamSubCount_url = @"/team/fetchSubCount";
//未实名收益及人数
static NSString *TeamUncertMoney_URL = @"/team/fetchUncertMoney";
//战队收益
static NSString *TeamTotalIncome_URL = @"/team/fetchCurrentStage";
//今日战队收益
static NSString *TeamIncomeToday_URL = @"/team/fetchTodayProfit";
//好友列表
static NSString *TeamUserFriend_URL = @"/team/fetchMyTeamUsers";
//通讯录好友
static NSString *TeamContactFriend_URL = @"/team/fetchUserContacts";
//同步通讯录好友
static NSString *TeamSyncContacts_URL = @"/user/syncContacts";
//战友今日贡献
static NSString *TeamTodayProfit_URL = @"/team/fetchProfitListBySub";
//是否是合伙人
static NSString *TeamPartner_URL = @"/team/fetchIsPartner";

#pragma mark 任务
//任务列表
static NSString *TaskList_URL = @"/task/fetchTaskDailyList";
//娱乐页面轮播信息
static NSString *YuLeScrollNews_URL = @"/task/fetchFunScrollingNews";
//获取娱乐列表
static NSString *YuLeList_URL = @"/task/fetchTaskFunList";

#pragma mark 答题、PK
//pk首页
static NSString *PKShouYe_URL = @"/battle/fetchBattleInfo";
//个人pk信息
static NSString *PKPersonInfo_URL = @"/battle/fetchBattlePersonalByUid";
//创建战队
static NSString *PKTeamCreate_URL = @"/battle/createGroup";
//获取团队PK信息
static NSString *PKTeamInfo_URL = @"/battle/fetchBattleGroupByUid";
//获取团队简单信息
static NSString *PKTeamSimpleInfo_URL = @"/battle/fetchBattleGroupTinyByGid";
//开始挑战
static NSString *PKStartBattle_URL = @"/battle/enterBattle";
//获取题目
static NSString *PKGetSubject_URL = @"/battle/fetchBattleSubjects";
//答题
static NSString *PKAnswer_URL = @"/battle/answer";
//获取团队用户信息
static NSString *PKTeamUserInfo_URL = @"/battle/fetchBattleGroupUsersByGid";
//获取复活卡数量
static NSString *PKRebirthCount_URL = @"/battle/fetchUserRebirthCount";
//加入战队
static NSString *PKJoinTeam_URL = @"/battle/joinGroup";
//获取复活信息
static NSString *PKRebirthInfo_URL = @"/battle/fetchUserRebirthInfo";
//复活
static NSString *PKRebirth_URL = @"/battle/rebirth";
//用户领取复活卡信息
static NSString *PKRecevieCardInfo_URL = @"/battle/fetchReceiveRebirthVo";
//领取复活卡
static NSString *PKRecevieCard_URL = @"/battle/fetchReceiveAdVo";
//个人排名信息
static NSString *PKPersonRank_URL = @"/battle/fetchPersonnalRank";
//团队排名信息
static NSString *PKTeamRank_URL = @"/battle/fetchGroupRank";

#pragma mark 用户
static NSString *UserInfo_URL = @"/user/fetchFullUser";
//修改用户信息
static NSString *ModifyUserInfo_URL = @"/user/updateUser";
//意见反馈
static NSString *FeedBack_URL = @"/user/userOpinion";
//绑定邀请码
static NSString *BindInvitaCode_URL = @"/user/bindInviteCode";

#pragma mark 分红
//我的分红
static NSString *MyBonus_URL = @"/seal/fetchUserProfitStat";
//分红玉玺进度
static NSString *BonusProgress_URL = @"/seal/fetchSealProcess";
//今日分红记录
static NSString *BonusRecord_URL = @"/seal/fetchDateProfitRecord";
//平台分红
static NSString *PlatformBonus_URL = @"/seal/fetchSysProfitMoney";
//获取福豆兑换商品
static NSString *FotonGoods_URL = @"/seal/fetchBlessBeanGoods";
//福豆兑换限时分红
static NSString *FotonExchangeGoods_URL = @"/seal/cashBlessBeanGoods";
//获取福豆明细
static NSString *FotonRecord_URL = @"/account/fetchBlessBeanLogs";
//获取当前用户的的限时分红列表
static NSString *UserLimitBonusList_URL = @"/seal/fetchUserTimeProfitAll";
//获取当前用户的到期的限时分红列表
static NSString *UserExpireBonusList_URL = @"/seal/fetchUserTimeProfitList";
#pragma mark 获取系统配置
static NSString *SystemConfig_url = @"/sys/fetchSysConfig";
#pragma mark 获取用户任务完成进度列表
static NSString *UserTaskFinish_URL = @"/regTask/fetchUserTaskFinishList";
//获取用户任务完成提示列表
static NSString *UserTaskFinishLog_URL = @"/regTask/fetchUserTaskFinishTag";

#pragma mark 版本更新
static NSString *VersionUpdate_URL = @"/sys/fetchIosVersion";

#endif /* WCApiName_h */
