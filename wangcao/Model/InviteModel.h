//
//  InviteModel.h
//  wangcao
//
//  Created by EDZ on 2020/6/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteModel : NSObject

//avatar (string, optional): 用户头像 ,
@property (nonatomic,copy) NSString *avatar;
//c (integer, optional): 完成数量 ,
@property (nonatomic,assign) NSInteger c;
//limitend (integer, optional): 距离结束到期的秒数 ,
@property (nonatomic,assign) NSInteger limitend;
//nickName (string, optional): 用户别名 ,
@property (nonatomic,copy) NSString *nickName;
//userid (integer, optional): 用户id
@property (nonatomic,assign) NSInteger userid;

@end

NS_ASSUME_NONNULL_END
