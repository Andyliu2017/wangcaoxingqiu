//
//  BonusRecordCell.m
//  wangcao
//
//  Created by EDZ on 2020/6/2.
//  Copyright © 2020 andy. All rights reserved.
//

#import "BonusRecordCell.h"

@interface BonusRecordCell()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *nickNameLabel;
@property (nonatomic,strong) UILabel *yuxiLabel;
@property (nonatomic,strong) UILabel *moneyLabel;

@end

@implementation BonusRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCellUI];
    }
    return self;
}

- (void)createCellUI{
    UIView *yuxiView = [[UIView alloc] init];
    [self addSubview:yuxiView];
    [yuxiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.top.mas_equalTo(self);
        make.width.mas_equalTo(SCREENWIDTH/3.0);
        make.height.mas_equalTo(ANDY_Adapta(100));
    }];
    self.yuxiLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [yuxiView addSubview:self.yuxiLabel];
    [self.yuxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.top.and.bottom.mas_equalTo(yuxiView);
    }];
    self.moneyLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(14) textColor:MoneyColor text:@"" Radius:0];
    [self addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(yuxiView);
        make.left.mas_equalTo(yuxiView.mas_right);
        make.right.mas_equalTo(self);
    }];
    
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.cornerRadius = ANDY_Adapta(27);
    self.headImg.layer.masksToBounds = YES;
    [self addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(yuxiView);
        make.left.mas_equalTo(ANDY_Adapta(40));
        make.width.and.height.mas_equalTo(ANDY_Adapta(54));
    }];
    
    self.nickNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [self addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).offset(ANDY_Adapta(15));
        make.centerY.mas_equalTo(self.headImg);
    }];
}

- (void)setData:(BonusRecordModel *)model{
    [self.headImg setImageWithURL:[NSURL URLWithString:model.userInfo.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.nickNameLabel.text = model.userInfo.nickName;
    self.yuxiLabel.text = [NSString stringWithFormat:@"%ld",model.sealCount];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",model.totalAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
