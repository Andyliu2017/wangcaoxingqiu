//
//  PKOptionModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKOptionModel : NSObject

//id (integer, optional),
@property (nonatomic,assign) NSInteger option_id;
//optionText (string, optional)
@property (nonatomic,copy) NSString *optionText;

@end

NS_ASSUME_NONNULL_END
