//
//  InviteCell.m
//  wangcao
//
//  Created by EDZ on 2020/6/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import "InviteCell.h"

@interface InviteCell()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UIImageView *statusImg1;   //小圆点
@property (nonatomic,strong) UIImageView *statusImg2;
@property (nonatomic,strong) UIImageView *statusImg3;
@property (nonatomic,strong) UIImageView *statusImg4;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) NSArray *statusArr;

@end

@implementation InviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubview];
    }
    return self;
}

- (void)setSubview{
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = RGBA(238, 238, 238, 1.0);
    [self addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.top.mas_equalTo(self);
        make.height.mas_equalTo(ANDY_Adapta(1));
        make.width.mas_equalTo(ANDY_Adapta(622));
    }];
    UIImageView *headimg = [[UIImageView alloc] init];
    headimg.layer.cornerRadius = ANDY_Adapta(30);
    headimg.layer.masksToBounds = YES;
    [self addSubview:headimg];
    [headimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(58));
        make.top.mas_equalTo(ANDY_Adapta(27));
        make.width.and.height.mas_equalTo(ANDY_Adapta(60));
    }];
    self.headImg = headimg;
    
    UILabel *username = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:TitleColor text:@"" Radius:0];
    [self addSubview:username];
    [username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headimg);
        make.top.mas_equalTo(headimg.mas_bottom).offset(ANDY_Adapta(10));
    }];
    self.userNameLabel = username;
    
    UIImageView *statusimg1 = [[UIImageView alloc] init];
    statusimg1.layer.cornerRadius = ANDY_Adapta(11);
    statusimg1.layer.masksToBounds = YES;
    statusimg1.backgroundColor = RGBA(238, 238, 238, 1.0);
    [self addSubview:statusimg1];
    [statusimg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headimg.mas_right).offset(ANDY_Adapta(40));
        make.centerY.mas_equalTo(headimg);
        make.width.and.height.mas_equalTo(ANDY_Adapta(22));
    }];
    self.statusImg1 = statusimg1;
    UIImageView *statusLineImg1 = [[UIImageView alloc] init];
    statusLineImg1.backgroundColor = RGBA(238, 238, 238, 1.0);
    [self addSubview:statusLineImg1];
    [statusLineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(statusimg1.mas_right);
        make.centerY.mas_equalTo(statusimg1);
        make.width.mas_equalTo(ANDY_Adapta(80));
        make.height.mas_equalTo(ANDY_Adapta(3));
    }];
    
    UIImageView *statusimg2 = [[UIImageView alloc] init];
    statusimg2.layer.cornerRadius = ANDY_Adapta(11);
    statusimg2.layer.masksToBounds = YES;
    statusimg2.backgroundColor = RGBA(238, 238, 238, 1.0);
    [self addSubview:statusimg2];
    [statusimg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(statusLineImg1.mas_right);
        make.centerY.mas_equalTo(headimg);
        make.width.and.height.mas_equalTo(ANDY_Adapta(22));
    }];
    self.statusImg2 = statusimg2;
    UIImageView *statusLineImg2 = [[UIImageView alloc] init];
    statusLineImg2.backgroundColor = RGBA(238, 238, 238, 1.0);
    [self addSubview:statusLineImg2];
    [statusLineImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(statusimg2.mas_right);
        make.centerY.mas_equalTo(statusimg2);
        make.width.mas_equalTo(ANDY_Adapta(80));
        make.height.mas_equalTo(ANDY_Adapta(3));
    }];
    
    UIImageView *statusimg3 = [[UIImageView alloc] init];
    statusimg3.layer.cornerRadius = ANDY_Adapta(11);
    statusimg3.layer.masksToBounds = YES;
    statusimg3.backgroundColor = RGBA(238, 238, 238, 1.0);
    [self addSubview:statusimg3];
    [statusimg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(statusLineImg2.mas_right);
        make.centerY.mas_equalTo(headimg);
        make.width.and.height.mas_equalTo(ANDY_Adapta(22));
    }];
    self.statusImg3 = statusimg3;
    UIImageView *statusLineImg3 = [[UIImageView alloc] init];
    statusLineImg3.backgroundColor = RGBA(238, 238, 238, 1.0);
    [self addSubview:statusLineImg3];
    [statusLineImg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(statusimg3.mas_right);
        make.centerY.mas_equalTo(statusimg3);
        make.width.mas_equalTo(ANDY_Adapta(80));
        make.height.mas_equalTo(ANDY_Adapta(3));
    }];
    
    UIImageView *statusimg4 = [[UIImageView alloc] init];
    statusimg4.layer.cornerRadius = ANDY_Adapta(11);
    statusimg4.layer.masksToBounds = YES;
    statusimg4.backgroundColor = RGBA(238, 238, 238, 1.0);
    [self addSubview:statusimg4];
    [statusimg4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(statusLineImg3.mas_right);
        make.centerY.mas_equalTo(headimg);
        make.width.and.height.mas_equalTo(ANDY_Adapta(22));
    }];
    self.statusImg4 = statusimg4;
    
    UIButton *btn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(12) normalColor:[UIColor whiteColor] normalText:@"提醒TA" click:^(id  _Nonnull x) {
        self.inviteblock();
    }];
    [btn setBackgroundColor:RankColor];
    btn.layer.cornerRadius = ANDY_Adapta(27);
    btn.layer.masksToBounds = YES;
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headimg);
        make.left.mas_equalTo(statusimg4.mas_right).offset(ANDY_Adapta(40));
        make.width.mas_equalTo(ANDY_Adapta(130));
        make.height.mas_equalTo(ANDY_Adapta(54));
    }];
    self.button = btn;
    
    UILabel *time = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:MessageColor text:@"" Radius:0];
    [self addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btn);
        make.centerY.mas_equalTo(username);
    }];
    self.timeLabel = time;
    
    self.statusArr = @[self.statusImg1,self.statusImg2,self.statusImg3,self.statusImg4];
}

- (void)setData:(InviteModel *)model{
    [self.headImg setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.userNameLabel.text = model.nickName;
    self.timeLabel.text = [GGUI timeFormatted:model.limitend type:0];
    for (int i = 0; i < self.statusArr.count; i++) {
        UIImageView *image = self.statusArr[i];
        if (i <= model.c) {
            image.backgroundColor = RankColor;
        }else{
            image.backgroundColor = RGBA(238, 238, 238, 1.0);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
