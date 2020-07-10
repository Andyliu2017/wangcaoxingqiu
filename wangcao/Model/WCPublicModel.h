//
//  WCPublicModel.h
//  wangcao
//
//  Created by liu dequan on 2020/4/29.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCPublicModel : NSObject

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *data;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *requestId;

@end

NS_ASSUME_NONNULL_END
