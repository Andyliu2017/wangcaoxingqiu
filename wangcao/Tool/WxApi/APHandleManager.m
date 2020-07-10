//
//  APHandleManager.m
//  拍货郎
//
//  Created by 刘峰 on 2018/11/10.
//  Copyright © 2018年 刘峰. All rights reserved.
//

#import "APHandleManager.h"
#import <WXApi.h>

// 微信开放平台
#define WEIXIN_OPEN_APPID @"wxe1d06c7884dcbea2"
#define WEIXIN_OPEN_APPSECRET @"1fcd7b01c5b4132d1ade3bb41ffb608c"

@interface APHandleManager()<WXApiDelegate>

@property(nonatomic,copy) void(^wachatSuccessBlock)(NSString *authCode);

@property(nonatomic,copy) void(^successBlock)(HandleStatus code);

@property(nonatomic,copy) void(^failBlock)(HandleStatus code);

@end

@implementation APHandleManager

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static APHandleManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[APHandleManager alloc] init];
    });
    return instance;
}
    
- (void)registerHandle
{
    [WXApi registerApp:WEIXIN_OPEN_APPID universalLink:@"https://www.zhwz.huactl.cn/"];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    if ([url.absoluteString containsString:WEIXIN_OPEN_APPID])
    {
        //微信支付或者分享
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

#pragma mark - WXApiDelegate
//微信支付和分享和QQ分享回调都会调用这个方法
- (void)onResp:(BaseResp *)resp
{
    NSLog(@"%d",resp.errCode);
    if ([resp isKindOfClass:SendMessageToWXResp.class])
    {
        //微信分享
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                self.successBlock ? self.successBlock(HandleStatus_Success) : nil;
                break;
            }
            case WXErrCodeUserCancel:
            {
                self.failBlock ? self.failBlock(HandleStatus_Cancel) : nil;
                break;
            }
            default:
            {
                self.failBlock ? self.failBlock(HandleStatus_Error) : nil;
                break;
            }
        }
    }
    else if ([resp isKindOfClass:SendAuthResp.class])
    {
        //微信登录、绑定微信
        SendAuthResp *authResp = (SendAuthResp *)resp;
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                self.wachatSuccessBlock ? self.wachatSuccessBlock(authResp.code) : nil;
                break;
            }
            case WXErrCodeUserCancel:
            {
                self.failBlock ? self.failBlock(HandleStatus_Cancel) : nil;
                break;
            }
            default:
            {
                self.failBlock ? self.failBlock(HandleStatus_Error) : nil;
                break;
            }
        }
    }
    else if ([resp isKindOfClass:PayResp.class])
    {
        //微信支付
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                self.successBlock ? self.successBlock(HandleStatus_Success) : nil;
                break;
            }
            case WXErrCodeUserCancel:
            {
                self.failBlock ? self.failBlock(HandleStatus_Cancel) : nil;
                break;
            }
            default:
            {
                self.failBlock ? self.failBlock(HandleStatus_Error) : nil;
                break;
            }
        }
    }
}


@end

@implementation APHandleManager (Pay)

- (void)wxAppletPayWithUserName:(NSString *)userName
                           path:(NSString *)path
                        success:(void(^)(HandleStatus code))successBlock
                        failure:(void(^)(HandleStatus code))failBlock
{
    
    self.successBlock = successBlock;
    self.failBlock = failBlock;
    
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = userName;
    launchMiniProgramReq.path = path;
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; 
    if(![WXApi isWXAppInstalled])
    {
        failBlock ? failBlock(HandleStatus_Error) : nil;
        return ;
    }
    if (![WXApi isWXAppSupportApi])
    {
        failBlock ? failBlock(HandleStatus_Error) : nil;
        return ;
    }
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        
        
    }];
    //[WXApi sendReq:launchMiniProgramReq];
}


/// 微信支付
/// @param model 订单信息
/// @param successBlock 成功回调
/// @param failBlock 失败回调
- (void)wxPay:(NSDictionary *)model
      success:(void(^)(HandleStatus code))successBlock
      failure:(void(^)(HandleStatus code))failBlock
{
    self.successBlock = successBlock;
    self.failBlock = failBlock;
    
    PayReq *req = [PayReq new];
    req.partnerId = [model objectForKey:@"partnerId"];
    req.prepayId = [model objectForKey:@"prepayId"];
    req.nonceStr = [model objectForKey:@"nonceStr"];
    req.timeStamp = [[model objectForKey:@"timestamp"] intValue];
    req.package = @"Sign=WXPay";
    req.sign = [model objectForKey:@"sign"];
    
    if(![WXApi isWXAppInstalled])
    {
        failBlock ? failBlock(HandleStatus_Error) : nil;
        return ;
    }
    if (![WXApi isWXAppSupportApi])
    {
        failBlock ? failBlock(HandleStatus_Error) : nil;
        return ;
    }
    [WXApi sendReq:req completion:^(BOOL success) {
        
        
    }];
}




@end

@implementation APHandleManager (Share)

- (void)shareToPlatform:(SharePlatform)platform
                  image:(UIImage *)image
                success:(void(^)(HandleStatus code))successBlock
                failure:(void(^)(HandleStatus code))failBlock
{
    self.successBlock = successBlock;
    self.failBlock = failBlock;
    if (platform == SharePlatform_Session || platform == SharePlatform_Timeline)
    {
        //微信
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        //发送消息的类型，包括文本消息和多媒体消息两种，两者只能选择其一，不能同时发送文本和多媒体消息
        req.bText = NO;
        if (platform == SharePlatform_Session)
        {
            req.scene = WXSceneSession;
        }
        else
        {
            req.scene = WXSceneTimeline;
        }
        WXImageObject *imageObj = [WXImageObject object];
        imageObj.imageData = UIImageJPEGRepresentation(image, 1.0);

        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = imageObj;
        req.message = message;
        [WXApi sendReq:req completion:^(BOOL success) {
            
        }];
  //      [WXApi sendReq:req];
    }
}

- (void)shareToPlatform:(SharePlatform)platform
                  title:(NSString *)title
            description:(NSString *)description
                  image:(UIImage *)image
                   link:(NSString *)link
                success:(void(^)(HandleStatus code))successBlock
                failure:(void(^)(HandleStatus code))failBlock
{
    self.successBlock = successBlock;
    self.failBlock = failBlock;
    if (platform == SharePlatform_Session || platform == SharePlatform_Timeline)
    {
        //微信
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        // 是否是文档
        req.bText = NO;
        if (platform == SharePlatform_Session)
        {
            req.scene = WXSceneSession;
        }
        else
        {
            req.scene = WXSceneTimeline;
        }
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        //分享标题
        urlMessage.title = title;
        //分享描述
        urlMessage.description = description;
        //分享图片,使用SDK的setThumbImage方法可压缩图片大小
        [urlMessage setThumbImage:image];
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        //分享链接
        webObj.webpageUrl = link;
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        req.message = urlMessage;
        //发送分享信息
        [WXApi sendReq:req completion:^(BOOL success) {
            
        }];
    }
}


@end

@implementation APHandleManager (Auth)

- (void)authorizationWachat:(void(^)(NSString *authCode))successBlock
                    failure:(void(^)(HandleStatus code))failBlock
{
    self.wachatSuccessBlock = successBlock;
    self.failBlock = failBlock;
    
    NSInteger random = arc4random() % 1000;
    NSString *state = [NSString stringWithFormat:@"wx_auth_guoguoshan_%zd",random];
    //构造SendAuthReq结构体
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = [state md5String];
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}

@end
