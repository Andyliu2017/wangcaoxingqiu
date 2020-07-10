//
//  OtherPopView.m
//  wangcao
//
//  Created by EDZ on 2020/5/21.
//  Copyright © 2020 andy. All rights reserved.
//

#import "OtherPopView.h"

#define BtnBgViewColor1 RGBA(196, 115, 42, 1)
#define BtnBgColor1 RGBA(254, 172, 56, 1)
#define BtnBgViewColor2 RGBA(82, 50, 130, 1)
#define BtnBgColor2 RGBA(100, 83, 181, 1)
#define BtnNoClickColr RGBA(204, 204, 204, 1)
#define BtnBgNoClickColr RGBA(170, 170, 170, 1)

@interface OtherPopView()

@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIView *answerView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UIView *whiteView;
//@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) PKRebirthModel *rebirthModel;
@property (nonatomic,assign) NSInteger viewType;  //弹窗类型  1答错题  2确定退出
//标题
@property (nonatomic,strong) UILabel *titleLabel;
//答题描述
@property (nonatomic,strong) UILabel *answerDescLabel;
@property (nonatomic,strong) UIButton *answerBtn1; //卡视频复活
@property (nonatomic,strong) UIView *answerBtnBg1;
@property (nonatomic,strong) UIButton *answerBtn2; //使用复活卡
@property (nonatomic,strong) UIView *answerBtnBg2;
@property (nonatomic,strong) UILabel *circularLabel1;  //小圆圈
@property (nonatomic,strong) UILabel *circularLabel2;  //小圆圈
@property (nonatomic,assign) NSInteger fhCardCount;  //复活卡数量
@property (nonatomic,assign) NSInteger reBirthCount; //看视频复活次数

@end

@implementation OtherPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        [self setSubView];
    }
    return self;
}

- (void)setSubView{
    self.answerView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self addSubview:self.answerView];
    [self.answerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(spaceHeight(350));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(642));
    }];
    
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.answerView addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(ANDY_Adapta(175));
        make.width.mas_equalTo(ANDY_Adapta(600));
        make.height.mas_equalTo(ANDY_Adapta(467));
    }];
    self.whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.answerView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(165));
        make.left.and.width.and.height.mas_equalTo(blackView);
    }];
    
    self.headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_head"]];
    [self.answerView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.answerView);
        make.width.mas_equalTo(ANDY_Adapta(474));
        make.height.mas_equalTo(ANDY_Adapta(228));
    }];
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.headImg addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImg.mas_bottom).offset(-ANDY_Adapta(32));
        make.centerX.mas_equalTo(self.headImg);
        make.height.mas_equalTo(ANDY_Adapta(85));
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.answerView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(self.answerView);
    }];
}
#pragma mark 答错题内容
- (void)setAnswerErrorUI{
    UIImageView *cryImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_cry"]];
    [self.whiteView addSubview:cryImg];
    [cryImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(ANDY_Adapta(6));
        make.centerX.mas_equalTo(self.whiteView);
        make.width.mas_equalTo(ANDY_Adapta(117));
        make.height.mas_equalTo(ANDY_Adapta(126));
    }];
    self.answerDescLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(15) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView addSubview:self.answerDescLabel];
    [self.answerDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(cryImg.mas_bottom).offset(ANDY_Adapta(25));
        make.height.mas_equalTo(ANDY_Adapta(32));
    }];
    UILabel *answerLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(15) textColor:TitleColor text:@"是否继续复活答题?" Radius:0];
    [self.whiteView addSubview:answerLabel];
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.answerDescLabel.mas_bottom).offset(ANDY_Adapta(1));
        make.height.mas_equalTo(ANDY_Adapta(32));
    }];
    
    self.answerBtnBg1 = [GGUI ui_view:CGRectZero backgroundColor:BtnBgViewColor1 alpha:1.0 cornerRadius:ANDY_Adapta(40) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.whiteView addSubview:self.answerBtnBg1];
    [self.answerBtnBg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(27));
        make.top.mas_equalTo(answerLabel.mas_bottom).offset(ANDY_Adapta(53));
        make.width.mas_equalTo(ANDY_Adapta(260));
        make.height.mas_equalTo(ANDY_Adapta(80));
    }];
    self.answerBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    if ([PBCache shared].memberModel.userType == 2) {
//        [self.answerBtn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    }else{
        [self.answerBtn1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(10))];
        [self.answerBtn1 setImage:[UIImage imageNamed:@"pop_videoicon"] forState:UIControlStateNormal];
//    }
    self.answerBtn1.enabled = NO;
    [self.answerBtn1 setTitle:@"复活" forState:UIControlStateNormal];
    [self.answerBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.answerBtn1 setBackgroundColor:BtnBgColor1];
    self.answerBtn1.titleLabel.font = FontBold_(14);
    self.answerBtn1.layer.cornerRadius = ANDY_Adapta(40);
    self.answerBtn1.layer.masksToBounds = YES;
    [self.answerBtn1 addTarget:self action:@selector(watchVideoRebirth) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.answerBtn1];
    [self.answerBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(self.answerBtnBg1);
        make.top.mas_equalTo(answerLabel.mas_bottom).offset(ANDY_Adapta(43));
    }];
    
    self.answerBtnBg2 = [GGUI ui_view:CGRectZero backgroundColor:BtnBgViewColor2 alpha:1.0 cornerRadius:ANDY_Adapta(40) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.whiteView addSubview:self.answerBtnBg2];
    [self.answerBtnBg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.whiteView.mas_right).offset(-ANDY_Adapta(27));
        make.top.mas_equalTo(answerLabel.mas_bottom).offset(ANDY_Adapta(53));
        make.width.mas_equalTo(ANDY_Adapta(260));
        make.height.mas_equalTo(ANDY_Adapta(80));
    }];
    self.answerBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.answerBtn2 setTitle:@"使用复活卡" forState:UIControlStateNormal];
    [self.answerBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.answerBtn2 setBackgroundColor:BtnBgColor2];
    self.answerBtn2.titleLabel.font = FontBold_(14);
    self.answerBtn2.layer.cornerRadius = ANDY_Adapta(40);
    self.answerBtn2.layer.masksToBounds = YES;
    [self.answerBtn2 addTarget:self action:@selector(rebirthAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.answerBtn2];
    [self.answerBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(self.answerBtnBg2);
        make.top.mas_equalTo(answerLabel.mas_bottom).offset(ANDY_Adapta(43));
    }];
    
    self.circularLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"" Radius:ANDY_Adapta(21)];
    self.circularLabel1.hidden = YES;
    self.circularLabel1.backgroundColor = [UIColor redColor];
    self.circularLabel1.layer.borderWidth = ANDY_Adapta(1);
    self.circularLabel1.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.whiteView addSubview:self.circularLabel1];
    [self.circularLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.answerBtn1.mas_top).offset(-ANDY_Adapta(15));
        make.right.mas_equalTo(self.answerBtn1.mas_right).offset(-ANDY_Adapta(4));
        make.width.and.height.mas_equalTo(ANDY_Adapta(42));
    }];
    self.circularLabel2 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(12) textColor:[UIColor whiteColor] text:@"" Radius:ANDY_Adapta(21)];
    self.circularLabel2.hidden = YES;
    self.circularLabel2.backgroundColor = [UIColor redColor];
    self.circularLabel2.layer.borderWidth = ANDY_Adapta(1);
    self.circularLabel2.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.whiteView addSubview:self.circularLabel2];
    [self.circularLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.answerBtn2.mas_top).offset(-ANDY_Adapta(15));
        make.right.mas_equalTo(self.answerBtn2.mas_right).offset(-ANDY_Adapta(4));
        make.width.and.height.mas_equalTo(ANDY_Adapta(42));
    }];
}
- (void)setAnswerErrorData:(NSInteger)correctNum fhCardNum:(NSInteger)fhCardNum reBirthNum:(NSInteger)reBirthNum viewType:(NSInteger)vType pkrebirthModel:(PKRebirthModel *)model{
    self.fhCardCount = fhCardNum;
    self.reBirthCount = reBirthNum;
    self.viewType = vType;
    self.rebirthModel = model;
    self.titleLabel.text = @"回答错误";
    self.answerDescLabel.text = [NSString stringWithFormat:@"你已答对%ld题",correctNum];
    if (fhCardNum == 0) {
        self.circularLabel2.hidden = YES;
        [self.answerBtn2 setBackgroundColor:BtnNoClickColr];
        self.answerBtnBg2.backgroundColor = BtnBgNoClickColr;
        self.answerBtn2.userInteractionEnabled = NO;
    }else{
        self.circularLabel2.hidden = NO;
        self.circularLabel2.text = [NSString stringWithFormat:@"%ld",fhCardNum];
        [self.answerBtn2 setBackgroundColor:BtnBgColor2];
        self.answerBtnBg2.backgroundColor = BtnBgViewColor2;
        self.answerBtn2.userInteractionEnabled = YES;
    }
    if (reBirthNum == 0) {
        self.circularLabel1.hidden = YES;
        [self.answerBtn1 setBackgroundColor:BtnNoClickColr];
        self.answerBtnBg1.backgroundColor = BtnBgNoClickColr;
        self.answerBtn1.userInteractionEnabled = NO;
    }else{
        self.circularLabel1.hidden = NO;
        self.circularLabel1.text = [NSString stringWithFormat:@"%ld",reBirthNum];
        [self.answerBtn1 setBackgroundColor:BtnBgColor1];
        self.answerBtnBg1.backgroundColor = BtnBgViewColor1;
        self.answerBtn1.userInteractionEnabled = YES;
    }
}
//答错之后 看视频复活
- (void)watchVideoRebirth{
//    if ([PBCache shared].memberModel.userType == 2) {
//        [self.delegate noVideoRebirth:self.rebirthModel];
//    }else{
        [self.delegate watchVideoRebirth:self.rebirthModel];
//    }
}
#pragma mark 确定退出
- (void)setDetermineExitUI{
    self.answerBtnBg1 = [GGUI ui_view:CGRectZero backgroundColor:BtnBgViewColor1 alpha:1.0 cornerRadius:ANDY_Adapta(40) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.whiteView addSubview:self.answerBtnBg1];
    [self.answerBtnBg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(27));
        make.bottom.mas_equalTo(self.whiteView.mas_bottom).offset(-ANDY_Adapta(50));
        make.width.mas_equalTo(ANDY_Adapta(260));
        make.height.mas_equalTo(ANDY_Adapta(80));
    }];
    self.answerBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.answerBtn1 setTitle:@"退出" forState:UIControlStateNormal];
    [self.answerBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.answerBtn1 setBackgroundColor:BtnBgColor1];
    self.answerBtn1.titleLabel.font = FontBold_(14);
    self.answerBtn1.layer.cornerRadius = ANDY_Adapta(40);
    self.answerBtn1.layer.masksToBounds = YES;
    [self.answerBtn1 addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.answerBtn1];
    [self.answerBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(self.answerBtnBg1);
        make.bottom.mas_equalTo(self.whiteView.mas_bottom).offset(-ANDY_Adapta(60));
    }];
    
    self.answerBtnBg2 = [GGUI ui_view:CGRectZero backgroundColor:BtnBgViewColor2 alpha:1.0 cornerRadius:ANDY_Adapta(40) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.whiteView addSubview:self.answerBtnBg2];
    [self.answerBtnBg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.whiteView.mas_right).offset(-ANDY_Adapta(27));
        make.bottom.mas_equalTo(self.whiteView.mas_bottom).offset(-ANDY_Adapta(50));
        make.width.mas_equalTo(ANDY_Adapta(260));
        make.height.mas_equalTo(ANDY_Adapta(80));
    }];
    self.answerBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.answerBtn2 setTitle:@"返回复活" forState:UIControlStateNormal];
    [self.answerBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.answerBtn2 setBackgroundColor:BtnBgColor2];
    self.answerBtn2.titleLabel.font = FontBold_(14);
    self.answerBtn2.layer.cornerRadius = ANDY_Adapta(40);
    self.answerBtn2.layer.masksToBounds = YES;
    [[self.answerBtn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.6f animations:^{
            self.backgroundColor = [UIColor clearColor];
            self.alpha = 0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
    [self.whiteView addSubview:self.answerBtn2];
    [self.answerBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.mas_equalTo(self.answerBtnBg2);
        make.bottom.mas_equalTo(self.whiteView.mas_bottom).offset(-ANDY_Adapta(60));
    }];
    
    self.answerDescLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentCenter font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    [self.whiteView addSubview:self.answerDescLabel];
    [self.answerDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.headImg.mas_bottom);
        make.bottom.mas_equalTo(self.answerBtn1.mas_top);
        make.width.mas_equalTo(ANDY_Adapta(300));
    }];
}
- (void)setDetermineExitData:(NSInteger)answerNum viewType:(NSInteger)vType{
    self.titleLabel.text = @"确定退出";
    self.closeBtn.hidden = YES;
    self.viewType = vType;
    self.answerDescLabel.text = [NSString stringWithFormat:@"今日还可以从第%ld个题开始是否继续?",answerNum];
}

//使用复活卡
- (void)rebirthAction{
    [self.delegate useRebirthCard];
}

- (void)setViewBtnStatus{
    self.answerBtn1.enabled = YES;
}

- (void)closeAction{
    if (self.adTimer) {
        dispatch_source_cancel(self.adTimer);
        self.adTimer = nil;
    }
    if ((self.viewType == 1 && self.fhCardCount == 0 && self.reBirthCount == 0) || self.viewType == 2) {
        [self.delegate confirmIsExit];
        [UIView animateWithDuration:0.6f animations:^{
            self.backgroundColor = [UIColor clearColor];
            self.alpha = 0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
         [self.delegate exitBattleController];
    }
}
- (void)showPopView:(UIViewController *)ViewController
{
    [self showWithAlert:self.answerView];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:self];
    [ViewController.view addSubview:self];
    [self CreateSlotView:ViewController];
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

- (void)outCloseAction{
    [UIView animateWithDuration:0.6f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
}

@end
