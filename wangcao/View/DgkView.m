//
//  DgkView.m
//  wangcao
//
//  Created by EDZ on 2020/5/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import "DgkView.h"

@interface DgkView()

//width 107+6  height 6+107+14

//典故卡数量 圆圈
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UIImageView *iconImg;
//典故卡名称
@property (nonatomic,strong) UILabel *nameLabel1;
@property (nonatomic,strong) UILabel *nameLabel2;

//星星
@property (nonatomic,strong) UIImageView *starImg1;
@property (nonatomic,strong) UIImageView *starImg2;
@property (nonatomic,strong) UIImageView *starImg3;
@property (nonatomic,strong) UIImageView *starImg4;
@property (nonatomic,strong) UIImageView *starImg5;
@property (nonatomic,assign) NSInteger starNum;  //典故卡星星数量
@property (nonatomic,assign) NSInteger starLevel;  //星级

@property (nonatomic,strong) UIButton *dgkBtn;

@end

@implementation DgkView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    self.iconImg = [[UIImageView alloc] init];
    self.iconImg.backgroundColor = RGBA(204, 204, 204, 1);
    self.iconImg.layer.cornerRadius = ANDY_Adapta(10);
    self.iconImg.layer.masksToBounds = YES;
    [self addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(ANDY_Adapta(6));
        make.width.and.height.mas_equalTo(ANDY_Adapta(107));
    }];
    
    self.numberLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(10) textColor:[UIColor whiteColor] text:@"" Radius:0];
    self.numberLabel.backgroundColor = RGBA(0, 0, 0, 0.5);
    self.numberLabel.layer.cornerRadius = ANDY_Adapta(17);
    self.numberLabel.layer.masksToBounds = YES;
    [self addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.mas_equalTo(self);
        make.width.and.height.mas_equalTo(ANDY_Adapta(34));
    }];
    
    self.nameLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(17) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.iconImg addSubview:self.nameLabel1];
    [self.nameLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_centerY);
    }];
    self.nameLabel2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(17) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.iconImg addSubview:self.nameLabel2];
    [self.nameLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_centerY);
    }];
    
    self.dgkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dgkBtn addTarget:self action:@selector(dgkAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.dgkBtn];
    [self.dgkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self);
    }];
}

- (void)dgkAction{
    [self.delegate diangukaPopView:self.model];
}

- (void)setDgkStarLevelData:(NSInteger)starlevel{
    self.starLevel = starlevel;
    [self setStar];
}
//画星星
- (void)setStar{
    self.starImg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dgk_small_star1"]];
    self.starImg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dgk_small_star1"]];
    self.starImg3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dgk_small_star1"]];
    self.starImg4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dgk_small_star1"]];
    self.starImg5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dgk_small_star1"]];
    NSArray *starImgArr = @[self.starImg1,self.starImg2,self.starImg3,self.starImg4,self.starImg5];
    if (self.starLevel == 1) {
        self.starImg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dgk_small_star1"]];
        [self addSubview:self.starImg1];
        [self.starImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.bottom.mas_equalTo(self);
            make.width.and.height.mas_equalTo(ANDY_Adapta(28));
        }];
    }else if (self.starLevel == 2){
        for (int i = 0; i < 2; i++) {
            UIImageView *starimg = starImgArr[i];
            [self addSubview:starimg];
            [starimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self);
                make.width.and.height.mas_equalTo(ANDY_Adapta(28));
                make.left.mas_equalTo(ANDY_Adapta(36)+i*ANDY_Adapta(13));
            }];
        }
    }else if (self.starLevel == 3){
        for (int i = 0; i < 3; i++) {
            UIImageView *starimg = starImgArr[i];
            [self addSubview:starimg];
            [starimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self);
                make.width.and.height.mas_equalTo(ANDY_Adapta(28));
                make.left.mas_equalTo(ANDY_Adapta(31)+i*ANDY_Adapta(13));
            }];
        }
    }else if (self.starLevel == 4){
        for (int i = 0; i < 4; i++) {
            UIImageView *starimg = starImgArr[i];
            [self addSubview:starimg];
            [starimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self);
                make.width.and.height.mas_equalTo(ANDY_Adapta(28));
                make.left.mas_equalTo(ANDY_Adapta(22)+i*ANDY_Adapta(13));
            }];
        }
    }else if (self.starLevel == 5){
        for (int i = 0; i < 5; i++) {
            UIImageView *starimg = starImgArr[i];
            [self addSubview:starimg];
            [starimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self);
                make.width.and.height.mas_equalTo(ANDY_Adapta(28));
                make.left.mas_equalTo(ANDY_Adapta(16)+i*ANDY_Adapta(13));
            }];
        }
    }
}

- (void)setDgkViewData:(DianGuKaModel *)model{
    self.model = model;
    if (model.number > 0) {
        self.dgkBtn.enabled = YES;
    }else{
        self.dgkBtn.enabled = NO;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",model.number];
    self.nameLabel1.text = [model.allusionName substringWithRange:NSMakeRange(0, 2)];
    self.nameLabel2.text = [model.allusionName substringWithRange:NSMakeRange(2, 2)];
    if (model.number > 0) {
        self.iconImg.image = [UIImage imageNamed:@"dgk_small_bg"];
        self.nameLabel1.textColor = RGBA(153, 58, 20, 1);
        self.nameLabel2.textColor = RGBA(153, 58, 20, 1);
        [self setStarImg:@"dgk_small_star2" starlevel:model.star];
    }else{
        self.iconImg.image = [UIImage imageNamed:@""];
        self.nameLabel1.textColor = [UIColor whiteColor];
        self.nameLabel2.textColor = [UIColor whiteColor];
        [self setStarImg:@"dgk_small_star1" starlevel:model.star];
    }
}

- (void)setStarImg:(NSString *)imgName starlevel:(NSInteger)star{
    switch (star) {
        case 1:
            self.starImg1.image = [UIImage imageNamed:imgName];
            break;
        case 2:
            self.starImg1.image = [UIImage imageNamed:imgName];
            self.starImg2.image = [UIImage imageNamed:imgName];
            break;
        case 3:
            self.starImg1.image = [UIImage imageNamed:imgName];
            self.starImg2.image = [UIImage imageNamed:imgName];
            self.starImg3.image = [UIImage imageNamed:imgName];
            break;
        case 4:
            self.starImg1.image = [UIImage imageNamed:imgName];
            self.starImg2.image = [UIImage imageNamed:imgName];
            self.starImg3.image = [UIImage imageNamed:imgName];
            self.starImg4.image = [UIImage imageNamed:imgName];
            break;
        case 5:
            self.starImg1.image = [UIImage imageNamed:imgName];
            self.starImg2.image = [UIImage imageNamed:imgName];
            self.starImg3.image = [UIImage imageNamed:imgName];
            self.starImg4.image = [UIImage imageNamed:imgName];
            self.starImg5.image = [UIImage imageNamed:imgName];
            break;
        default:
            break;
    }
}

@end
