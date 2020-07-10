//
//  ModifyController.m
//  wangcao
//
//  Created by EDZ on 2020/5/22.
//  Copyright © 2020 andy. All rights reserved.
//

#import "ModifyController.h"
#import "MyPhotoPickManager.h"
#import "AliStsOssModel.h"
#import <AliyunOSSiOS/OSSService.h>

@interface ModifyController ()<UIPickerViewDelegate>

@property(nonatomic,strong) OSSClient *client;
@property(nonatomic,copy) NSString *avatar;

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UITextField *nickNameFiled;
@property (nonatomic,strong) UITextField *qqFiled;
@property (nonatomic,strong) UITextField *wechatFiled;

@property (nonatomic,strong) UIImagePickerController *picker;

@end

@implementation ModifyController
- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
    }
    return _picker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改个人信息";
    
    [self createUI];
    [self setData];
}
- (void)createUI{
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    whiteView.clipsToBounds = YES;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(60));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(542));
    }];
    
    UIView *headView = [[UIView alloc] init];
    [whiteView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(whiteView);
        make.height.mas_equalTo(ANDY_Adapta(140));
    }];
    UILabel *headLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"头像" Radius:0];
    [headView addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView);
        make.left.mas_equalTo(ANDY_Adapta(40));
        make.height.mas_equalTo(headView.mas_height);
    }];
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_more"]];
    [headView addSubview:arrowImg];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView);
        make.right.mas_equalTo(-ANDY_Adapta(36));
    }];
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.cornerRadius = ANDY_Adapta(40);
    self.headImg.layer.masksToBounds = YES;
    [headView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView);
        make.right.mas_equalTo(arrowImg.mas_left).offset(-ANDY_Adapta(15));
        make.width.and.height.mas_equalTo(ANDY_Adapta(80));
    }];
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headBtn addTarget:self action:@selector(headAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:headBtn];
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(headView);
    }];
    
    self.nickNameFiled = [[UITextField alloc] init];
    self.nickNameFiled.textAlignment = NSTextAlignmentRight;
    self.nickNameFiled.font = FontBold_(14);
    self.nickNameFiled.placeholder = @"请输入昵称";
    
    self.qqFiled = [[UITextField alloc] init];
    self.qqFiled.textAlignment = NSTextAlignmentRight;
    self.qqFiled.font = FontBold_(14);
    self.qqFiled.placeholder = @"请输入QQ号";
    
    self.wechatFiled = [[UITextField alloc] init];
    self.wechatFiled.textAlignment = NSTextAlignmentRight;
    self.wechatFiled.font = FontBold_(14);
    self.wechatFiled.placeholder = @"请输入微信号";
    NSArray *titleArr = @[@"昵称",@"QQ",@"微信"];
    NSArray *filedArr = @[self.nickNameFiled,self.qqFiled,self.wechatFiled];
    for (int i = 0 ; i < 3; i++) {
        UIView *modifyView = [self createModifyView:filedArr[i] title:titleArr[i]];
        [whiteView addSubview:modifyView];
        [modifyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(whiteView);
            make.height.mas_equalTo(ANDY_Adapta(134));
            make.top.mas_equalTo(headView.mas_bottom).offset(ANDY_Adapta(134)*i);
        }];
    }
    
    UIButton *baocunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [baocunBtn setBackgroundImage:[UIImage imageNamed:@"rank_invite"] forState:UIControlStateNormal];
    [baocunBtn setTitle:@"保存信息" forState:UIControlStateNormal];
    [baocunBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [baocunBtn addTarget:self action:@selector(baocunAction) forControlEvents:UIControlEventTouchUpInside];
    baocunBtn.titleLabel.font = FontBold_(18);
    [self.view addSubview:baocunBtn];
    [baocunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(whiteView.mas_bottom).offset(ANDY_Adapta(54));
    }];
}
- (UIView *)createModifyView:(UITextField *)textFiled title:(NSString *)title{
    UIView *modifyView = [[UIView alloc] init];
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = LineColor;
    [modifyView addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.centerX.mas_equalTo(modifyView);
        make.width.mas_equalTo(ANDY_Adapta(627));
        make.height.mas_equalTo(ANDY_Adapta(1));
    }];
    UILabel *label = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:title Radius:0];
    [modifyView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.height.mas_equalTo(modifyView);
        make.left.mas_equalTo(ANDY_Adapta(40));
    }];
    
    [modifyView addSubview:textFiled];
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ANDY_Adapta(42));
        make.top.and.bottom.mas_equalTo(modifyView);
    }];
    
    return modifyView;
}
- (void)setData{
    if ([[PBCache shared].userModel.nickName isNotBlank]) {
        self.nickNameFiled.text = [PBCache shared].userModel.nickName;
    }
    if ([[PBCache shared].userModel.qq isNotBlank]) {
        self.qqFiled.text = [PBCache shared].userModel.qq;
    }
    if ([[PBCache shared].userModel.weixin isNotBlank]) {
        self.wechatFiled.text = [PBCache shared].userModel.weixin;
    }
    [self.headImg setImageWithURL:[PBCache shared].userModel.avatar placeholder:[UIImage imageNamed:@"sy_head"]];
}
- (void)headAction{
    [self createActionSheet];
}
- (void)createActionSheet{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhoto];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertSheet addAction:action1];
    [alertSheet addAction:action2];
    [alertSheet addAction:action3];
    [self presentViewController:alertSheet animated:YES completion:nil];
}
//相册
- (void)openPhoto{
    __block ModifyController *weakSelf = self;
    MyPhotoPickManager *photoPick = [MyPhotoPickManager shareInstance];
    [photoPick presentPicker:PickerType_Photo target:self CallBackBlock:^(NSDictionary *infoDict, NSURL *newVAurl, BOOL isCancel) {
        UIImage *image = [infoDict objectForKey:UIImagePickerControllerOriginalImage];
        WCApiManager *manager = [WCApiManager sharedManager];
        [MBProgressHUD showMessage:@"图片上传中" toView:self.view];
        [[manager ApiGetAliAutoAccount] subscribeNext:^(AliStsOssModel *model) {
            [weakSelf uploadImage:image aliStsRole:model];
        } error:^(NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"图片上传失败" toView:self.view afterDelay:2.5];
        }];
    }];
}
//相机
- (void)openCamera{
    __block ModifyController *weakSelf = self;
    MyPhotoPickManager *photoPick = [MyPhotoPickManager shareInstance];
    [photoPick presentPicker:PickerType_Camera target:self CallBackBlock:^(NSDictionary *infoDict, NSURL *newVAurl, BOOL isCancel) {
        UIImage *image = [infoDict objectForKey:UIImagePickerControllerOriginalImage];
        WCApiManager *manager = [WCApiManager sharedManager];
        [MBProgressHUD showMessage:@"图片上传中" toView:self.view];
        [[manager ApiGetAliAutoAccount] subscribeNext:^(AliStsOssModel *model) {
            [weakSelf uploadImage:image aliStsRole:model];
        } error:^(NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"图片上传失败" toView:self.view afterDelay:2.5];
        }];
    }];
}
- (void)uploadImage:(UIImage *)image aliStsRole:(AliStsOssModel *)aliStsRole{
    OSSPutObjectRequest * put = [[OSSPutObjectRequest alloc] init];
    // 必填字段
    long long time = [[NSDate date] timeIntervalSince1970];
    NSString *filefolder = @"user_ios";
    NSString *fileName = F(@"%lld.png", time);
    NSString *objectkey = [filefolder stringByAppendingPathComponent:fileName];
    put.bucketName = aliStsRole.bucket;
    put.objectKey = objectkey;
    put.uploadingData = UIImagePNGRepresentation(image); // 直接上传NSData
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    AliStsCredentialModel *alistsModel = aliStsRole.credential;
    OSSStsTokenCredentialProvider *credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:alistsModel.accessKeyId secretKeyId:alistsModel.accessKeySecret securityToken:alistsModel.securityToken];
    //必须用成员变量保存,不保存OSSClient会销毁报错
    self.client = [[OSSClient alloc] initWithEndpoint:aliStsRole.endpoint credentialProvider:credential];
    OSSTask *putTask = [self.client putObject:put];
    @weakify(self);
    [putTask continueWithBlock:^id(OSSTask *task) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (task.error) {
                NSLog(@"upload object failed, error: %@" , task.error);
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"图片上传失败" toView:self.view afterDelay:1.5];
            }else{
                NSLog(@"upload object success!");
                [MBProgressHUD hideHUDForView:self.view];
//                [self.usericon setImage:image forState:0];
                self.headImg.image = image;
                NSString *publicURL = [self.client presignPublicURLWithBucketName:aliStsRole.bucket withObjectKey:objectkey].result;
                //self.isChangeAvatar = YES;
                self.avatar = publicURL;
            }
        });
        return nil;
    }];
}
//保存信息
- (void)baocunAction{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiModifyUserInfoWithAvatar:self.avatar nickname:self.nickNameFiled.text qq:self.qqFiled.text weixin:self.wechatFiled.text] subscribeNext:^(id  _Nullable x) {
        [PBCache shared].userModel.avatar = self.avatar;
        [PBCache shared].userModel.nickName = self.nickNameFiled.text;
        [PBCache shared].userModel.qq = self.qqFiled.text;
        [PBCache shared].userModel.weixin = self.wechatFiled.text;
        [MBProgressHUD showError:@"保存成功" toView:[UIApplication sharedApplication].keyWindow afterDelay:2.5];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
