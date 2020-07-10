//
//  PKTeamInfoModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKTeamInfoModel : NSObject

//answerNumber (integer, optional): 总答题数量 ,
//groupMaxPeoples (integer, optional): 战队可允许最大人数 ,
//groupName (string, optional): 战队名称 ,
//groupPeoples (integer, optional): 战队人数 ,
//id (integer, optional): 战队ID ,
//isMustAd (boolean, optional): 下次挑战是不是需要看广告 ,
//owerUid (integer, optional): 战队房主ID ,
//qrcodeUrl (string, optional): 二维码地址 ,
//rank (integer, optional): 排名 ,
//sulplusBattleNumber (integer, optional): 剩余挑战次数 ,
//totalAnswerNumber (integer, optional): 每个人总共能答对多少题 ,
//totalBattleNumber (integer, optional): 总挑战次数 ,
//videoAd (视频广告对象, optional): 广告对象
@property (nonatomic,assign) NSInteger answerNumber;
@property (nonatomic,assign) NSInteger groupMaxPeoples;
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,assign) NSInteger groupPeoples;
@property (nonatomic,assign) NSInteger team_id;
@property (nonatomic,assign) BOOL isMustAd;
@property (nonatomic,assign) NSInteger owerUid;
@property (nonatomic,copy) NSString *qrcodeUrl;
@property (nonatomic,assign) NSInteger rank;
@property (nonatomic,assign) NSInteger sulplusBattleNumber;
@property (nonatomic,assign) NSInteger totalAnswerNumber;
@property (nonatomic,assign) NSInteger totalBattleNumber;
@property (nonatomic,strong) VideoModel *videoAd;

//房主信息
@property (nonatomic,strong) UserModel *ower;

//pk排行榜
//settleAmount (number, optional): 奖励金额 ,
@property (nonatomic,assign) double settleAmount;
@property (nonatomic,strong) UserModel *userInfo;

@end

NS_ASSUME_NONNULL_END
