//
//  MessageCell.m
//  wangcao
//
//  Created by EDZ on 2020/5/8.
//  Copyright © 2020 andy. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellUi];
    }
    return self;
}

- (void)createCellUi{                           
    //消息标题
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:MYTEXT_COLOR text:@"" Radius:0];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(65));
        make.top.mas_equalTo(ANDY_Adapta(10));
        make.height.mas_equalTo(ANDY_Adapta(65));
        make.width.mas_equalTo(ANDY_Adapta(392));
    }];
    //时间
    self.timeLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(11) textColor:MessageColor text:@"" Radius:0];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.top.and.bottom.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-ANDY_Adapta(30));
    }];
    self.contentLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:Font_(13) textColor:MessageColor text:@"" Radius:0];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(ANDY_Adapta(10));
        make.width.mas_equalTo(ANDY_Adapta(618));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-ANDY_Adapta(25));
    }];
}

- (void)setMessageData:(MessageModel *)model{
    self.titleLabel.text = model.title;
    self.timeLabel.text = [Tools transToTime:model.sendTime];
    self.contentLabel.text = model.content;
    NSLog(@"model.content:%@",model.content);
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.contentView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.top.mas_equalTo(self.contentView);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.bottom.mas_equalTo(self.contentLabel.mas_bottom).offset(ANDY_Adapta(15));
    }];
    [self.contentView sendSubviewToBack:whiteView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
