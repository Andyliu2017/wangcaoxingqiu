//
//  WCTabBar.m
//  wangcao
//
//  Created by EDZ on 2020/6/9.
//  Copyright © 2020 andy. All rights reserved.
//

#import "WCTabBar.h"

@implementation WCTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tabBarView = [[TabbarView alloc] init];
        self.tabBarView.backgroundColor = NavigationBarColor;
        self.tabBarView.frame = frame;
        [self addSubview:self.tabBarView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置tabBarView的frame
    self.tabBarView.frame = self.bounds;
    // 把tabBarView带到最前面，覆盖tabBar的内容
    [self bringSubviewToFront:self.tabBarView];
}
// 重写hitTest方法，让超出tabBar部分也能响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.clipsToBounds || self.hidden || (self.alpha == 0.f)) {
        return nil;
    }
    UIView *result = [super hitTest:point withEvent:event];
    // 如果事件发生在tabbar里面直接返回
    if (result) {
        return result;
    }
    // 这里遍历那些超出的部分就可以了，不过这么写比较通用。
    for (UIView *subview in self.tabBarView.subviews) {
        // 把这个坐标从tabbar的坐标系转为subview的坐标系
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        // 如果事件发生在subView里就返回
        if (result) {
            return result;
        }
    }
    return nil;
}

@end
