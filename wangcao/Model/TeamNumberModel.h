//
//  TeamNumberModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeamNumberModel : NSObject

/// (string, optional): 用户头像 ,
@property(nonatomic ,strong) NSString *avatar;

/// (string, optional): 用户生日 ,
@property(nonatomic ,strong) NSString *birthday;

/// (string, optional): 创建时间 ,
@property(nonatomic ,strong) NSString *createTime;

/// (integer, optional): 直邀人数 ,
@property(nonatomic ,assign) NSInteger directCount;

/// (integer, optional): 用户ID ,
@property(nonatomic ,assign) long userId;

/// (integer, optional): 用户身份 0:普通会员 1:代理 ,
@property(nonatomic ,assign) NSInteger identity;

/// (integer, optional): 扩散好友 ,
@property(nonatomic ,assign) NSInteger indirectCount;

/// (integer, optional): 等级 ,
@property(nonatomic ,assign) NSInteger level;

/// (integer, optional): 等级 ,
@property(nonatomic ,assign) NSInteger levelNo;

/// (string, optional): 用户昵称 ,
@property(nonatomic ,strong) NSString *nickName;

/// (string, optional): 用户个性签名 ,
@property(nonatomic ,strong) NSString *personalitySignature;

/// (string, optional): 用户手机号 ,
@property(nonatomic ,strong) NSString *phone;

/// (string, optional): qq ,
@property(nonatomic ,strong) NSString *qq;

/// (integer, optional): 用户性别 ,
@property(nonatomic ,assign) NSInteger sex;

/// (integer, optional): 用户状态 0:未激活 1:已激活 ,
@property(nonatomic ,assign) BOOL status;

/// (string, optional): 微信
@property(nonatomic ,strong) NSString *wx;

//ParentVoModel 用户邀请人信息
@property(nonatomic ,assign) double income;
@property(nonatomic ,assign) NSInteger ParentVo_id;

/// 用户信息
@property (nonatomic ,strong) NSDictionary *contactInfo;

/// (integer, optional): 在系统中是否激活
@property(nonatomic ,assign) BOOL validStatus;

/// 用户昵称
@property (nonatomic ,strong) NSString *contactName;

/// (integer, optional): 联系人系统中ID，如果为0则在系统中不存在 ,
@property (nonatomic ,assign) NSInteger contactUid;

///新增朝代信息
/*
 dynasty (integer, optional): 最高等级 ,
 dynastyName (string, optional): 最高等级 ,
 */
@property (nonatomic,assign) NSInteger dynasty;
@property (nonatomic,copy) NSString *dynastyName;  //朝代名称

//答题
@property (nonatomic,assign) NSInteger answerNumber;  //答题数量
@property (nonatomic,assign) BOOL ower;   //房主

@end

NS_ASSUME_NONNULL_END
