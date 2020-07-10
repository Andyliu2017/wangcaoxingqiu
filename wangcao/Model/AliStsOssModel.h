//
//  AliStsOssModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/30.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliStsCredentialModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AliStsOssModel : NSObject

//accessid (string, optional),
@property (nonatomic,copy) NSString *accessid;
//bucket (string): OSS文件存放bucket ,
@property (nonatomic,copy) NSString *bucket;
//cdnEndpoint (string): CDN访问加速地址 ,
@property (nonatomic,copy) NSString *cdnEndpoint;
//credential (AliStsCredential): 访问OSS凭证 ,
@property (nonatomic,strong) AliStsCredentialModel *credential;
//endpoint (string): OSS连接地址 ,
@property (nonatomic,copy) NSString *endpoint;
//expire (integer, optional),
@property (nonatomic,assign) NSInteger expire;
//host (string, optional),
@property (nonatomic,copy) NSString *host;
//policy (string, optional),
@property (nonatomic,copy) NSString *policy;
//region (string): OSS服务所属region(JS.SDK需要) ,
@property (nonatomic,copy) NSString *region;
//signature (string, optional)
@property (nonatomic,copy) NSString *signature;

@end

NS_ASSUME_NONNULL_END
