//
//  SharePopView.m
//  wangcao
//
//  Created by liu dequan on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import "SharePopView.h"

@interface SharePopView()
//下面弹起的白色view
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIImageView *sharebgImg;
@property (nonatomic,strong) UIButton *closeBtn;
//二维码
@property (nonatomic,strong) UIImageView *qrcodeImg;
//战队号
@property (nonatomic,strong) UILabel *shareLabel;
@property (nonatomic,strong) UILabel *teamLabel;
//头像
@property (nonatomic,strong) UIImageView *headImg;
//昵称
@property (nonatomic,strong) UILabel *nickNameLabel;
//描述
@property (nonatomic,strong) UILabel *descLabel;

@end

@implementation SharePopView

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
    self.bottomView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    self.bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, SCREENWIDTH, spaceHeight(300));
    [self addSubview:self.bottomView];
    
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(16) textColor:[UIColor blackColor] text:@"请选择邀请方式" Radius:0];
    [self.bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.centerX.mas_equalTo(self.bottomView);
        make.height.mas_equalTo(spaceHeight(99));
    }];
    
    UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wxBtn setImage:[UIImage imageNamed:@"share_weChat"] forState:UIControlStateNormal];
    [[wxBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self shareImg:SharePlatform_Session];
    }];
    [self.bottomView addSubview:wxBtn];
    [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.centerX.mas_equalTo(self.bottomView).offset(-SCREENWIDTH/4.0);
        make.width.and.height.mas_equalTo(spaceHeight(80));
    }];
    UILabel *wxlabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:GrayColor text:@"微信好友" Radius:0];
    [self.bottomView addSubview:wxlabel];
    [wxlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(wxBtn.mas_centerX);
        make.top.mas_equalTo(wxBtn.mas_bottom);
    }];
    
    UIButton *pyqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pyqBtn setImage:[UIImage imageNamed:@"share_weChat_Timeline"] forState:UIControlStateNormal];
    [[pyqBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self shareImg:SharePlatform_Timeline];
    }];
    [self.bottomView addSubview:pyqBtn];
    [pyqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.centerX.mas_equalTo(self.bottomView).offset(SCREENWIDTH/4.0);
        make.width.and.height.mas_equalTo(spaceHeight(80));
    }];
    UILabel *pyqlabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:GrayColor text:@"朋友圈" Radius:0];
    [self.bottomView addSubview:pyqlabel];
    [pyqlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(pyqBtn.mas_centerX);
        make.top.mas_equalTo(pyqBtn.mas_bottom);
    }];
    
    self.sharebgImg = [[UIImageView alloc] init];
    self.sharebgImg.hidden = YES;
    [self addSubview:self.sharebgImg];
    [self.sharebgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-spaceHeight(139));
        make.width.mas_equalTo(spaceHeight(614));
        make.height.mas_equalTo(spaceHeight(957));
    }];
    UIView *shareview = [[UIView alloc] init];
    [self.sharebgImg addSubview:shareview];
    [shareview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.sharebgImg);
        make.height.mas_equalTo(spaceHeight(180));
    }];
    self.qrcodeImg = [[UIImageView alloc] init];
    [shareview addSubview:self.qrcodeImg];
    [self.qrcodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(shareview);
        make.right.mas_equalTo(shareview.mas_right).offset(-spaceHeight(37));
        make.width.and.height.mas_equalTo(spaceHeight(120));
    }];
    
    self.shareLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:TitleColor text:@"战队号：" Radius:0];
    [shareview addSubview:self.shareLabel];
    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shareview.mas_left).offset(spaceHeight(40));
        make.top.mas_equalTo(shareview.mas_top);
        make.height.mas_equalTo(spaceHeight(30));
    }];
    self.teamLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(13) textColor:NavigationBarColor text:@"" Radius:0];
    [shareview addSubview:self.teamLabel];
    [self.teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shareLabel.mas_right).offset(spaceHeight(10));
        make.top.mas_equalTo(shareview);
        make.height.mas_equalTo(self.shareLabel);
    }];
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.cornerRadius = spaceHeight(49);
    self.headImg.layer.masksToBounds = YES;
    [shareview addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shareview.mas_left).offset(spaceHeight(40));
        make.top.mas_equalTo(self.shareLabel.mas_bottom).offset(spaceHeight(5));
        make.width.and.height.mas_equalTo(spaceHeight(108));
    }];
    self.nickNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [shareview addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).offset(spaceHeight(10));
        make.top.mas_equalTo(self.headImg.mas_top);
        make.height.mas_equalTo(spaceHeight(36));
    }];
    self.descLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:Font_(12) textColor:GrayColor text:@"" Radius:0];
    [shareview addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickNameLabel.mas_left);
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom);
//        make.bottom.mas_equalTo(self.headImg.mas_bottom);
        make.right.mas_equalTo(self.qrcodeImg.mas_left);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"signin_close"] forState:UIControlStateNormal];
    self.closeBtn.hidden = YES;
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismiss];
    }];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.sharebgImg.mas_right);
        make.bottom.mas_equalTo(self.sharebgImg.mas_top).offset(-spaceHeight(17));
        make.width.and.height.mas_equalTo(spaceHeight(53));
    }];
}

- (void)setDataWithImg:(UIImage *)bgImg type:(NSInteger)type teamNum:(NSString *)teamnum nickName:(NSString *)nickName qrcode:(NSString *)qrcode{
    self.sharebgImg.image = bgImg;
    if (type == 1) {  //邀请好友
        self.shareLabel.text = @"我的邀请码:";
        self.descLabel.text = @"来王朝星球边学历史边赚钱!";
    }else{   //邀请pk
        self.shareLabel.text = @"战队号:";
        self.descLabel.text = @"快来王朝星球跟我一起组队赢红包!";
    }
    self.teamLabel.text = teamnum;
    self.nickNameLabel.text = nickName;
    [self.qrcodeImg setImageURL:[NSURL URLWithString:qrcode]];
    [self.headImg setImageWithURL:[NSURL URLWithString:[PBCache shared].userModel.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
}

- (void)shareImg:(SharePlatform)platform
{
    APHandleManager *ap = [APHandleManager sharedManager];
    [ap shareToPlatform:platform image:[self imageWithView:self.sharebgImg] success:^(HandleStatus code) {
        
    } failure:^(HandleStatus code) {
        
    }];
}



- (UIImage *)imageWithView:(UIImageView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)showView
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-spaceHeight(300), SCREENWIDTH, spaceHeight(300));
                     }
                     completion:^(BOOL finished) {
        self.sharebgImg.hidden = NO;
        self.closeBtn.hidden = NO;
                     }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.sharebgImg.hidden = YES;
        self.closeBtn.hidden = YES;
                         self.bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, SCREENWIDTH, spaceHeight(300));
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)handleGuesture:(UITapGestureRecognizer *)sender
{
//    CGPoint point = [sender locationInView:self.wcontainView];
//    if(![self.wcontainView.layer containsPoint:point])
//    {
//        [self dismiss];
//        return;
//    }
}

@end
