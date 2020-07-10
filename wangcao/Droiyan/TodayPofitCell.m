//
//  TodayPofitCell.m
//  wangcao
//
//  Created by EDZ on 2020/6/2.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TodayPofitCell.h"

@interface TodayPofitCell()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *gongxianLabel;
@property (nonatomic,strong) UILabel *moneyLabel;

@end

@implementation TodayPofitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self cellUI];
    }
    return self;
}
- (void)cellUI{
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.cornerRadius = ANDY_Adapta(35);
    self.headImg.layer.masksToBounds = YES;
    [self addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.width.and.height.mas_equalTo(ANDY_Adapta(70));
    }];
    self.userNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [self addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).mas_offset(ANDY_Adapta(20));
        make.centerY.mas_equalTo(self);
    }];
//    self.timeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:MessageColor text:@"" Radius:0];
//    [self addSubview:self.timeLabel];
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.width.mas_equalTo(self.userNameLabel);
//        make.top.mas_equalTo(self.userNameLabel.mas_bottom);
//        make.bottom.mas_equalTo(self.headImg.mas_bottom);
//    }];
    
    self.moneyLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(14) textColor:MoneyColor text:@"" Radius:0];
    [self addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-ANDY_Adapta(29));
        make.centerY.mas_equalTo(self);
    }];
    
    self.gongxianLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(14) textColor:LineColor text:@"贡献" Radius:0];
    [self addSubview:self.gongxianLabel];
    [self.gongxianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.moneyLabel.mas_left).offset(-ANDY_Adapta(5));
        make.centerY.mas_equalTo(self);
    }];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = GrayColor;
    [self addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
}

- (void)setData:(ProfitDetailModel *)model{
    [self.headImg setImageWithURL:[NSURL URLWithString:model.userInfo.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.userNameLabel.text = model.userInfo.nickName;
//    self.timeLabel.text = model
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",model.amount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
