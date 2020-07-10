//
//  DianGuKaView.m
//  wangcao
//
//  Created by EDZ on 2020/5/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import "DianGuKaView.h"

@interface DianGuKaView()

@property (nonatomic,strong) UIView *dgkView;
@property (nonatomic,strong) UIImageView *dgkImg;
@property (nonatomic,strong) UILabel *titleLabel1;
@property (nonatomic,strong) UILabel *titleLabel2;
@property (nonatomic,strong) UILabel *titleLabel3;
@property (nonatomic,strong) UILabel *titleLabel4;
@property (nonatomic,strong) UILabel *descLabel;

@property (nonatomic,strong) UIImageView *starImg1;
@property (nonatomic,strong) UIImageView *starImg2;
@property (nonatomic,strong) UIImageView *starImg3;
@property (nonatomic,strong) UIImageView *starImg4;
@property (nonatomic,strong) UIImageView *starImg5;

@property (nonatomic,strong) UIButton *comfireBtn;

@end

@implementation DianGuKaView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    self.dgkView = [[UIView alloc] init];
    [self addSubview:self.dgkView];
    [self.dgkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(spaceHeight(400));
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(900));
    }];
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dgk_bg"]];
    [self.dgkView addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.dgkView);
        make.height.mas_equalTo(ANDY_Adapta(774));
    }];
    self.dgkImg = [[UIImageView alloc] init];
    [bgImg addSubview:self.dgkImg];
    [self.dgkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(16));
        make.top.mas_equalTo(ANDY_Adapta(16));
        make.width.mas_equalTo(ANDY_Adapta(525));
        make.height.mas_equalTo(ANDY_Adapta(155));
    }];
    
    self.titleLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(27) textColor:TitleColor text:@"" Radius:ANDY_Adapta(8)];
    self.titleLabel2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(27) textColor:TitleColor text:@"" Radius:ANDY_Adapta(8)];
    self.titleLabel3 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(27) textColor:TitleColor text:@"" Radius:ANDY_Adapta(8)];
    self.titleLabel4 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(27) textColor:TitleColor text:@"" Radius:ANDY_Adapta(8)];
    
    NSArray *labelArr = @[self.titleLabel1,self.titleLabel2,self.titleLabel3,self.titleLabel4];
    for (int i = 0; i < labelArr.count; i++) {
        UILabel *titleLabel = labelArr[i];
        titleLabel.layer.borderWidth = ANDY_Adapta(3);
        titleLabel.layer.borderColor = RGBA(143, 95, 56, 1).CGColor;
        [bgImg addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dgkImg.mas_bottom).offset(ANDY_Adapta(9));
            make.width.and.height.mas_equalTo(ANDY_Adapta(93));
            make.left.mas_equalTo(ANDY_Adapta(87)+i*ANDY_Adapta(111));
        }];
    }
    
    UIView *descView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(16) borderWidth:ANDY_Adapta(3) borderColor:RGBA(143, 95, 56, 1)];
    [bgImg addSubview:descView];
    [descView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImg);
        make.top.mas_equalTo(self.titleLabel1.mas_bottom).offset(ANDY_Adapta(22));
        make.width.mas_equalTo(ANDY_Adapta(445));
        make.height.mas_equalTo(ANDY_Adapta(300));
    }];
    
    UILabel *desclabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(13) textColor:RGBA(108, 59, 21, 1) text:@"注释：" Radius:0];
    [descView addSubview:desclabel1];
    [desclabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(22));
        make.top.mas_equalTo(ANDY_Adapta(20));
    }];
    
    self.descLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:FontBold_(12) textColor:RGBA(108, 59, 21, 1) text:@"" Radius:0];
    [descView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(desclabel1.mas_left);
        make.top.mas_equalTo(desclabel1.mas_bottom).offset(ANDY_Adapta(20));
        make.width.mas_equalTo(ANDY_Adapta(405));
    }];
    
    self.starImg1 = [[UIImageView alloc] init];
    self.starImg2 = [[UIImageView alloc] init];
    self.starImg3 = [[UIImageView alloc] init];
    self.starImg4 = [[UIImageView alloc] init];
    self.starImg5 = [[UIImageView alloc] init];
    NSArray *imgArr = @[self.starImg1,self.starImg2,self.starImg3,self.starImg4,self.starImg5];
    for (int i = 0; i < imgArr.count; i++) {
        UIImageView *img = [self starImg:imgArr[i]];
        [bgImg addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-ANDY_Adapta(36));
            make.width.and.height.mas_equalTo(ANDY_Adapta(87));
            make.left.mas_equalTo(ANDY_Adapta(47)+ANDY_Adapta(105)*i);
        }];
    }
    
    self.comfireBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"收下典故卡" click:^(id  _Nonnull x) {
        [self closeAction];
    }];
    [self.comfireBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
    [self.dgkView addSubview:self.comfireBtn];
    [self.comfireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self.dgkView);
        make.height.mas_equalTo(ANDY_Adapta(110));
        make.width.mas_equalTo(ANDY_Adapta(500));
    }];
}

- (UIImageView *)starImg:(UIImageView *)starImg{
    UIImageView *starBgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dgk_star_bg"]];
    [starBgImg addSubview:starImg];
    [starImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(starBgImg);
        make.width.and.height.mas_equalTo(ANDY_Adapta(65));
    }];
    return starBgImg;
}

- (void)setData:(DianGuKaModel *)model withType:(NSInteger)type{
    if (type == 1) {
        [self.comfireBtn setTitle:@"收下典故卡" forState:UIControlStateNormal];
    }else{
        [self.comfireBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    [self.dgkImg setImageWithURL:[NSURL URLWithString:model.allusionBackgroundImg] placeholder:[UIImage imageNamed:@""]];
    if (model.allusionName.length == 4) {
        self.titleLabel1.text = [model.allusionName substringWithRange:NSMakeRange(0, 1)];
        self.titleLabel2.text = [model.allusionName substringWithRange:NSMakeRange(1, 1)];
        self.titleLabel3.text = [model.allusionName substringWithRange:NSMakeRange(2, 1)];
        self.titleLabel4.text = [model.allusionName substringWithRange:NSMakeRange(3, 1)];
    }
    self.descLabel.text = model.allusionDesc;
    NSArray *imgArr = @[self.starImg1,self.starImg2,self.starImg3,self.starImg4,self.starImg5];
    for (int i = 0; i < imgArr.count; i++) {
        UIImageView *starImg = imgArr[i];
        if (model.star > i) {
            starImg.image = [UIImage imageNamed:@"dgk_star2"];
        }else{
            starImg.image = [UIImage imageNamed:@"dgk_star1"];
        }
    }
}

- (void)closeAction{
    [UIView animateWithDuration:0.6f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
}
- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.dgkView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
/**
 添加Alert入场动画
 @param alert 添加动画的View
 */
- (void)showWithAlert:(UIView*)alert
{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.6;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

@end
