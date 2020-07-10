//
//  PaopaoView.h
//  wangcao
//
//  Created by liu dequan on 2020/5/11.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PaopaoTypeUnknown,
    PaopaoTypeTimeLimited,
    PaopaoTypeUnlimited,
} PaopaoType;

@protocol PaopaoViewDelegate <NSObject>

- (void)selectTimeLimitedBtnAtIndex:(NSInteger)index withButton:(PaopaoButton *)btn;

- (void)selectUnlimitedBtnAtIndex:(NSInteger)index withButton:(PaopaoButton *)btn;

- (void)allCollected;

@end

@interface PaopaoView : UIImageView

@property (nonatomic, strong) NSArray *stealGoldArr;

@property (nonatomic, strong) NSArray *receiveGoldArr;

- (void)createRandomBtnWithType:(PaopaoType)fruitType andText:(NSString *)textString withModel:(RedPackageModel *)model;

- (void)removeRandomIndex:(NSInteger)index;

- (void)removeAllRandomBtn;

@property (nonatomic, weak) id <PaopaoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
