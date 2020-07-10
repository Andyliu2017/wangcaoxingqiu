//
//  MainScroll.m
//  wangcao
//
//  Created by EDZ on 2020/6/11.
//  Copyright © 2020 andy. All rights reserved.
//

#import "MainScroll.h"

@interface MainScroll()<UIScrollViewDelegate>

@end

@implementation MainScroll
{
    CGFloat lastContentOffset;
}

- (instancetype)init{
    if (self = [super init]) {
        self.delegate = self;
        self.flag = NO;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        if (self.flag) {   //下滑事件  响应
            return hitView;
        }else{   //点击事件 不响应
            return nil;
        }
    }
    return hitView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;//判断上下滑动时
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   if (scrollView.contentOffset.y < lastContentOffset ){
       NSLog(@"下滑");
       self.flag = YES;
   } else if (scrollView.contentOffset.y > lastContentOffset ){
       NSLog(@"上滑");
   }
}

@end
