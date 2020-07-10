//
//  PaopaoButton.m
//  wangcao
//
//  Created by EDZ on 2020/6/2.
//  Copyright © 2020 andy. All rights reserved.
//

#import "PaopaoButton.h"

@implementation PaopaoButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:RGBA(255, 202, 20, 1) forState:UIControlStateNormal];
    self.titleLabel.font = FontBold_(12);
    [self setBackgroundImage:[UIImage imageNamed:@"sy_paopao"] forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
//    self.imageView.frame.origin.y = self.height * 0.15;
//    self.imageView.width = self.width * 0.5;
//    self.imageView.height = self.imageView.width;
//    self.imageView.centerX = self.width * 0.5;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(ANDY_Adapta(8));
        make.width.and.height.mas_equalTo(ANDY_Adapta(46));
    }];
    
    self.imageView.frame = CGRectMake(ANDY_Adapta(27), ANDY_Adapta(8), ANDY_Adapta(46), ANDY_Adapta(46));
    
    // 调整文字
//    self.titleLabel.x = 0;
//    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
//    self.titleLabel.width = self.width;
//    self.titleLabel.height = self.height - self.titleLabel.y;
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self);
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-ANDY_Adapta(20));
//        make.height.mas_equalTo(ANDY_Adapta(25));
//    }];
    self.titleLabel.frame = CGRectMake(0, ANDY_Adapta(57), self.frame.size.width, ANDY_Adapta(25));
}

@end
