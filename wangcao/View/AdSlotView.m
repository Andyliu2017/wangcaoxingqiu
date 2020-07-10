//
//  AdSlotView.m
//  wangcao
//
//  Created by EDZ on 2020/6/10.
//  Copyright © 2020 andy. All rights reserved.
//

#import "AdSlotView.h"

@interface AdSlotView()



@end

@implementation AdSlotView

- (void)CreateSlotView:(UIViewController *)viewcontroller{
    self.slotView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-ANDY_Adapta(400), SCREENWIDTH, ANDY_Adapta(400))];
    [self addSubview:self.slotView];
    [AdHandleManager sharedManager].delegate = self;
    [[AdHandleManager sharedManager] loadNativeAdsWithWidth:SCREENWIDTH height:ANDY_Adapta(400) view:self.slotView viewController:viewcontroller];
    
    __block NSInteger countDown = 5;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    _adTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(_adTimer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(_adTimer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (countDown > 0) {
                countDown--;
            }else{
                self.closeBtn.hidden = NO;
                if (self.adTimer) {
                    dispatch_source_cancel(self.adTimer);
                    self.adTimer = nil;
                    NSLog(@"广告倒计时已关闭:%@",self.adTimer);
                }
            }
        });
    });
    //启动源
    dispatch_resume(_adTimer);
}

- (void)BUADSlotVideoLoadSuccess{
    //视频出现是关闭按钮出现
    self.closeBtn.hidden = NO;
    [self setViewBtnStatus];
}

- (void)BUADSlotVideoLoadFail{
    self.closeBtn.hidden = NO;
    [self setViewBtnStatus];
}

- (void)setViewBtnStatus{
    
}

@end
