//
//  DynastyView.h
//  wangcao
//
//  Created by EDZ on 2020/5/15.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DynastyViewDelegate <NSObject>
//继续经营
- (void)goOnOperation:(NSInteger)type;

@end

@interface DynastyView : UIView

@property (nonatomic,weak) id<DynastyViewDelegate> delegate;

@property (nonatomic,strong) UIView *dynastyView;

- (void)showPopView:(UIViewController *)ViewController;
//加载数据
- (void)loadData:(DynastyModel *)model type:(NSInteger)type;
- (void)closeAction;

@end

NS_ASSUME_NONNULL_END
