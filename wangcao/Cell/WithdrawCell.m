//
//  WithdrawCell.m
//  wangcao
//
//  Created by EDZ on 2020/6/5.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WithdrawCell.h"

@interface WithdrawCell()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *amountNum;
@property (nonatomic,strong) UILabel *statsLabel;  //状态
@property (nonatomic,strong) UIImageView *statsImg;

@end

@implementation WithdrawCell

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
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"提现金额" Radius:0];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(29));
        make.top.mas_equalTo(ANDY_Adapta(40));
    }];
    
    self.timeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:GrayColor text:@"" Radius:0];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(29));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(ANDY_Adapta(15));
    }];
    
    self.amountNum = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(14) textColor:MoneyColor text:@"" Radius:0];
    [self addSubview:self.amountNum];
    [self.amountNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.mas_right).offset(-ANDY_Adapta(29));
    }];
    self.statsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_faile"]];
    [self addSubview:self.statsImg];
    
    self.statsLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(12) textColor:RGBA(71, 195, 93, 1) text:@"" Radius:0];
    [self addSubview:self.statsLabel];
}

- (void)setData:(WithdrawModel *)model{
    self.timeLabel.text = [Tools transToTime:model.applyTime];
    self.amountNum.text = [NSString stringWithFormat:@"%.2f元",model.realMoney/100.0];
    if (model.approveStatus == 0) {
        self.statsImg.hidden = YES;
        self.statsLabel.text = @"提现中";
        self.statsLabel.textColor = GrayColor;
        [self.statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timeLabel);
            make.right.mas_equalTo(self.amountNum.mas_right);
        }];
    }else if (model.approveStatus == 1){
        self.statsImg.hidden = YES;
        self.statsLabel.text = @"提现成功";
        self.statsLabel.textColor = GrayColor;
        [self.statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timeLabel);
            make.right.mas_equalTo(self.amountNum.mas_right);
        }];
    }else if (model.approveStatus == -1){
        self.statsImg.hidden = NO;
        self.statsLabel.text = @"失败";
        self.statsLabel.textColor = MoneyColor;
        [self.statsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timeLabel);
            make.right.mas_equalTo(self.amountNum.mas_right);
            make.width.and.height.mas_equalTo(ANDY_Adapta(22));
        }];
        [self.statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.statsImg);
            make.right.mas_equalTo(self.statsImg.mas_left).offset(-ANDY_Adapta(5));
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
