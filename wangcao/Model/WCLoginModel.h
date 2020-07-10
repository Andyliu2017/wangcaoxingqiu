//
//  WCLoginModel.h
//  wangcao
//
//  Created by liu dequan on 2020/4/29.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCLoginModel : NSObject<NSCoding,NSCopying>

//过期时间,token失效时间
@property(nonatomic,assign) NSTimeInterval expireAt;
//是否绑定手机
@property(nonatomic,assign) BOOL isBindMobile;
//是否新用户
@property(nonatomic,assign) BOOL isNew;
//mqttPassward (string, optional): mqtt密码 ,
@property(nonatomic,copy) NSString *mqttPassward;
//mqttUserName (string, optional): mqtt用户名 ,
@property(nonatomic,copy) NSString *mqttUserName;
//平台
@property(nonatomic,copy) NSString *platform;
//token
@property(nonatomic,copy) NSString *token;
//用户id
@property(nonatomic,assign) long userId;
//用户类型 0 普通用户 ,
@property (nonatomic,assign) NSInteger userType;

//微信登录临时id
@property(nonatomic,copy) NSString *wxLoginId;

@property (nonatomic,assign) BOOL isLogin;

@end

NS_ASSUME_NONNULL_END
