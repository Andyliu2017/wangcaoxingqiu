//
//  WCApiManager.m
//  wangcao
//
//  Created by EDZ on 2020/5/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WCApiManager.h"
#import "WCApiName.h"
#import <NSObject+YYModel.h>
#import "APRequestSerializer.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "AliStsOssModel.h"

#ifdef DEBUG
//测试环境
NSString *kHostUrl = @"http://121.40.179.123:17901";
#else
//正式环境
NSString *kHostUrl =  @"https://api.huactl.com";
#endif

//密钥 E623BBD8FDD844F9BC71A3514054F4BD

NSString *const gUserKey = @"gUser";
NSString *const gRelogin = @"gRelogin";
NSString *const kSecurities = @"gSecurities";
NSString *const gExtractMethodBank = @"BANK";
NSString *const kExtractMethodWachat = @"WEIXIN";
NSString *const kExtractMethodAlipay = @"ALIPAY";

NSString *const kErrorDomain = @"kErrorDomain";
NSInteger const kErrorException = 500;
//无网络
NSInteger const kNotNetwordException = 6666;
//重复出价
NSInteger const kRepeatBid = 7777;

typedef enum {
    RequestMethod_Post = 0, //post请求
    RequestMethod_Get = 1, //get请求
} RequestMethod;

@interface WCApiManager()

@property(nonatomic,strong) AFJSONRequestSerializer *jsonSerializer;
@property(nonatomic,strong) AFHTTPRequestSerializer *textSerializer;

@end

@implementation WCApiManager

- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (self) {
        self.jsonSerializer = [[AFJSONRequestSerializer alloc] init];
        self.textSerializer = [[AFHTTPRequestSerializer alloc] init];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //后来加的
        [self.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
        self.cache = [YYCache cacheWithName:@"pt_cache_data"];
        if ([self.cache containsObjectForKey:gUserKey]) {
            id object = [self.cache objectForKey:gUserKey];
            if ([object isKindOfClass:WCLoginModel.class]) {
                [[PBCache shared] setMemberModel:object];
                self.loginModel = object;
            }
        }
    }
    return self;
}

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static WCApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [self manager];
#ifdef DEBUG
        //LFLog(@"测试环境不添加https证书认证");
#else
        [instance setSecurityPolicy:[self customSecurityPolicy]];
        kHostUrl = [[GGUI outPutDNSServers] isEqualToString:@"0.0.0.0"] ? @"https://api.huactl.com" : @"https://api.huactl.com";
#endif
    });
    return instance;
}

+ (AFSecurityPolicy *)customSecurityPolicy
{
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *path = [[NSBundle mainBundle] pathForResource:@"public" ofType:@"cer"];//证书的路径 xx.cer
    NSData *cerData = [NSData dataWithContentsOfFile:path];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // AFSSLPinningModeNone: 代表客户端无条件地信任服务器端返回的证书。
    // AFSSLPinningModePublicKey: 代表客户端会将服务器端返回的证书与本地保存的证书中，PublicKey的部分进行校验；如果正确，才继续进行。
    // AFSSLPinningModeCertificate: 代表客户端会将服务器端返回的证书和本地保存的证书中的所有内容，包括PublicKey和证书部分，全部进行校验；如果正确，才继续进行。
    securityPolicy.allowInvalidCertificates = NO;
    // 是否允许无效证书（也就是自建的证书），默认为NO 如果是需要验证自建证书，需要设置为YES
    securityPolicy.validatesDomainName = YES;
    //validatesDomainName 是否需要验证域名，默认为YES;
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    return securityPolicy;
}

- (void)clearUserInfo
{
      if ([self.cache containsObjectForKey:gUserKey])
    {
        [self.cache removeObjectForKey:gUserKey];
        self.loginModel.isLogin = NO;
        [PBCache shared].memberModel.isLogin = NO;
    }
}

//在此方法里面添加请求公共参数
- (NSDictionary *)headerParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    self.loginModel = [PBCache shared].memberModel;
    //会话id
    if (self.loginModel && [self.loginModel.token isNotBlank])
    {
        [parameters setObject:self.loginModel.token forKey:@"token"];
        [parameters setObject:@(self.loginModel.userId) forKey:@"uid"];
    }
    else
    {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginTokenTmp"];
        NSInteger userid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUseridTmp"] integerValue];
        if (token.length > 0)
        {
            [parameters setObject:token forKey:@"token"];
            [parameters setObject:@(userid) forKey:@"uid"];
            
            if (self.loginModel == nil)
            {
                self.loginModel = [WCLoginModel new];
            }
            self.loginModel.token = token;
            self.loginModel.userId = userid;
            [PBCache shared].memberModel.token = token;
            [PBCache shared].memberModel.userId = userid;
        }
        
    }
    
    //请求时间
    long long timestamp =  [[NSDate date] timeIntervalSince1970] * 1000;
    [parameters setObject:F(@"%lld", timestamp) forKey:@"timestamp"];
    //bundleId
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    [parameters setObject:bundleId forKey:@"bundleId"];
    //设备id
    //    [parameters setObject:[NSString staticDeviceId] forKey:@"deviceId"];
    //设备类型
    [parameters setObject:@"MOBILE" forKey:@"deviceType"];
    //设备型号
    [parameters setObject:[[UIDevice currentDevice] model] forKey:@"deviceModel"];
    //系统版本
    [parameters setObject:[UIDevice currentDevice].systemVersion forKey:@"osVersion:"];
    //系统类型
    [parameters setObject:@"IOS" forKey:@"osType"];
    //必传
    [parameters setObject:@"APP" forKey:@"loginChannel"];
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [parameters setObject:version forKey:@"appVersion"];
    //发布渠道
#ifdef DEBUG
    [parameters setObject:@"DEBUG" forKey:@"releaseChannel"];
#else
    [parameters setObject:@"RELEASE" forKey:@"releaseChannel"];
#endif
    return parameters;
}

- (void)getHttp:(NSString *)url dic:(NSDictionary *)parameters block:(void(^)(id sth,id sth2))block{
    
    //NSString *requestString = url;
    
    NSString *requestString = @"";
    requestString = kHostUrl;
    requestString = [NSString stringWithFormat:@"%@%@",requestString,url];
    
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
    
    //get方式请求
    self.requestSerializer = self.textSerializer;
    //添加公共参数
    NSDictionary *headParameters = [self headerParameters];
    [requestParameters addEntriesFromDictionary:headParameters];
    
    //添加请求参数
    if (parameters && parameters.count > 0) {
        [requestParameters addEntriesFromDictionary:parameters];
    }
#ifdef DEBUG
    //LFLog(@"debug模式下不添加sign参数");
#else
    NSString *signature = [self encryptionWithRequestParameter:parameters headParameter:headParameters isBodyJosn:NO];
    if ([signature isNotBlank]) {
        [requestParameters setObject:signature forKey:@"sign"];
    }
#endif
    
    [self GET:requestString parameters:requestParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = responseObject;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"B19"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:gRelogin object:nil];
            }
        }
        
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}
- (void)postHttp:(NSString *)url dic:(NSDictionary *)parameters block:(void(^)(id sth,id sth2))block{
    
    NSLog(@"param = %@",parameters);
    
    NSString *requestString = @"";
    requestString = kHostUrl;
    NSLog(@"kHostUrl:%@",kHostUrl);
    requestString = [NSString stringWithFormat:@"%@%@",requestString,url];
    //post方式请求
    //self.requestSerializer = YES ? self.jsonSerializer : self.textSerializer;
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //公共参数
    NSMutableDictionary *headParameters = [[self headerParameters] mutableCopy];
    if (parameters) {
        [headParameters addEntriesFromDictionary:parameters];
    }
    
    //拼接参数
    NSString *string = AFQueryStringFromParameters(headParameters);
    requestString = [requestString stringByAppendingFormat:@"?%@",string];
    
#ifdef DEBUG
    //LFLog(@"debug模式下不添加sign参数");
#else
    NSString *signature = [self encryptionWithRequestParameter:parameters headParameter:headParameters isBodyJosn:NO];
    if ([signature isNotBlank]) {
        requestString = [requestString stringByAppendingString:F(@"&sign=%@",signature)];
    }
#endif
    
    NSDictionary *tmpDic = nil;
    if (parameters) {
        tmpDic = parameters;
    }else {
        tmpDic = headParameters;
    }
    
    NSLog(@"reauestString = %@,headpra = %@",requestString,headParameters);
    [self POST:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = responseObject;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"B19"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:gRelogin object:nil];
            }
        }
        
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
    
}

- (RACSignal *)customRequestWithMethod:(RequestMethod)method
                                isJson:(BOOL)isJson
                            parameters:(NSDictionary *)parameters
                               apiName:(NSString *)apiName
                           resultClass:(Class)resultClass
                                   url:(NSString *)url
{
    NSString *requestString = [url stringByAppendingPathComponent:apiName];
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
    if (method == RequestMethod_Get)
    {
        //get方式请求
        self.requestSerializer = self.textSerializer;
        //添加公共参数
        NSDictionary *headParameters = [self headerParameters];
        [requestParameters addEntriesFromDictionary:headParameters];
        
        //添加请求参数
        if (parameters && parameters.count > 0)
        {
            [requestParameters addEntriesFromDictionary:parameters];
        }
#ifdef DEBUG
        //LFLog(@"debug模式下不添加sign参数");
#else
        NSString *signature = [self encryptionWithRequestParameter:parameters headParameter:headParameters isBodyJosn:NO];
        //NSLog(@"=====%@",signature);
        if ([signature isNotBlank])
        {
            [requestParameters setObject:signature forKey:@"sign"];
        }
#endif
    }
    else
    {
        NSLog(@"%@",parameters);
        //post方式请求
        self.requestSerializer = isJson ? self.jsonSerializer : self.textSerializer;
        //公共参数
        NSDictionary *headParameters = [self headerParameters];
        
        //拼接参数
        NSString *string = AFQueryStringFromParameters(headParameters);
        requestString = [requestString stringByAppendingFormat:@"?%@",string];
        
#ifdef DEBUG
        //LFLog(@"debug模式下不添加sign参数");
#else
        NSString *signature = [self encryptionWithRequestParameter:parameters headParameter:headParameters  isBodyJosn:isJson];
        if ([signature isNotBlank]) {
            requestString = [requestString stringByAppendingString:F(@"&sign=%@",signature)];
        }
#endif
    }
    
    //缓存模式直接返回
    id cacheData = self.cachePloy != APICachePloy_Server ? [self.cache objectForKey:[self cacheKeyWithParameters:parameters apiName:apiName]] : nil;
    switch (self.cachePloy)
    {
        case APICachePloy_Cache:
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:cacheData];
                [subscriber sendCompleted];
                return nil;
            }];
            break;
        case APICachePloy_Normal:
            if (cacheData)
            {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [subscriber sendNext:cacheData];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }
            break;
        default:
            break;
    }
    @weakify(self);
    RACSignal *requestSignal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        if (method == RequestMethod_Get)
        {
            NSURLSessionDataTask *sessionTask = [self GET:requestString parameters:requestParameters  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [sessionTask cancel];
            }];
        }else{
            NSURLSessionDataTask *sessionTask = [self POST:requestString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [sessionTask cancel];
            }];
        }
    }];
    
    void (^extraHandlerSingal)(id value) = ^(RACTuple * value) {
        
    };
    return [[[requestSignal catch:^RACSignal *(NSError *error) {
        
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data) {
            NSLog(@"error = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
        NSLog(@"error = %@",error);
        
        if (self.networkStatus > 0) {
            //有网络
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"请求失败,请稍后再试"};
            NSError *customError = [NSError errorWithDomain:kErrorDomain code:error.code userInfo:userInfo];
            return [RACSignal error:customError];
        }else{
            //无网络
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"当前无网络,请检查网络"};
            NSError *customError = [NSError errorWithDomain:kErrorDomain code:kNotNetwordException userInfo:userInfo];
            return [RACSignal error:customError];
        }
    }] flattenMap:^RACSignal *(id  _Nullable data) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
                {
            @strongify(self);
            NSString *code = data[@"code"];
            id resultObj = data[@"data"];
            //NSLog(@"resultObj = %@",data);
            //            if ([apiName isEqualToString:@"/user/share"])
            //            {
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"APSHARE_NUMBER" object:data];
            //            }
//            NSLog(@"resultObj = %@,,,data:%@",resultObj,data);
            NSLog(@"apiName:%@，data:%@",apiName,resultObj);
            if ([code isKindOfClass:[NSString class]] && [code isEqualToString:@"ok"])
            {
                //如果传递的class是APBaseModel的子类,才解析成对象,否则不做处理
//                if (resultObj && resultClass && [resultClass isSubclassOfClass:WCPublicModel.class])
//                {
//                    if ([apiName isEqualToString:@"/message/fetchSystemMessage"])
//                    {
//                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:resultObj,@"content", nil];
//                        resultObj = dic;
//                        NSLog(@"%@",resultObj);
//                    }
//                    if ([resultObj isKindOfClass:[NSArray class]])
//                    {
//
//                        resultObj = [NSArray modelArrayWithClass:resultClass json:resultObj];
//                    }
//                    else
//                    {
//                        resultObj = [resultClass modelWithJSON:resultObj];
//                    }
//                }
//                else
//                {
//                    //未传递classl对象,数据不解析，有些接口直接返回基础类型，这里不需要转换
//                    if ([resultObj isKindOfClass:NSNull.class])
//                    {
//                        resultObj = nil;
//                    }
//                }
                if (resultObj && resultClass) {
                    resultObj = [resultClass mj_objectWithKeyValues:resultObj];
                }
                if (resultObj)
                {
                    [self.cache setObject:resultObj forKey:[self cacheKeyWithParameters:parameters apiName:apiName]];
                }
                
//                NSLog(@"resultObj = %@",resultObj);
                [subscriber sendNext:resultObj];
            }
            else
            {
                //有网络
                NSString *content = data[@"message"];
                NSString *message = [content isNotBlank] ? content : @"";
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : message,@"code":code};
//                if ([userInfo[@"code"] isEqualToString:@"AC041"]) {  //金币不足
//                    [MBProgressHUD showText:message toView:[UIApplication sharedApplication].keyWindow afterDelay:1.5];
//                }else{
                    [MBProgressHUD showError:message toView:[UIApplication sharedApplication].keyWindow afterDelay:1];
//                }
                if ([code isEqualToString:@"M00"] || [code isEqualToString:@"AC026"] || [code isEqualToString:@"AC027"]) {
                    //重复出价 钱不够
                    NSError *error = [NSError errorWithDomain:kErrorDomain code:kRepeatBid userInfo:userInfo];
                    [subscriber sendError:error];
                }
                else
                {
                    //其他错误
                    NSError *error = [NSError errorWithDomain:kErrorDomain code:kErrorException userInfo:userInfo];
                    [subscriber sendError:error];
                }
            }
            [subscriber sendCompleted];
            if ([code isEqualToString:@"B19"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:gRelogin object:nil];
            }
            return nil;
        }];
    }] doNext:extraHandlerSingal];
}

- (NSString *)encryptionWithRequestParameter:(NSDictionary *)requestParameter
                               headParameter:(NSDictionary *)headParameter
                                  isBodyJosn:(BOOL)isBodyJson
{
//    NSString *signature = @"EEA8F606967D4AE1A7F4BBEDCE13EF40";
    NSString *signature = @"E623BBD8FDD844F9BC71A3514054F4BD";
    if (isBodyJson)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:headParameter];
        NSString *token = [dictionary objectForKey:@"token"];
        [dictionary removeObjectForKey:@"token"];
        NSString *sortString = APQueryStringFromParameters(dictionary);
        if ([token isNotBlank])
        {
            sortString = [token stringByAppendingString:sortString];
        }
        NSString *bodyString = [requestParameter modelToJSONString];
        if ([bodyString isNotBlank])
        {
            sortString = [sortString stringByAppendingString:bodyString];
        }
        NSString *encryption = [sortString stringByAppendingString:signature];
        return [encryption md5String];
    }
    else
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary addEntriesFromDictionary:headParameter];
        [dictionary addEntriesFromDictionary:requestParameter];
        NSString *token = [dictionary objectForKey:@"token"];
        [dictionary removeObjectForKey:@"token"];
        NSString *sortString = APQueryStringFromParameters(dictionary);
        if ([token isNotBlank])
        {
            sortString = [token stringByAppendingString:sortString];
        }
        NSString *encryption = [sortString stringByAppendingString:signature];
        // NSLog(@"=====：%@",encryption);
        // NSLog(@"MD5：%@",[encryption md5String]);
        return [encryption md5String];
    }
}

- (NSString *)cacheKeyWithParameters:(NSDictionary *)parameters apiName:(NSString *)apiName{
    return [NSString stringWithFormat:@"%@%@",apiName,parameters ? parameters : @""];
}

@end

@implementation WCApiManager (Login)

//  用户登录是否需要验证码
- (RACSignal *)fetchLoginHasCodeWithMobile:(NSString *)mobile{
    NSString *apiName = @"/login/fetchLoginHasVerifycode";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([mobile isNotBlank]) {
        [parameters setObject:mobile forKey:@"mobile"];
    }
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//手机号登录
- (RACSignal *)loginWithMobile:(NSString *)mobile invitecode:(NSString *)invitecode verifycode:(NSString *)verifycode wxLoginId:(NSString *)wxLoginId{
    NSString *apiName = iPhoneLogin_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([mobile isNotBlank]) {
        [parameters setObject:mobile forKey:@"mobile"];
    }
    if ([invitecode isNotBlank]) {
        [parameters setObject:invitecode forKey:@"invitecode"];
    }
    if ([verifycode isNotBlank]) {
        [parameters setObject:verifycode forKey:@"verifycode"];
    }
    if ([wxLoginId isNotBlank]) {
        [parameters setObject:wxLoginId forKey:@"wxLoginId"];
    }
    
    @weakify(self);
    return [[self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:WCLoginModel.class url:kHostUrl] doNext:^(WCLoginModel *loginModel) {
        @strongify(self);
        loginModel.isLogin = YES;
        self.loginModel = loginModel;
        [self.cache setObject:loginModel forKey:gUserKey];
        [[PBCache shared] setMemberModel:loginModel];
    }];
}
//  发送验证码
- (RACSignal *)ApiSendVerifyCodeWithMobile:(NSString *)mobile{
    NSString *apiName = SendVerifyCode_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([mobile isNotBlank]) {
        [parameters setObject:mobile forKey:@"mobile"];
    }
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}

@end

@implementation WCApiManager (other)

//获取离线收益(如果返回空对象。则没有收益)
- (RACSignal *)ApiOfflineProfit{
    NSString *apiName = OfflineProfit_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:OfflineProfitModel.class url:kHostUrl];
}
#pragma mark 建筑
//获取朝代信息
- (RACSignal *)getFetchDynastyInfo{
    NSString *apiName = FetchDynasty_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:DynastyModel.class url:kHostUrl];
}
//升级建筑
- (RACSignal *)updateStructure:(NSInteger)structureid{
    NSString *apiName = UpdateStructure_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(structureid) forKey:@"sturctureId"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:DynastyBuildModel.class url:kHostUrl];
}
//下一个朝代信息
- (RACSignal *)ApiNextDynasty:(NSInteger)dynasty{
    NSString *apiName = NextDynasty_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(dynasty) forKey:@"dynasty"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:DynastyModel.class url:kHostUrl];
}
//朝代翻篇
- (RACSignal *)ApiDynastyFanPian{
    NSString *apiName = DynastyFanPian_URL;
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:nil apiName:apiName resultClass:DynastyFanPianModel.class url:kHostUrl];
}
//朝代重置
- (RACSignal *)ApiDynastyReset{
    NSString *apiName = DynastyReset_URL;
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:nil apiName:apiName resultClass:DynastyFanPianModel.class url:kHostUrl];
}
//获取典故卡信息
- (RACSignal *)ApiAllusionInfo{
    NSString *apiName = Allusion_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//兑换典故卡
- (RACSignal *)ApiAllusionMergeWithType:(NSString *)mergeType starLevel:(NSInteger)number{
    NSString *apiName = AllusionMerge_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:mergeType forKey:@"mergeType"];
    [parameters setObject:@(number) forKey:@"number"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:MergeSuccessModel.class url:kHostUrl];
}
//获取金币不足视频
- (RACSignal *)ApiGoldNotEnoughVideo{
    NSString *apiName = GoldNotEnough_URL;
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:nil apiName:apiName resultClass:VideoModel.class url:kHostUrl];
}
#pragma mark 授权
//获取阿里授权账户
- (RACSignal *)ApiGetAliAutoAccount{
    NSString *apiName = AliAutoAccount_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:AliStsOssModel.class url:kHostUrl];
}
#pragma mark account用户
//获取未领取现金红包
- (RACSignal *)ApiNoReceiveCashBonus{
    NSString *apiName = NoReceiveCashBonus_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//领取现金红包
- (RACSignal *)ApiReceiveCashBonusWithCashId:(NSInteger)cashid{
    NSString *apiName = ReceiveCashBonus_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(cashid) forKey:@"id"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//获取未领取福豆
- (RACSignal *)ApiNoReceiveFoton{
    NSString *apiName = NoReceiveFoton_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//领取福豆
- (RACSignal *)ApiReceiveFotonWithFotonId:(NSInteger)fotonid{
    NSString *apiName = ReceiveFoton_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(fotonid) forKey:@"id"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}

//获取金币、福豆信息
- (RACSignal *)ApiGlodAndFudou{
    NSString *apiName = GoldAndFudou_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:GoldModel.class url:kHostUrl];;
}

/// 今日分红记录
/// @param limit 每页大小
/// @param page 起始页
- (RACSignal *)fetchDateProfitRecord:(NSInteger)limit
                                page:(NSInteger)page
{
    NSString *apiName = FetchDateProfitRecord_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:RecordListModel.class url:kHostUrl];
}

/// 获取用户通信录记录
/// @param page 起始页
/// @param limit 页面大小
- (RACSignal *)fetchUserContacts:(NSInteger)page
                           limit:(NSInteger)limit
{
    NSString *apiName = FetchUserContacts_RUL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    [parameters setObject:@"" forKey:@"type"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:ContentModel.class url:kHostUrl];
}
//修改手机号
- (RACSignal *)ApiUpdateMobilePhone:(NSString *)phoneNumber code:(NSString *)code{
    NSString *apiName = UpdateMobilePhone_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phoneNumber forKey:@"mobile"];
    [parameters setObject:code forKey:@"code"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//获取提现配置
- (RACSignal *)ApiReflectConfig{
    NSString *apiName = ReflectConfig_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:ReflectConfigModel.class url:kHostUrl];
}
//获取用户账户信息
- (RACSignal *)ApiUserAccountInfo{
    NSString *apiName = UserAccount_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:UserAccountModel.class url:kHostUrl];
}
//获取用户实名信息
- (RACSignal *)ApiUserShiMingInfo{
    NSString *apiName = UserShiMing_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:ShiMingModel.class url:kHostUrl];
}
//提现
- (RACSignal *)ApiWithdrawalWithPayType:(NSString *)withdrawType userBankId:(NSString *)userBankId userWithdrawConfigId:(NSInteger)userWithdrawConfigId{
    NSString *apiName = Withdrawal_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:withdrawType forKey:@"withdrawType"];
    if ([userBankId isNotBlank]) {
        [parameters setObject:userBankId forKey:@"userBankId"];
    }
    [parameters setObject:@(userWithdrawConfigId) forKey:@"userWithdrawConfigId"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//收支明细
- (RACSignal *)ApiGetIncomeDetail:(NSInteger)page limit:(NSInteger)limit{
    NSString *apiName = IncomeDetail_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}
//提现明细
- (RACSignal *)ApiGetWithdrawDetail:(NSInteger)page limit:(NSInteger)limit{
    NSString *apiName = WithdrawDetail_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}
//实名
- (RACSignal *)ApiShiMing:(NSString *)name idcard:(NSString *)idcard aliAccount:(NSString *)aliAccount{
    NSString *apiName = ShiMing_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:idcard forKey:@"idcard"];
    [parameters setObject:aliAccount forKey:@"aliAccount"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}

#pragma mark 抽奖
//获取抽奖列表
- (RACSignal *)fetchLotteryList{
    NSString *apiName = LotteryList_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:LotteryListModel.class url:kHostUrl];
}
/// 领抽奖券
- (RACSignal *)receiveVoucher
{
    NSString *apiName = ReceiveVoucher_URL;
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:nil apiName:apiName resultClass:VideoModel.class url:kHostUrl];
}
/// 抽奖
- (RACSignal *)winLottery
{
    NSString *apiName = WinLottery_URL;
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:nil apiName:apiName resultClass:WinLotteryModel.class url:kHostUrl];
}

/// 获取排行榜
/// @param rankType 排行榜类型, GOLD_COINS:金币排行，PROFIT：财神果排行，EARNINGS：收益排行
- (RACSignal *)ApiFetchRank:(NSString *)rankType
{
    NSString *apiName = FetchRank_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:rankType forKey:@"rankType"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}

#pragma mark 签到
//签到详情
- (RACSignal *)ApiSignInInfo{
    NSString *apiName = SignInInfo_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:SigninVoModel.class url:kHostUrl];
}
- (RACSignal *)ApiSignIn{
    NSString *apiName = SignIn_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:VideoModel.class url:kHostUrl];
}

#pragma mark 视频
/// 观看广告完成后回调
/// @param advertId 广告k流水ID
- (RACSignal *)WatchFinish:(NSString *)advertId
{
    NSString *apiName = WatchFinish_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:advertId forKey:@"advertId"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}

#pragma mark 我的
//消息
- (RACSignal *)ApiMessage:(NSInteger)page limit:(NSInteger)limit{
    NSString *apiName = Message_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}
//系统公告
- (RACSignal *)ApiSystemContent{
    NSString *apiName = SystemContent_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:MessageModel.class url:kHostUrl];
}

#pragma mark 淘金
//获取用户可收取金币信息
- (RACSignal *)ApiUserGold{
    NSString *apiName = UserPick_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//收取金币
- (RACSignal *)ApiCollectGold:(NSInteger)GoldId{
    NSString *apiName = PickRed_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(GoldId) forKey:@"id"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:RedPackageModel.class url:kHostUrl];
}
//偷取金币
- (RACSignal *)ApiStealGold:(NSInteger)GoldId{
    NSString *apiName = StealRed_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(GoldId) forKey:@"id"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:RedPackageModel.class url:kHostUrl];
}
//获取可夺金币用户
- (RACSignal *)ApiTakeRedList{
    NSString *apiName = TakeRedList_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//获取用户可偷金币信息
- (RACSignal *)ApiUserStealGoldInfo:(NSInteger)userid{
    NSString *apiName = StealUserGold_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(userid) forKey:@"userId"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//获取用户红包被偷取记录 userid用户id  page页码  limit每页数据数量
- (RACSignal *)ApiStealRedLogs:(NSInteger)userid page:(NSInteger)page limit:(NSInteger)limit{
    NSString *apiName = StealRedLogs_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(userid) forKey:@"userId"];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}

#pragma mark 战队
//用户下级/间推人数
- (RACSignal *)ApiTeamSubCount{
    NSString *apiName = TeamSubCount_url;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:UserTeamModel.class url:kHostUrl];
}
//未实名收益及人数
- (RACSignal *)ApiTeamUncertMoney{
    NSString *apiName = TeamUncertMoney_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:UncertInfoVoModel.class url:kHostUrl];
}
//战队收益
- (RACSignal *)ApiTeamIncome{
    NSString *apiName = TeamTotalIncome_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:UserTeamModel.class url:kHostUrl];
}
//今日战队收益
- (RACSignal *)ApiTeamIncomeToday{
    NSString *apiName = TeamIncomeToday_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:UserTeamModel.class url:kHostUrl];
}
//好友列表
/*
 下级类型 1-直推 2-间推subType
 page,1开始
 size 页面大小
 */
- (RACSignal *)ApiUserFriendList:(NSInteger)subType page:(NSInteger)page size:(NSInteger)size{
    NSString *apiName = TeamUserFriend_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(subType) forKey:@"subType"];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(size) forKey:@"size"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}
//通讯录好友  type 1:已注册用户 0 未注册用户 不传所有
- (RACSignal *)ApiUserContactFriend:(NSInteger)type page:(NSInteger)page limit:(NSInteger)limit{
    NSString *apiName = TeamContactFriend_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (type) {
        [parameters setObject:@(type) forKey:@"type"];
    }
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}
//同步通讯录好友 上传服务器
- (RACSignal *)ApiUserSyncContacts:(NSDictionary *)parameters{
    NSString *apiName = TeamSyncContacts_URL;
    return  [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//战友今日贡献  今日收益明细
/*
 type  1今天 2所有
 */
- (RACSignal *)ApiTeamTodayProfitDetail:(NSInteger)type page:(NSInteger)page limit:(NSInteger)limit{
    NSString *apiName = TeamTodayProfit_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(type) forKey:@"type"];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}
//是否是合伙人
- (RACSignal *)ApiTeamPartnerInfo{
    NSString *apiName = TeamPartner_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
#pragma mark 任务
//获取任务列表
- (RACSignal *)ApiTaskList:(NSInteger)limit type:(NSString *)type{
    NSString *apiName = TaskList_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:type forKey:@"type"];
    if (limit) {
        [parameters setObject:@(limit) forKey:@"limit"];
    }
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//娱乐页面轮播信息
- (RACSignal *)ApiYuLeScrollNews{
    NSString *apiName = YuLeScrollNews_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//获取娱乐列表
- (RACSignal *)ApiYuleListWithLimit:(NSInteger)limit{
    NSString *apiName = YuLeList_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}

#pragma mark 答题、PK
//pk首页
- (RACSignal *)ApiPKShouYe{
    NSString *apiName = PKShouYe_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:PKShouyeModel.class url:kHostUrl];
}
//个人pk信息
- (RACSignal *)ApiPKPersonInfo{
    NSString *apiName = PKPersonInfo_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:PKPersonInfoModel.class url:kHostUrl];
}
//创建战队
- (RACSignal *)ApiPKCreateTeam{
    NSString *apiName = PKTeamCreate_URL;
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//获取战队pk信息
- (RACSignal *)ApiPKTeamInfo{
    NSString *apiName = PKTeamInfo_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:PKTeamInfoModel.class url:kHostUrl];
}
//获取团队简单信息
- (RACSignal *)ApiPKTeamSinpleInfo:(NSInteger)teamid{
    NSString *apiName = PKTeamSimpleInfo_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(teamid) forKey:@"groupId"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:PKTeamInfoModel.class url:kHostUrl];
}
//开始挑战
- (RACSignal *)ApiPKStart:(NSString *)subType{
    NSString *apiName = PKStartBattle_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:subType forKey:@"battleType"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//获取题目
- (RACSignal *)ApiPKGetSubject:(NSString *)subType code:(NSString *)code limit:(NSInteger)limit{
    NSString *apiName = PKGetSubject_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:subType forKey:@"battleType"];
    [parameters setObject:code forKey:@"code"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//答题
- (RACSignal *)ApiPKAnswerWithCode:(NSString *)code subjectInvokeId:(NSString *)subjectInvokeId optionId:(NSInteger)optionId battleType:(NSString *)battleType{
    NSString *apiName = PKAnswer_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:code forKey:@"code"];
    [parameters setObject:subjectInvokeId forKey:@"subjectInvokeId"];
    [parameters setObject:@(optionId) forKey:@"optionId"];
    [parameters setObject:battleType forKey:@"battleType"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:PKAnswerModel.class url:kHostUrl];
}
//获取战队用户信息
- (RACSignal *)ApiPKTeamUserInfo:(NSInteger)groupId{
    NSString *apiName = PKTeamUserInfo_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(groupId) forKey:@"groupId"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//获取复活卡数量
- (RACSignal *)ApiPKRebirthCount{
    NSString *apiName = PKRebirthCount_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//加入战队
- (RACSignal *)ApiPKJoinTeamGroupid:(NSInteger)groupId{
    NSString *apiName = PKJoinTeam_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(groupId) forKey:@"groupId"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//获取复活信息
- (RACSignal *)ApiPkRebirthInfo:(NSString *)battleType{
    NSString *apiName = PKRebirthInfo_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:battleType forKey:@"battleType"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:PKRebirthModel.class url:kHostUrl];
}
//复活
- (RACSignal *)ApiPKRebirtn:(NSString *)battleType{
    NSString *apiName = PKRebirth_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:battleType forKey:@"battleType"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:PKRebirthModel.class url:kHostUrl];
}
//用户领取复活卡信息
- (RACSignal *)ApiPKRecevieCardInfo{
    NSString *apiName = PKRecevieCardInfo_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//领取复活卡
- (RACSignal *)ApiPKRecevieCard{
    NSString *apiName = PKRecevieCard_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:VideoModel.class url:kHostUrl];
}
//个人pk排行
- (RACSignal *)ApiPKPersonRankInfo:(NSString *)dateStr{
    NSString *apiName = PKPersonRank_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:dateStr forKey:@"date"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//团队pk排行
- (RACSignal *)ApiPKTeamRankInfo:(NSString *)dateStr{
    NSString *apiName = PKTeamRank_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:dateStr forKey:@"date"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}

#pragma mark 用户
//获取用户复杂信息
- (RACSignal *)ApiUserInfo:(NSInteger)userid{
    NSString *apiName = UserInfo_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(userid) forKey:@"userId"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:UserModel.class url:kHostUrl];
}
//修改用户信息
- (RACSignal *)ApiModifyUserInfoWithAvatar:(NSString *)avatar nickname:(NSString *)nickname qq:(NSString *)qq weixin:(NSString *)weixin{
    NSString *apiName = ModifyUserInfo_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([avatar isNotBlank]) {
        [parameters setObject:avatar forKey:@"avatar"];
    }
    if ([nickname isNotBlank]) {
        [parameters setObject:nickname forKey:@"nickname"];
    }
    if ([qq isNotBlank]) {
        [parameters setObject:qq forKey:@"qq"];
    }
    if ([weixin isNotBlank]) {
        [parameters setObject:weixin forKey:@"weixin"];
    }
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//意见反馈
- (RACSignal *)ApiFeedBack:(NSString *)feedBack{
    NSString *apiName = FeedBack_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:feedBack forKey:@"content"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}
//绑定邀请码
- (RACSignal *)ApiBindInviteCode:(NSString *)invitecode{
    NSString *apiName = BindInvitaCode_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:invitecode forKey:@"invitecode"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:nil url:kHostUrl];
}

#pragma mark 分红
//我的分红
- (RACSignal *)ApiMyBonus{
    NSString *apiName = MyBonus_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:BonusModel.class url:kHostUrl];
}
//分红进度
- (RACSignal *)ApiBonusProgress{
    NSString *apiName = BonusProgress_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:BonusProgressModel.class url:kHostUrl];
}
//平台分红
- (RACSignal *)ApiPlatformBonus{
    NSString *apiName = PlatformBonus_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:BonusModel.class url:kHostUrl];
}
//福豆兑换商品的商品信息
- (RACSignal *)ApiGetFotonGoodsWithPage:(NSInteger)page size:(NSInteger)size{
    NSString *apiName = FotonGoods_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(size) forKey:@"size"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}
//福豆兑换商品
- (RACSignal *)ApiFotonExchangeGoods:(NSInteger)goodsid{
    NSString *apiName = FotonExchangeGoods_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(goodsid) forKey:@"id"];
    return [self customRequestWithMethod:RequestMethod_Post isJson:NO parameters:parameters apiName:apiName resultClass:FotonExchangeModel.class url:kHostUrl];
}
//获取福豆明细
- (RACSignal *)ApiFotonRecordWithPage:(NSInteger)page limit:(NSInteger)limit{
    NSString *apiName = FotonRecord_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}
//获取当前用户的的限时分红列表
- (RACSignal *)ApiUserLimitBonusList{
    NSString *apiName = UserLimitBonusList_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//获取当前用户的到期的限时分红列表
- (RACSignal *)ApiUserExpireBonusList{
    NSString *apiName = UserExpireBonusList_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}
//今日分红记录
- (RACSignal *)ApiTodayBonusRecordWithDateStr:(NSString *)date page:(NSInteger)page limit:(NSInteger)limit{
    NSString *apiName = BonusRecord_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:date forKey:@"date"];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}

#pragma mark 系统配置
//获取系统配置
- (RACSignal *)ApiSystemConfigs{
    NSString *apiName = SystemConfig_url;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:SystemModel.class url:kHostUrl];
}
#pragma mark 获取用户任务完成进度列表
- (RACSignal *)ApiUserFinishTask:(NSInteger)page limit:(NSInteger)limit{
    NSString *apiName = UserTaskFinish_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:parameters apiName:apiName resultClass:WCBaseModel.class url:kHostUrl];
}
//获取用户任务完成提示列表
- (RACSignal *)ApiUserFinishTaskLog{
    NSString *apiName = UserTaskFinishLog_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}

#pragma mark 版本更新
- (RACSignal *)ApiVersionUpdate{
    NSString *apiName = VersionUpdate_URL;
    return [self customRequestWithMethod:RequestMethod_Get isJson:NO parameters:nil apiName:apiName resultClass:nil url:kHostUrl];
}

@end
