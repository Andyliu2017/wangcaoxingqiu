//
//  ShiMingController.m
//  wangcao
//
//  Created by EDZ on 2020/6/4.
//  Copyright © 2020 andy. All rights reserved.
//

#import "ShiMingController.h"
#import "ShiMingView.h"

@interface ShiMingController ()<ShiMingViewDelegate>

@property (nonatomic,strong) UITextField *nameFiled;
@property (nonatomic,strong) UITextField *idCardFiled;
@property (nonatomic,strong) UITextField *alipayFiled;
@property (nonatomic,strong) ShiMingView *shimingView;

@end

@implementation ShiMingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"实名认证";
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = RGBA(247, 247, 247, 1);
    
    if (self.isShiMing) {
        [self alreadyShiMingUI];
    }else{
        [self createUI];
    }
}
#pragma mark 已实名
- (void)alreadyShiMingUI{
    UIView *nameView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    UILabel *nameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:TitleColor text:@"真实姓名" Radius:0];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [nameView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(nameView);
        make.width.mas_equalTo(ANDY_Adapta(120));
    }];
    
    UILabel *nameLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(15) textColor:GrayColor text:self.smModel.name Radius:0];
    [nameView addSubview:nameLabel1];
    [nameLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right).offset(ANDY_Adapta(70));
        make.top.and.bottom.mas_equalTo(nameView);
        make.right.mas_equalTo(nameView.mas_right).offset(-ANDY_Adapta(30));
    }];
    UIImageView *lineImg1 = [[UIImageView alloc] init];
    lineImg1.backgroundColor = LineColor;
    [self.view addSubview:lineImg1];
    [lineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(nameView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UIView *idCardView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:idCardView];
    [idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(lineImg1.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    UILabel *idCardLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:TitleColor text:@"身份证号" Radius:0];
    idCardLabel.adjustsFontSizeToFitWidth = YES;
    [idCardView addSubview:idCardLabel];
    [idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(idCardView);
        make.width.mas_equalTo(ANDY_Adapta(120));
    }];
    UILabel *idCardLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(15) textColor:GrayColor text:self.smModel.idcard Radius:0];
    [idCardView addSubview:idCardLabel1];
    [idCardLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(idCardLabel.mas_right).offset(ANDY_Adapta(70));
        make.top.and.bottom.mas_equalTo(idCardView);
        make.right.mas_equalTo(idCardView.mas_right).offset(-ANDY_Adapta(30));
    }];
    UIImageView *lineImg2 = [[UIImageView alloc] init];
    lineImg2.backgroundColor = LineColor;
    [self.view addSubview:lineImg2];
    [lineImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(idCardView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UIView *alipayView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:alipayView];
    [alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(lineImg2.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    UILabel *alipayLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:TitleColor text:@"支付宝账号" Radius:0];
    [alipayView addSubview:alipayLabel];
    [alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(alipayView);
    }];
    UILabel *alipayLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(15) textColor:GrayColor text:self.smModel.aliAccount Radius:0];
    [alipayView addSubview:alipayLabel1];
    [alipayLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alipayLabel.mas_right).offset(ANDY_Adapta(70));
        make.top.and.bottom.mas_equalTo(alipayView);
        make.right.mas_equalTo(alipayView.mas_right).offset(-ANDY_Adapta(30));
    }];
    UIImageView *lineImg3 = [[UIImageView alloc] init];
    lineImg3.backgroundColor = LineColor;
    [self.view addSubview:lineImg3];
    [lineImg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(alipayView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UIView *statusView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(lineImg3.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    UILabel *statusLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:TitleColor text:@"审核状态" Radius:0];
    [statusView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(statusView);
    }];
    
    UILabel *statusLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:FontBold_(15) textColor:MoneyColor text:@"" Radius:0];
    [statusView addSubview:statusLabel1];
    [statusLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(statusLabel.mas_right).offset(ANDY_Adapta(70));
        make.top.and.bottom.mas_equalTo(statusView);
        make.right.mas_equalTo(statusView.mas_right).offset(-ANDY_Adapta(30));
    }];
    if (self.smModel.status == 1) {
        statusLabel1.text = @"审核成功";
    }else if (self.smModel.status == -1){
        statusLabel1.text = @"审核失败";
    }else if (self.smModel.status == 0){
        statusLabel1.text = @"审核中";
    }
    UIImageView *lineImg4 = [[UIImageView alloc] init];
    lineImg4.backgroundColor = LineColor;
    [self.view addSubview:lineImg4];
    [lineImg4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(statusView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UILabel *descLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:MoneyColor text:@"注意:" Radius:0];
    descLabel1.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:descLabel1];
    [descLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(lineImg4.mas_bottom).offset(ANDY_Adapta(30));
        make.height.mas_equalTo(ANDY_Adapta(25));
        make.width.mas_equalTo(ANDY_Adapta(80));
    }];
    UILabel *descLabel2 = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:Font_(14) textColor:MoneyColor text:@"以上信息请谨慎填写，支付宝账号绑定的真实姓名必须一致，否则无法到账，若身份证号码含有字母，请使用小写。" Radius:0];
    [self.view addSubview:descLabel2];
    [descLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(descLabel1.mas_right);
        make.top.mas_equalTo(descLabel1.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-ANDY_Adapta(30));
    }];
}
#pragma mark 未实名
- (void)createUI{
    UIView *nameView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    UILabel *nameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:TitleColor text:@"真实姓名" Radius:0];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [nameView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(nameView);
        make.width.mas_equalTo(ANDY_Adapta(120));
    }];
    self.nameFiled = [[UITextField alloc] init];
    [nameView addSubview:self.nameFiled];
    [self.nameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right).offset(ANDY_Adapta(70));
        make.top.and.bottom.and.right.mas_equalTo(nameView);
    }];
    [Tools setTextFiledPlaceholder:@"请填写您的真实姓名" font:FontBold_(15) color:LineColor textFiled:self.nameFiled];
    
    UIImageView *lineImg1 = [[UIImageView alloc] init];
    lineImg1.backgroundColor = LineColor;
    [self.view addSubview:lineImg1];
    [lineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(nameView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UIView *idCardView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:idCardView];
    [idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(lineImg1.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    UILabel *idCardLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:TitleColor text:@"身份证号" Radius:0];
    idCardLabel.adjustsFontSizeToFitWidth = YES;
    [idCardView addSubview:idCardLabel];
    [idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(idCardView);
        make.width.mas_equalTo(ANDY_Adapta(120));
    }];
    self.idCardFiled = [[UITextField alloc] init];
    [idCardView addSubview:self.idCardFiled];
    [self.idCardFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(idCardLabel.mas_right).offset(ANDY_Adapta(70));
        make.top.and.bottom.and.right.mas_equalTo(idCardView);
    }];
    [Tools setTextFiledPlaceholder:@"请填写您的身份证号" font:FontBold_(15) color:LineColor textFiled:self.idCardFiled];
    
    UIImageView *lineImg2 = [[UIImageView alloc] init];
    lineImg2.backgroundColor = LineColor;
    [self.view addSubview:lineImg2];
    [lineImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(idCardView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UIView *alipayView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:alipayView];
    [alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(lineImg2.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(96));
    }];
    UILabel *alipayLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(15) textColor:TitleColor text:@"支付宝账号" Radius:0];
    [alipayView addSubview:alipayLabel];
    [alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.and.bottom.mas_equalTo(alipayView);
    }];
    self.alipayFiled = [[UITextField alloc] init];
    [alipayView addSubview:self.alipayFiled];
    [self.alipayFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alipayLabel.mas_right).offset(ANDY_Adapta(70));
        make.top.and.bottom.and.right.mas_equalTo(alipayView);
    }];
    [Tools setTextFiledPlaceholder:@"请填写您的支付宝账号" font:FontBold_(15) color:LineColor textFiled:self.alipayFiled];
    
    UIImageView *lineImg3 = [[UIImageView alloc] init];
    lineImg3.backgroundColor = LineColor;
    [self.view addSubview:lineImg3];
    [lineImg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(alipayView.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    
    UILabel *descLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(14) textColor:MoneyColor text:@"注意:" Radius:0];
    descLabel1.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:descLabel1];
    [descLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(lineImg3.mas_bottom).offset(ANDY_Adapta(30));
        make.height.mas_equalTo(ANDY_Adapta(25));
        make.width.mas_equalTo(ANDY_Adapta(80));
    }];
    UILabel *descLabel2 = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:Font_(14) textColor:MoneyColor text:@"以上信息请谨慎填写，支付宝账号绑定的真实姓名必须一致，否则无法到账，若身份证号码含有字母，请使用小写。" Radius:0];
    [self.view addSubview:descLabel2];
    [descLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(descLabel1.mas_right);
        make.top.mas_equalTo(descLabel1.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-ANDY_Adapta(30));
    }];
    
    UIButton *commitBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(17) normalColor:[UIColor whiteColor] normalText:@"提交" click:^(id  _Nonnull x) {
        [self commitAction];
        [self.view endEditing:YES];
    }];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"rank_invite"] forState:UIControlStateNormal];
    [commitBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, ANDY_Adapta(10), 0)];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(descLabel2.mas_bottom).offset(ANDY_Adapta(50));
        make.width.mas_equalTo(ANDY_Adapta(642));
        make.height.mas_equalTo(ANDY_Adapta(110));
    }];
}

- (void)commitAction{
    //真实姓名
    if (![self.nameFiled.text isNotBlank]) {
        [MBProgressHUD showText:@"真实姓名不能为空" toView:self.view afterDelay:1.0];
        return;
    }
    //身份证号
    if (![self isCorrect:self.idCardFiled.text]) {
        [MBProgressHUD showText:@"身份证不合法" toView:self.view afterDelay:1.0];
        return;
    }
    if (![self.alipayFiled.text isNotBlank]) {
        [MBProgressHUD showText:@"支付宝账号不能为空" toView:self.view afterDelay:1.0];
        return;
    }
    if (!self.shimingView) {
        self.shimingView = [[ShiMingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    [self.shimingView setData:self.nameFiled.text idcard:self.idCardFiled.text alipaystr:self.alipayFiled.text];
    self.shimingView.delegate = self;
    [self.shimingView showPopView:self];
}

- (BOOL)isCorrect:(NSString *)IDNumber
{
    if (IDNumber.length<18) {
        return NO;
    }
    NSMutableArray *IDArray = [NSMutableArray array];
    // 遍历身份证字符串,存入数组中
    for (int i = 0; i < 18; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    // 系数数组
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    // 余数数组
    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    // 每一位身份证号码和对应系数相乘之后相加所得的和
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    // 这个和除以11的余数对应的数
    NSString *str = remainderArray[(sum % 11)];
    // 身份证号码最后一位
    NSString *string = [IDNumber substringFromIndex:17];
    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
    if ([str isEqualToString:string]) {
        
        NSString *birthdayYer = [IDNumber substringWithRange:NSMakeRange(6, 4)];
        NSString *birthdayMan = [IDNumber substringWithRange:NSMakeRange(10, 2)];
        NSString *birthdayDay = [IDNumber substringWithRange:NSMakeRange(12, 2)];
        if ([birthdayYer intValue]<1900||[birthdayMan intValue]==0||[birthdayMan intValue]>12||[birthdayDay intValue]==1||[birthdayDay intValue]>31) {
            return NO;
        }
        
        
        return YES;
        
    } else {
        return NO;
    }
}

- (void)cancelAction{
    [self.shimingView closeAction];
    self.shimingView = nil;
}

- (void)comfireAction:(NSString *)name idcard:(NSString *)idcard alipay:(NSString *)alipay{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiShiMing:name idcard:idcard aliAccount:alipay] subscribeNext:^(id  _Nullable x) {
        [self.shimingView closeAction];
        self.shimingView = nil;
        [MBProgressHUD showText:@"提交成功" toView:[UIApplication sharedApplication].keyWindow afterDelay:1.0];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHSHIMINGINFO object:self userInfo:nil];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
