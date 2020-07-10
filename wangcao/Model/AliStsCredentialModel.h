//
//  AliStsCredentialModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/30.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AliStsCredentialModel : NSObject

//accessKeyId (string): 访问密钥标识 ,
@property (nonatomic,copy) NSString *accessKeyId;
//accessKeySecret (string): 访问密钥 ,
@property (nonatomic,copy) NSString *accessKeySecret;
//expiration (string): 失效时间(UTC时间) ,
@property (nonatomic,copy) NSString *expiration;
//securityToken (string): 安全令牌
@property (nonatomic,copy) NSString *securityToken;

@end

NS_ASSUME_NONNULL_END
