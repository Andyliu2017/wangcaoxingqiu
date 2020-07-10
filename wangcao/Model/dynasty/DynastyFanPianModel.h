//
//  DynastyFanPianModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/16.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DianGuKaModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynastyFanPianModel : NSObject

@property (nonatomic,strong) DianGuKaModel *allusion;
@property (nonatomic,strong) DynastyModel *userDynasty;

@end

NS_ASSUME_NONNULL_END
