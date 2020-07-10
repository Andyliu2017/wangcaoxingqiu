//
//  StealListModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/13.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StealListModel : NSObject

//avatar (string, optional): 用户头像 ,
//nickName (string, optional): 用户昵称 ,
//steal (boolean, optional): 偷取标识，true:可偷取、false：不可偷取 ,
//userId (integer, optional): 用户ID
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,assign) BOOL steal;
@property (nonatomic,assign) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
