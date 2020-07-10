//
//  MQTTHandleManager.m
//  wangcao
//
//  Created by EDZ on 2020/6/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import "MQTTHandleManager.h"

@interface MQTTHandleManager()<MQTTSessionManagerDelegate>

@property (nonatomic,strong) MQTTSessionManager *sessionManager;

//定时器
@property(nonatomic,strong) dispatch_source_t timer;

//心跳topic
@property(nonatomic,copy) NSString *heartbeatTopic;
//订阅者集合
@property(nonatomic,strong) NSMutableDictionary *subscribeDict;
//是否在连接中
@property (nonatomic,assign) long isConnect;
//需要重新连接
@property (nonatomic,assign) BOOL isNeedReConnect;

@property (nonatomic,copy) NSString *chatTopic;
@property (nonatomic,copy) NSString *cliendId;

@property(nonatomic,assign) NSInteger timeNum;
//是否连接成功
//@property (nonatomic,assign) BOOL isConnectSuccess;

@end

@implementation MQTTHandleManager

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static MQTTHandleManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MQTTHandleManager alloc] init];
    });
    return instance;
}

- (MQTTSessionManager *)sessionManager{
    if (_sessionManager == nil) {
        _sessionManager = [[MQTTSessionManager alloc] init];
        _sessionManager.delegate = self;
//        _isConnectSuccess = NO;
    }
    return _sessionManager;
}

- (MQTTSSLSecurityPolicy *)customSecurityPolicy{
    MQTTSSLSecurityPolicy *securityPolicy = [MQTTSSLSecurityPolicy policyWithPinningMode:MQTTSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesCertificateChain = YES;
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}
//topic："/USER/"+getUserId()    clientId："ANDROID_"+ getUserId()
- (void)MQTTConnect{
    //已经连上 不连
//    if (_isConnectSuccess) {
//        NSLog(@"连接成功不连");
//        return;
//    }
    NSString *clientId = [NSString stringWithFormat:@"iOS_%ld",[PBCache shared].memberModel.userId];
    NSString *topic = [NSString stringWithFormat:@"/USER/%ld",[PBCache shared].memberModel.userId];
    self.cliendId = clientId;
    self.chatTopic = topic;
    [self MQTTConnectWithClientId:clientId topic:topic];
}
- (void)MQTTConnectWithClientId:(NSString *)clientId topic:(NSString *)topic{
    self.isConnect = YES;
    
    [self.sessionManager connectTo:[PBCache shared].systemModel.mqttIp
                              port:[[PBCache shared].systemModel.mqttPort intValue]
                               tls:NO
                         keepalive:5
                             clean:YES
                              auth:YES
                              user:[PBCache shared].memberModel.mqttUserName
                              pass:[PBCache shared].memberModel.mqttPassward
                              will:NO
                         willTopic:nil
                           willMsg:nil
                           willQos:0
                    willRetainFlag:NO
                      withClientId:clientId
                    securityPolicy:[self customSecurityPolicy]
                      certificates:nil
                     protocolLevel:MQTTProtocolVersion311
                    connectHandler:nil];
    [self subscribeTopic:topic];
    
    NSLog(@"mqttIp = %@,port = %@,userName = %@,password = %@,clientId = %@,topic = %@",[PBCache shared].systemModel.mqttIp,[PBCache shared].systemModel.mqttPort,[PBCache shared].memberModel.mqttUserName,[PBCache shared].memberModel.mqttPassward,clientId,topic);
    
//    [self startTime];
}

- (void)senderHeartbeat{
//    NSData *sendData = [self.chatNo dataUsingEncoding:NSUTF8StringEncoding];
    //[self.sessionManager sendData:sendData topic:self.heartbeatTopic qos:MQTTQosLevelAtMostOnce retain:NO];
//    [self.sessionManager sendData:sendData topic:self.heartbeatTopic qos:MQTTQosLevelAtMostOnce retain:NO];
}

#pragma mark - 订阅
- (void)subscribeTopic:(NSString *)topic{
//    LFLog(@"当前需要订阅-------- topic = %@",topic);
    if (![self.subscribeDict.allKeys containsObject:topic]) {
        [self.subscribeDict setValue:@(MQTTQosLevelAtMostOnce) forKey:topic];
    }else{
        LFLog(@"已经存在，不用订阅");
    }
    self.sessionManager.subscriptions = self.subscribeDict;
}

#pragma mark - 取消订阅
- (void)unsubscribeTopic:(NSString *)topic {
    LFLog(@"当前需要取消订阅-------- topic = %@",topic);
    if ([self.subscribeDict.allKeys containsObject:topic]) {
        [self.subscribeDict removeObjectForKey:topic];
        LFLog(@"更新之后的订阅字典 ----------- = %@",self.subscribeDict);
        self.sessionManager.subscriptions =  self.subscribeDict;
    }else{
        LFLog(@"不存在，无需取消");
    }
}

#pragma mark - 断开连接
- (void)disconnect{
//    self.isConnectSuccess = NO;
    self.isConnect = NO;
    self.isNeedReConnect = NO;
    [self unsubscribeTopic:self.chatTopic];
    [self.sessionManager disconnectWithDisconnectHandler:^(NSError *error) {
        LFLog(@"断开连接  error = %@",[error description]);
    }];
    self.sessionManager.delegate = nil;
    self.sessionManager = nil;
    //断开连接销毁定时器
    [self endTime];
}

#pragma mark - 重新连接
- (void)reConnect {
    self.isConnect = YES;
    if (self.sessionManager && self.sessionManager.port) {
        self.sessionManager.delegate = self;
        [self.sessionManager connectToLast:^(NSError *error) {
            LFLog(@"重新连接  error = %@",[error description]);
        }];
        self.sessionManager.subscriptions = self.subscribeDict;
        [self startTime];
    }else{
        [self MQTTConnectWithClientId:self.cliendId topic:self.chatTopic];
    }
}

#pragma mark ---- 状态
- (void)sessionManager:(MQTTSessionManager *)sessionManager didChangeState:(MQTTSessionManagerState)newState {
    switch (newState) {
        case MQTTSessionManagerStateConnected:
            LFLog(@"eventCode -- 连接成功");
            //如果是从关闭状态到连接成功为重新连接
            if ([self.delegate respondsToSelector:@selector(connectSuccess:)]) {
                [self.delegate connectSuccess:self.isNeedReConnect];
            }
//            self.isConnectSuccess = YES;
            self.isNeedReConnect = NO;
            break;
        case MQTTSessionManagerStateConnecting:
            LFLog(@"eventCode -- 连接中");
            break;
        case MQTTSessionManagerStateClosed:
            LFLog(@"eventCode -- 连接被关闭");
            if (self.isConnect) {
                //连接中,因为网络等问题关闭
                self.isNeedReConnect = YES;
            }
//            self.isConnectSuccess = NO;
            break;
        case MQTTSessionManagerStateError:
            LFLog(@"eventCode -- 连接错误");
            break;
        case MQTTSessionManagerStateClosing:
            LFLog(@"eventCode -- 关闭中");
            break;
        case MQTTSessionManagerStateStarting:
            LFLog(@"eventCode -- 连接开始");
            break;
        default:
            break;
    }
}

#pragma mark MQTTSessionManagerDelegate
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"dataString = %@",dataString);
    MQTTModel *model = [MQTTModel mj_objectWithKeyValues:dataString];
    [self.delegate recevieMessage:model];
}

//开启定时器
- (void)startTime{
    if (self.timer == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 20秒执行一次
        dispatch_source_set_event_handler(self.timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{

                self.timeNum ++;
                if (self.timeNum > 20) {
                    self.timeNum = 0;
                    [self senderHeartbeat];
                }

                if (self.sessionManager.state == MQTTSessionManagerStateClosed || self.sessionManager.state == MQTTSessionManagerStateError) {
                    //不是主动断开连接,重连
                    if (self.isConnect) {
                        [self reConnect];
                    }
                }
            });
        });
        dispatch_resume(self.timer);
    }
}


//结束定时器
- (void)endTime{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (NSMutableDictionary *)subscribeDict{
    if (_subscribeDict == nil) {
        _subscribeDict = [NSMutableDictionary dictionary];
    }
    return _subscribeDict;
}

@end
