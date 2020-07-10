//
//  TaojinCell1.m
//  wangcao
//
//  Created by EDZ on 2020/5/29.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TaojinCell1.h"

@interface TaojinCell1()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation TaojinCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.cornerRadius = ANDY_Adapta(47);
    self.headImg.layer.masksToBounds = YES;
    [self addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.width.and.height.mas_equalTo(ANDY_Adapta(94));
    }];
    
    UIImageView *cellBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taojin_cellbg"]];
    [self addSubview:cellBg];
    [cellBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.headImg.mas_right).offset(ANDY_Adapta(32));
        make.width.mas_equalTo(ANDY_Adapta(551));
        make.height.mas_equalTo(ANDY_Adapta(120));
    }];
    
    self.contentLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:RGBA(153, 58, 20, 1) text:@"" Radius:0];
    [cellBg addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(47));
        make.centerY.mas_equalTo(cellBg);
    }];
}

- (void)setData:(RecviedRedModel *)model{
    [self.headImg setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.contentLabel.text = [NSString stringWithFormat:@"%@来淘金，-%ldg",model.nickName,model.amount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
