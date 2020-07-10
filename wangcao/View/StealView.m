//
//  StealView.m
//  wangcao
//
//  Created by EDZ on 2020/5/13.
//  Copyright © 2020 andy. All rights reserved.
//

#import "StealView.h"

@implementation StealView

- (void)setIsSteal:(BOOL)isSteal{
    if (isSteal) {
        self.handImg.hidden = NO;
    }else{
        self.handImg.hidden = YES;
    }
}

- (void)setIsCurrent:(BOOL)isCurrent{
    if (isCurrent) {   //选中
        self.currentLabel.hidden = NO;
        self.borderImg.hidden = NO;
        self.handImg.hidden = YES;
    }
    else{
        self.currentLabel.hidden = YES;
        self.borderImg.hidden = YES;
//        self.handImg.hidden = NO;
    }
}

@end
