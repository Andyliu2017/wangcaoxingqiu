//
//  MyPhotoPickManager.h
//  chongai
//
//  Created by Andyliu on 2017/5/26.
//  Copyright © 2017年 dgame.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PickerType)
{
    PickerType_Camera = 0, // 拍照
    PickerType_Photo, // 照片
};

typedef void (^pickBackBolck)(NSDictionary *infoDict,NSURL *newVAurl, BOOL isCancel);  // 视频回调

//typedef void (^pickPhotoBlock)(UIImage *sourceImage, BOOL isCancel);  //照片回调

@interface MyPhotoPickManager : NSObject

+ (instancetype)shareInstance; // 单例
- (void)initPick;

- (void)presentPicker:(PickerType)pickerType target:(UIViewController *)vc CallBackBlock:(pickBackBolck)blcok;

@end
