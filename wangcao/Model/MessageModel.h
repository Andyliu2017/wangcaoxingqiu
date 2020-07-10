//
//  MessageModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/9.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

/// (string, optional): 内容 ,
@property (nonatomic ,copy) NSString *content;

///  (integer, optional): ID ,
@property (nonatomic ,assign) NSInteger ID;

/// (integer, optional): 是否已读：0 否 1是 ,
@property (nonatomic ,assign) BOOL isRead;

/// (integer, optional): 是否透传消息 0 否 1是 ,
@property (nonatomic ,assign) BOOL ospf;

/// (integer, optional): 接收人ID ,
@property (nonatomic ,assign) NSInteger reviceUid;

/// (string, optional): 发送时间 ,
@property (nonatomic ,copy) NSString *sendTime;

 /// (string, optional): 外键ID ,
@property (nonatomic ,assign) NSInteger targetId;

/// (object, optional): 对应的跳转实体信息 ,
@property (nonatomic ,strong) NSDictionary *targetObj;

/// (string, optional): 消息类型 OTHER 其他消息 SYSTEM_MSG 系统消息 NOTICE_MSG 公告消息 ORDER 订单消息 ,
@property (nonatomic ,copy) NSString *targetType;

/// (string, optional): 标题 ,
@property (nonatomic ,copy) NSString *title;

/// (string, optional): 消息类型 OTHER 其他消息 SYSTEM_MSG 系统消息 NOTICE_MSG 公告消息 ORDER 订单消息 ,
@property (nonatomic ,copy) NSString *type;

/// (string, optional): 链接URL
@property (nonatomic ,copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
