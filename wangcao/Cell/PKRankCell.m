//
//  PKRankCell.m
//  wangcao
//
//  Created by EDZ on 2020/5/30.
//  Copyright © 2020 andy. All rights reserved.
//

#import "PKRankCell.h"

@interface PKRankCell()

//名次图片  1、2、3名
@property (nonatomic,strong) UIImageView *rankImg;
//名次label  3名之后
@property (nonatomic,strong) UILabel *rankLabel;
//头像
@property (nonatomic,strong) UIImageView *headImg;
//昵称
@property (nonatomic,strong) UILabel *nickLabel;
//队伍信息
@property (nonatomic,strong) UILabel *teamInfoLabel;
//收益
@property (nonatomic,strong) UILabel *profitLabel;
//红包图片
@property (nonatomic,strong) UIImageView *redImg;
//答题数
@property (nonatomic,strong) UILabel *answerLabel;

@end

@implementation PKRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubview];
    }
    return self;
}
- (void)setSubview{
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
        make.width.mas_equalTo(ANDY_Adapta(160));
    }];
    
    self.teamInfoLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:RankColor text:@"" Radius:0];
    [self addSubview:self.teamInfoLabel];
    [self.teamInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self.nickLabel);
        make.bottom.mas_equalTo(self.headImg.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(26));
    }];
    
    self.profitLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(14) textColor:MoneyColor text:@"" Radius:0];
    [self addSubview:self.profitLabel];
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-ANDY_Adapta(30));
        make.centerY.mas_equalTo(self);
    }];
    
    self.redImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_redPack"]];
    [self addSubview:self.redImg];
    [self.redImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.profitLabel.mas_left).offset(-ANDY_Adapta(2));
        make.centerY.mas_equalTo(self);
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    
    self.answerLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:MessageColor text:@"" Radius:0];
    [self addSubview:self.answerLabel];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickLabel.mas_right).offset(ANDY_Adapta(5));
        make.centerY.mas_equalTo(self);
    }];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = RGBA(238, 238, 238, 1);
    [self addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(620));
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
}

- (void)setData:(PKTeamInfoModel *)model withIndex:(NSInteger)index withType:(NSInteger)type{
    if (index <= 3) {
        self.rankImg.hidden = NO;
        self.rankLabel.hidden = YES;
        self.rankImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_rank%ld",index]];
    }else{
        self.rankImg.hidden = YES;
        self.rankLabel.hidden = NO;
        self.rankLabel.text = [NSString stringWithFormat:@"%ld",index];
    }
    [self.headImg setImageWithURL:[NSURL URLWithString:model.userInfo.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    if (type == 1) {  //团队
        self.nickLabel.text = model.groupName;
        self.teamInfoLabel.text = [NSString stringWithFormat:@"队伍%ld人",model.groupPeoples];
        self.teamInfoLabel.hidden = NO;
    }else{    //个人
        self.nickLabel.text = model.userInfo.nickName;
        self.teamInfoLabel.hidden = YES;
    }
    self.profitLabel.text = [NSString stringWithFormat:@"%.2f元",model.settleAmount];
    
    self.answerLabel.text = [NSString stringWithFormat:@"%ld题",model.answerNumber];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
