//
//  TaskDetailModel.h
//  wangcao
//
//  Created by liu dequan on 2020/5/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskDetailModel : NSObject

//conditionNumber (integer, optional): 任务条件次数 ,
//dateType (string, optional): 任务周期 = ['DAY', 'ALL']
//id (integer, optional): 任务ID ,
//processNumber (integer, optional): 过程次数 ,
//reward (number, optional): 任务奖励 ,
//rewardType (string, optional): 任务类型 GOLD:金币 BLESS_BEAN:福豆 = ['GOLD', 'BLESS_BEAN']
//status (integer, optional): 0:可以做 1:已完成 -1:不能做 ,
//targetId (integer, optional): 外健ID/下载ID/跳转H5ID ,
//taskCode (string, optional): 任务编码 XIQU：嘻趣；XIANYU:闲娱；ZRB：众人帮；HK_VIDEO:好看视频；DOWNLOAD：下载；TARGET_URL:跳转URL；VIDEO：视频广告；ANSWER：答题；SHARE：分享 = ['XIQU', 'DOWNLOAD', 'TARGET_URL', 'VIDEO', 'XIANYU', 'HK_VIDEO', 'ZRB', 'ANSWER', 'SHARE']
//taskDesc (string, optional): 任务详情 ,
//taskIcon (string, optional): 任务图标 ,
//taskTitle (string, optional): 任务标题
@property (nonatomic,assign) NSInteger conditionNumber;
@property (nonatomic,copy) NSString *dateType;
@property (nonatomic,assign) NSInteger task_id;
@property (nonatomic,assign) NSInteger processNumber;
@property (nonatomic,assign) NSInteger reward;
@property (nonatomic,copy) NSString *rewardType;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger targetId;
@property (nonatomic,copy) NSString *taskCode;
@property (nonatomic,copy) NSString *taskDesc;
@property (nonatomic,copy) NSString *taskIcon;
@property (nonatomic,copy) NSString *taskTitle;

@end

NS_ASSUME_NONNULL_END
