//
//  APHandleManager.h
//  拍货郎
//
//  Created by 刘峰 on 2018/11/10.
//  Copyright © 2018年 刘峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXMediaMessage+messageConstruct.h"
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"

typedef NS_ENUM(NSInteger,RechargePayMethod){
    RechargePayMethod_Wachat, //微信
};

typedef NS_ENUM(NSInteger, HandleStatus) {
    HandleStatus_Success    = 0,
    HandleStatus_Cancel     = 1,
    HandleStatus_Error      = 2,
};

typedef NS_ENUM(NSInteger,SharePlatform){
    SharePlatform_Timeline = 0, //微信朋友圈
    SharePlatform_Session = 1,  //微信好友
};

@interface APHandleManager : NSObject

/**
 *  获取单例
 */
+ (instancetype)sharedManager;

/**
 *  回调入口
 *
 *  @param url  回调url
 *
 *  @return  value
 */
- (BOOL)handleOpenURL:(NSURL *)url;


/**
 注册
 */
- (void)registerHandle;

@end



@interface APHandleManager (Share)

/**
 *  发起分享
 *
 *  @param platform       分享平台
 *  @param image          分享图片
 *
 */
- (void)shareToPlatform:(SharePlatform)platform
                  image:(UIImage *)image
                success:(void(^)(HandleStatus code))successBlock
                failure:(void(^)(HandleStatus code))failBlock;

/**
 *  发起分享
 *
 *  @param platform       分享平台
 *  @param title          分享标题
 *  @param description    分享描述
 *  @param image          分享缩略图
 *  @param link           分享链接
 *
 */
- (void)shareToPlatform:(SharePlatform)platform
                  title:(NSString *)title
            description:(NSString *)description
                  image:(UIImage *)image
                   link:(NSString *)link
                success:(void(^)(HandleStatus code))successBlock
                failure:(void(^)(HandleStatus code))failBlock;




@end

@interface APHandleManager (Auth)

- (void)authorizationWachat:(void(^)(NSString *authCode))successBlock
                    failure:(void(^)(HandleStatus code))failBlock;



@end
