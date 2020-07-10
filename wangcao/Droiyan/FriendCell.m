//
//  FriendCell.m
//  wangcao
//
//  Created by EDZ on 2020/5/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import "FriendCell.h"

@interface FriendCell()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *chaodaiLabel;
@property (nonatomic,strong) UIButton *inviatBtn;

@end

@implementation FriendCell

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
        make.top.mas_equalTo(self.headImg.mas_top);
        make.height.mas_equalTo(ANDY_Adapta(40));
        make.width.mas_equalTo(ANDY_Adapta(363));
    }];
    self.timeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:MessageColor text:@"" Radius:0];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self.userNameLabel);
        make.top.mas_equalTo(self.userNameLabel.mas_bottom);
        make.bottom.mas_equalTo(self.headImg.mas_bottom);
    }];
    self.chaodaiLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(14) textColor:RGBA(241, 139, 40, 1) text:@"" Radius:0];
    self.chaodaiLabel.hidden = YES;
    [self addSubview:self.chaodaiLabel];
    [self.chaodaiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNameLabel.mas_right);
        make.right.mas_equalTo(self.mas_right).offset(-ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(self);
    }];
    
    self.inviatBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(12) normalColor:[UIColor whiteColor] normalText:@"邀请" click:^(id  _Nonnull x) {
        
    }];
    self.inviatBtn.hidden = YES;
    self.inviatBtn.layer.cornerRadius = ANDY_Adapta(27);
    self.inviatBtn.layer.masksToBounds = YES;
    [self.inviatBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    [self addSubview:self.inviatBtn];
    [self.inviatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(-ANDY_Adapta(32));
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

- (void)setData:(TeamNumberModel *)model withType:(NSInteger)type{
    if (type != 2) {
        self.chaodaiLabel.hidden = NO;
        self.inviatBtn.hidden = YES;
    }else{
        if (model.contactUid) {
            self.chaodaiLabel.hidden = YES;
            self.inviatBtn.hidden = NO;
        }else{
            self.chaodaiLabel.hidden = NO;
            self.inviatBtn.hidden = YES;
        }
    }
    [self.headImg setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    if (model.status) {
        self.userNameLabel.text = [NSString stringWithFormat:@"%@(已激活)",model.nickName];
    }else{
        self.userNameLabel.text = [NSString stringWithFormat:@"%@(未激活)",model.nickName];
    }
    self.timeLabel.text = [Tools transToTime:model.createTime];
    self.chaodaiLabel.text = model.dynastyName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
