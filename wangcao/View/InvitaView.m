//
//  InvitaView.m
//  wangcao
//
//  Created by EDZ on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import "InvitaView.h"

#define owerBgColor RGBA(255, 202, 20, 1)
#define owerBgColor1 RGBA(244, 244, 255, 1)
#define owserColor RGBA(153, 58, 20, 1)
#define personColor RGBA(255, 255, 255, 1)

@interface InvitaView()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *headImgView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *nickNameLabel;
@property (nonatomic,strong) UILabel *bottomLabel;
@property (nonatomic,strong) UILabel *owerLabel;   //房主

@end

@implementation InvitaView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
//    ANDY_Adapta(188), ANDY_Adapta(214))
    self.bgView = [GGUI ui_view:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) backgroundColor:[UIColor clearColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:ANDY_Adapta(3) borderColor:RGBA(100, 83, 181, 1)];
    self.bgView.clipsToBounds = YES;
    [self addSubview:self.bgView];
    self.headImgView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(244, 244, 255, 1) alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.bgView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView.mas_top).offset(ANDY_Adapta(3));
        make.width.mas_equalTo(ANDY_Adapta(182));
        make.height.mas_equalTo(ANDY_Adapta(161));
    }];
    
    self.owerLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(11) textColor:owserColor text:@"房主" Radius:0];
    self.owerLabel.backgroundColor = RGBA(255, 229, 141, 1);
    [self.headImgView addSubview:self.owerLabel];
    [self.owerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(self.headImgView);
        make.height.mas_equalTo(ANDY_Adapta(30));
        make.width.mas_equalTo(ANDY_Adapta(60));
    }];
    
    self.bottomLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:RGBA(153, 58, 20, 1) text:@"" Radius:0];
    [self.bgView addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImgView.mas_bottom);
        make.centerX.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-ANDY_Adapta(3));
        make.width.mas_equalTo(ANDY_Adapta(182));
    }];
    
    self.headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_invita"]];
    self.headImg.layer.cornerRadius = ANDY_Adapta(45);
    self.headImg.layer.masksToBounds = YES;
    [self.headImgView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(24));
        make.centerX.mas_equalTo(self.headImgView);
        make.width.and.height.mas_equalTo(ANDY_Adapta(90));
    }];
    self.nickNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:owserColor text:@"" Radius:0];
    [self.headImgView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.headImgView);
        make.top.mas_equalTo(self.headImg.mas_bottom);
    }];
}

- (void)setData:(TeamNumberModel *)model withType:(NSInteger)type{
    if (type == 1) {
        if (model.ower) {
            self.headImgView.backgroundColor = owerBgColor;
            self.nickNameLabel.textColor = owserColor;
            self.bottomLabel.textColor = owserColor;
            self.bottomLabel.backgroundColor = [UIColor whiteColor];
            self.owerLabel.hidden = NO;
        }else{
            self.headImgView.backgroundColor = owerBgColor1;
            self.nickNameLabel.textColor = RGBA(94, 90, 186, 1);
            self.bottomLabel.textColor = [UIColor whiteColor];
            self.bottomLabel.backgroundColor = RGBA(100, 83, 181, 1);
            self.owerLabel.hidden = YES;
        }
        self.nickNameLabel.text = model.nickName;
        self.bottomLabel.text = [NSString stringWithFormat:@"答对%ld题",model.answerNumber];
        [self.headImg setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    }else{
        self.headImgView.backgroundColor = owerBgColor1;
        self.headImg.image = [UIImage imageNamed:@"pk_invita"];
        self.nickNameLabel.text = @"";
        self.bottomLabel.backgroundColor = RGBA(196, 186, 248, 1);
        self.bottomLabel.text = @"";
        self.owerLabel.hidden = YES;
    }
}

@end
