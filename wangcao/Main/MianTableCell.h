//
//  MianTableCell.h
//  wangcao
//
//  Created by EDZ on 2020/5/7.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//dyModel 升级返回的建筑信息  index升级的哪个建筑
typedef void(^sjBlcok)(DynastyBuildModel *dyModel,NSInteger index,NSInteger money);

@interface MianTableCell : UITableViewCell
//建筑图片
@property (nonatomic,strong) UIImageView *dynastyImg;
//建筑名称
@property (nonatomic,strong) UILabel *dynastyNameLabel;
//升级进度
@property (nonatomic,strong) UIProgressView *progressView;
//下一次消耗金币
@property (nonatomic,strong) UILabel *nextGoldLabel;
//解锁
@property (nonatomic,strong) UILabel *unlockLabel;
@property (nonatomic,strong) UIImageView *unlockImg;
//升级需要消耗的金币
@property (nonatomic,strong) UILabel *needGoldLabel;
@property (nonatomic,strong) UIButton *unlockBtn;

@property (nonatomic,copy) sjBlcok sjblock;

//设置数据
- (void)setData:(DynastyBuildModel *)model index:(NSInteger)dynum;
 
@end

NS_ASSUME_NONNULL_END
