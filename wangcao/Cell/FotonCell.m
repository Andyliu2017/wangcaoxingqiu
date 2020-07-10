//
//  FotonCell.m
//  wangcao
//
//  Created by EDZ on 2020/5/23.
//  Copyright © 2020 andy. All rights reserved.
//

#import "FotonCell.h"

@interface FotonCell()

@property (nonatomic,strong) UILabel *fotonType;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *fotonNum;

@end

@implementation FotonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.fotonType = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [self addSubview:self.fotonType];
    [self.fotonType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(29));
        make.top.mas_equalTo(ANDY_Adapta(40));
    }];
    
    self.timeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:GrayColor text:@"" Radius:0];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(29));
        make.top.mas_equalTo(self.fotonType.mas_bottom).offset(ANDY_Adapta(15));
    }];
    
    self.fotonNum = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(14) textColor:MoneyColor text:@"" Radius:0];
    [self addSubview:self.fotonNum];
    [self.fotonNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(-ANDY_Adapta(29));
    }];
}
//福豆
- (void)setData:(FotonModel *)model{
    self.fotonType.text = model.operInfo;
    self.timeLabel.text = [Tools transToTime:model.occurTime];
    if (model.blessBean > 0) {
        self.fotonNum.text = [NSString stringWithFormat:@"+%ld",model.blessBean];
    }else{
        self.fotonNum.text = [NSString stringWithFormat:@"%ld",model.blessBean];
    }
}
//资金明细
- (void)setMoneyDetailData:(MoneyRecordModel *)model{
    self.fotonType.text = model.operInfo;
    self.timeLabel.text = [Tools transToTime:model.occurTime];
    self.fotonNum.text = [NSString stringWithFormat:@"%@元",model.money];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
