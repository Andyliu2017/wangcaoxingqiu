//
//  UserModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserReputationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

//avatar (string, optional): 用户头像 ,
@property (nonatomic,copy) NSString *avatar;
//bindInvitecode (string, optional): 绑定的邀请码 ,
@property (nonatomic,copy) NSString *bindInvitecode;
//birthday (string, optional): 生日 ,
@property (nonatomic,copy) NSString *birthday;
//createTime (string, optional): 注册时间 ,
@property (nonatomic,copy) NSString *createTime;
//directorId (integer, optional),
@property (nonatomic,assign) NSInteger directorId;
//email (string, optional): 用户邮箱 ,
@property (nonatomic,copy) NSString *email;
//generalManagerId (integer, optional),
@property (nonatomic,assign) NSInteger generalManagerId;
//hobby (string, optional): 兴趣爱好 ,
@property (nonatomic,copy) NSString *hobby;
//id (integer, optional): 用户ID ,
@property (nonatomic,assign) NSInteger user_id;
//invitecode (string, optional): 邀请码 ,
@property (nonatomic,copy) NSString *invitecode;
//lastOperTime (string, optional): 最后操作时间 ,
@property (nonatomic,copy) NSString *lastOperTime;
//lastTime (string, optional): 最后修改时间 ,
@property (nonatomic,copy) NSString *lastTime;
//nickName (string, optional): 用户昵称 ,
@property (nonatomic,copy) NSString *nickName;
//personalitySignature (string, optional): 个性签名 ,
@property (nonatomic,copy) NSString *personalitySignature;
//phone (string, optional): 用户手机号 ,
@property (nonatomic,copy) NSString *phone;
//platform (string, optional): 平台 ,
@property (nonatomic,copy) NSString *platform;
//promotersId (integer, optional),
@property (nonatomic,assign) NSInteger promotersId;
//qrcode (string, optional): 二维码路径 ,
@property (nonatomic,copy) NSString *qrcode;
//referrerId (integer, optional): 推荐人ID ,
@property (nonatomic,assign) NSInteger referrerId;
//reputationInfo (UserReputationEmbedEntry, optional): 等级信息 ,
@property (nonatomic,strong) UserReputationModel *reputationInfo;
//sex (integer, optional): 性别 ,
@property (nonatomic,assign) NSInteger sex;
//status (integer, optional): 用户状态 ,
@property (nonatomic,assign) NSInteger status;
//userType (integer, optional): 用户类型
@property (nonatomic,assign) NSInteger userType;
//qq号
@property (nonatomic,copy) NSString *qq;
//微信
//@property (nonatomic,copy) NSString *wechat;
@property (nonatomic,copy) NSString *weixin;

@end

NS_ASSUME_NONNULL_END
