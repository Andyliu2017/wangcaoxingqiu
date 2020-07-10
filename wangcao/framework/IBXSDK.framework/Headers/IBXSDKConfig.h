//
//  IBXSDKConfig.h
//  IBXSDK
//
//  Created by yeming on 2020/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBXSDKConfig : NSObject

/**
 配置信息
 */
+ (void)setupAppKey:(NSString *)appKey
          secretKey:(NSString *)secretKey
           targetId:(NSString *)targetId
          notifyUrl:(NSString *)notifyUrl;


@end

NS_ASSUME_NONNULL_END
