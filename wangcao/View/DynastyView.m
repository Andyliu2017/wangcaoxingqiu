//
//  DynastyView.m
//  wangcao
//
//  Created by EDZ on 2020/5/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import "DynastyView.h"

@interface DynastyView()

@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UILabel *dynastyName;  //朝代名称
@property (nonatomic,strong) UIImageView *dynastyImg;  //朝代背景图
@property (nonatomic,strong) UILabel *dynastyLabel;  //翻篇、重置
@property (nonatomic,assign) NSInteger dType; //1 进入新朝代  2 重置

@end

@implementation DynastyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    self.dynastyView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:self.dynastyView];
    [self.dynastyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(spaceHeight(196));
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(1132));
    }];
    
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(82, 50, 130, 1) alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.dynastyView addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.dynastyView);
        make.top.mas_equalTo(ANDY_Adapta(175));
        make.height.mas_equalTo(ANDY_Adapta(809));
    }];
    
    self.whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.dynastyView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.dynastyView);
        make.top.mas_equalTo(ANDY_Adapta(165));
        make.height.mas_equalTo(ANDY_Adapta(809));
    }];
    
    UIImageView *headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_head"]];
    [self.dynastyView addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.centerX.mas_equalTo(self.dynastyView);
        make.width.mas_equalTo(ANDY_Adapta(474));
        make.height.mas_equalTo(ANDY_Adapta(228));
    }];
    
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:[UIColor whiteColor] text:@"闯关成功" Radius:0];
    [headImg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(headImg.mas_bottom).offset(-ANDY_Adapta(32));
        make.centerX.mas_equalTo(headImg);
        make.height.mas_equalTo(ANDY_Adapta(85));
    }];
    
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
//    [closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
//    [self.dynastyView addSubview:closeBtn];
//    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.whiteView.mas_top).offset(-ANDY_Adapta(38));
//        make.right.mas_equalTo(self.whiteView.mas_right).offset(-ANDY_Adapta(4));
//        make.width.and.height.mas_equalTo(ANDY_Adapta(53));
//    }];
    
    self.dynastyLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(14) textColor:TitleColor text:@"恭喜您进入一个新的朝代！" Radius:0];
    [self.whiteView addSubview:self.dynastyLabel];
    [self.dynastyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImg.mas_bottom);
        make.left.and.right.mas_equalTo(self.whiteView);
        make.height.mas_equalTo(ANDY_Adapta(70));
    }];
    
    self.dynastyName = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:RGBA(153, 58, 20, 1) text:@"" Radius:0];
    [self.whiteView addSubview:self.dynastyName];
    [self.dynastyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dynastyLabel.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(55));
        make.left.and.right.mas_equalTo(self.whiteView);
    }];
    self.dynastyImg = [[UIImageView alloc] init];
    self.dynastyImg.backgroundColor = MessageColor;
    self.dynastyImg.layer.cornerRadius = ANDY_Adapta(20);
    self.dynastyImg.layer.masksToBounds = YES;
    [self.whiteView addSubview:self.dynastyImg];
    [self.dynastyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.dynastyName.mas_bottom).offset(ANDY_Adapta(40));
        make.width.mas_equalTo(ANDY_Adapta(413));
        make.height.mas_equalTo(ANDY_Adapta(533));
    }];
    
    //继续经营
    UIButton *goOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goOnBtn addTarget:self action:@selector(goOnAction) forControlEvents:UIControlEventTouchUpInside];
    [goOnBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn"] forState:UIControlStateNormal];
    [goOnBtn setTitle:@"继续经营" forState:UIControlStateNormal];
    goOnBtn.titleLabel.font = FontBold_(17);
    [self.dynastyView addSubview:goOnBtn];
    [goOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.dynastyView.mas_bottom);
        make.centerX.mas_equalTo(self.dynastyView);
        make.width.mas_equalTo(ANDY_Adapta(500));
        make.height.mas_equalTo(ANDY_Adapta(110));
    }];
}
//加载数据
- (void)loadData:(DynastyModel *)model type:(NSInteger)type{
    self.dynastyName.text = model.dynastyName;
    [self.dynastyImg setImageURL:[NSURL URLWithString:model.backgroundImg]];
    self.dType = type;
    if (type == 1) {
        self.dynastyLabel.text = @"恭喜您进入一个新的朝代！";
    }else{
        self.dynastyLabel.text = @"朝代重置";
    }
}
//继续经营
- (void)goOnAction{
    [self.delegate goOnOperation:self.dType];
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
    [self showWithAlert:self.dynastyView];
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
