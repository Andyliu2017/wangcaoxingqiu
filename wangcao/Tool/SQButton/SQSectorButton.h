//
//  KDSectorButton.h
//  koudaizikao
//
//  Created by lsq on 15/12/1.
//  Copyright © 2015年 withustudy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQSectorButton : UIButton

@property (nonatomic,assign)NSInteger tapCount;

@property (nonatomic,assign)NSInteger ChipCount;

@property (nonatomic,assign)NSInteger Chip_rebet;

@property (nonatomic,assign)NSInteger Chip_end;

@property (nonatomic,strong)NSString *namekey;

///下注类型 三数100 分注200 街注300 角注400 线注600 
@property (nonatomic,assign)NSInteger type;

@property (nonatomic,assign)NSInteger MaxLimit;
@property (nonatomic,assign)NSInteger MinLimit;


@end
