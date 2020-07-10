//
//  TaoJinCell.m
//  wangcao
//
//  Created by EDZ on 2020/5/18.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TaoJinCell.h"

@interface TaoJinCell()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *nickNameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *goldLabel;

@end

@implementation TaoJinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.cornerRadius = ANDY_Adapta(50);
    self.headImg.layer.masksToBounds = YES;
    [self addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.centerY.mas_equalTo(self);
        make.width.and.height.mas_equalTo(ANDY_Adapta(100));
    }];
    self.nickNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    [self addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_top);
        make.left.mas_equalTo(self.headImg.mas_right).offset(ANDY_Adapta(20));
        make.height.mas_equalTo(ANDY_Adapta(50));
        make.width.mas_equalTo(ANDY_Adapta(240));
    }];
    self.timeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:GrayColor text:@"" Radius:0];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom);
        make.left.and.width.mas_equalTo(self.nickNameLabel);
        make.height.mas_equalTo(ANDY_Adapta(30));
    }];
    
    self.goldLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(13) textColor:RGBA(254, 172, 56, 1) text:@"" Radius:0];
    [self addSubview:self.goldLabel];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickNameLabel.mas_right);
        make.top.and.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(-ANDY_Adapta(40));
    }];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = LineColor;
    [self addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(642));
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
}

- (void)setData:(RecviedRedModel *)model{
    [self.headImg setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.nickNameLabel.text = model.nickName;
    self.timeLabel.text = [Tools transToTime:model.createTime];
    self.goldLabel.text = [NSString stringWithFormat:@"收取了%ldg",model.amount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
