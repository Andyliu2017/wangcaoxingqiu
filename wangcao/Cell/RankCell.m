//
//  RankCell.m
//  wangcao
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 andy. All rights reserved.
//

#import "RankCell.h"

//#define RankColor RGBA(236, 167, 60, 1)

@interface RankCell()
//名次图片  1、2、3名
@property (nonatomic,strong) UIImageView *rankImg;
//名次label  3名之后
@property (nonatomic,strong) UILabel *rankLabel;
//头像
@property (nonatomic,strong) UIImageView *headImg;
//昵称
@property (nonatomic,strong) UILabel *nickLabel;
//朝代信息
@property (nonatomic,strong) UILabel *chaodaiLabel;
//金币、典故卡、收益 数量
@property (nonatomic,strong) UILabel *numberLabel;

@end

@implementation RankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellUI];
    }
    return self;
}
- (void)createCellUI{
    self.rankImg = [[UIImageView alloc] init];
    [self addSubview:self.rankImg];
    [self.rankImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(ANDY_Adapta(26));
        make.width.and.height.mas_equalTo(ANDY_Adapta(68));
    }];
    self.rankLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(16) textColor:RankColor text:@"" Radius:0];
    [self addSubview:self.rankLabel];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.rankImg);
    }];
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.cornerRadius = ANDY_Adapta(34);
    self.headImg.layer.masksToBounds = YES;
    [self addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.width.mas_equalTo(self.rankImg);
        make.left.mas_equalTo(self.rankImg.mas_right).offset(ANDY_Adapta(10));
    }];
    self.nickLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [self addSubview:self.nickLabel];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg);
        make.left.mas_equalTo(self.headImg.mas_right).offset(ANDY_Adapta(10));
        make.height.mas_equalTo(ANDY_Adapta(34));
        make.width.mas_equalTo(ANDY_Adapta(220));
    }];
    self.chaodaiLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:RankColor text:@"" Radius:0];
    [self addSubview:self.chaodaiLabel];
    [self.chaodaiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self.nickLabel);
        make.bottom.mas_equalTo(self.headImg.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(26));
    }];
    self.numberLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(16) textColor:RankColor text:@"" Radius:0];
    [self addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickLabel.mas_right);
        make.right.mas_equalTo(self).inset(ANDY_Adapta(34));
        make.top.and.bottom.mas_equalTo(0);
    }];
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = LineColor;
    [self addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(580));
        make.height.mas_equalTo(ANDY_Adapta(2));
    }];
}

- (void)setData:(RankModel *)model index:(NSInteger)index type:(NSString *)type{
    if (index <= 3) {
        self.rankImg.hidden = NO;
        self.rankLabel.hidden = YES;
        self.rankImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_rank%ld",index]];
    }else{
        self.rankImg.hidden = YES;
        self.rankLabel.hidden = NO;
        self.rankLabel.text = [NSString stringWithFormat:@"%ld",index];
    }
    [self.headImg setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@""]];
    self.nickLabel.text = model.nickName;
    self.chaodaiLabel.text = model.dynastyName;
    if ([type isEqualToString:GOLDRANK]) {
        NSString *goldStr = [NSString stringWithFormat:@"%.0f",model.goldCoins];
        self.numberLabel.text = [NSString stringWithFormat:@"%@",[GGUI goldConversion:goldStr]];
    }else if ([type isEqualToString:DIANGUKARANK]){
        self.numberLabel.text = [NSString stringWithFormat:@"%ld张",model.allusionCount];
    }else if ([type isEqualToString:PROFITRANK]){
        self.numberLabel.text = [NSString stringWithFormat:@"%.2f元",model.price];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
