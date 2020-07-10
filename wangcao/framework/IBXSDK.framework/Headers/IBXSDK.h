//
//  IBXSDK.h
//  IBXSDK
//
//  Created by yeming on 2020/4/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IBXSDKConfig.h"


@protocol IBXSDKDelegate <NSObject>

/**
 加载成功
 */
- (void)ibx_didLoad;

/**
加载失败
*/
- (void)ibx_didLoadFail:(NSError *)error;

/**
关闭
*/
- (void)ibx_didClose;

@end

@interface IBXSDK : NSObject
+ (void)loadWithRootViewController:(UIViewController *)rootViewController delegate:(id<IBXSDKDelegate>)delegate;
@end

