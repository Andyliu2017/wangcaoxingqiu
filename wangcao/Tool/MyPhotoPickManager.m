//
//  MyPhotoPickManager.m
//  chongai
//
//  Created by Andyliu on 2017/5/26.
//  Copyright © 2017年 dgame.com. All rights reserved.
//

#import "MyPhotoPickManager.h"

@interface MyPhotoPickManager () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *pick;
    UIViewController *_vc;
    pickBackBolck pickBlock;
    NSInteger pickType;
}

@end

@implementation MyPhotoPickManager

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static MyPhotoPickManager *pickManager;
    dispatch_once(&once, ^{
        pickManager = [[MyPhotoPickManager alloc] init];
    });
    return pickManager;
}
- (instancetype)init
{
    if(self = [super init]){
        if(!pick){
            pick = [[UIImagePickerController alloc] init];  // 初始化
        }
    }
    return self;
}
- (void)initPick{
    pick = [[UIImagePickerController alloc] init];
}

//拍照、从相册选取
- (void)presentPicker:(PickerType)pickerType target:(UIViewController *)vc CallBackBlock:(pickBackBolck)blcok
{
    pickType = pickerType;  //照片
    _vc = vc;
    pickBlock = blcok;
    if(pickerType == PickerType_Camera){
        // 拍照
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            pick.delegate = self;
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            pick.allowsEditing = YES;
            pick.showsCameraControls = YES;
            UIView *view = [[UIView  alloc] init];
//            view.backgroundColor = [UIColor grayColor];
            pick.cameraOverlayView = view;
            [_vc presentViewController:pick animated:YES completion:nil];
        }else{
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"相机不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertV show];
        }
    }
    
    else if(pickerType == PickerType_Photo){
        // 相册
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            pick.delegate = self;
            pick.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pick.allowsEditing = YES;
            [_vc presentViewController:pick animated:YES completion:nil];
        }else{
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"相册不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertV show];
        }
        
    }
}

#pragma mark ---- UIImagePickerControllerDelegate
//完成视频录制
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (pickType == 1) {   //照片
        [_vc dismissViewControllerAnimated:YES completion:^{
            pickBlock(info, nil, NO);
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_vc dismissViewControllerAnimated:YES completion:^{
        pickBlock(nil, nil, YES); // block回调
    }];
}

@end
