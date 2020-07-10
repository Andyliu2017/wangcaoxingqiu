//
//  MQTTHandleManager.h
//  wangcao
//
//  Created by EDZ on 2020/6/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTClient.h>
#import "MQTTModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MQTTHandleManagerDelegate <NSObject>

/**
 连接成功

 @param isReconnect 是否是重新连接
 */
- (void)connectSuccess:(BOOL)isReconnect;

- (void)recevieMessage:(MQTTModel *)model;

@end

@interface MQTTHandleManager : NSObject

@property (nonatomic,weak) id<MQTTHandleManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (void)MQTTConnect;
#pragma mark - 断开连接
- (void)disconnect;
#pragma mark 重新连接
- (void)reConnect;

@end

NS_ASSUME_NONNULL_END
