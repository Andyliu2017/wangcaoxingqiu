//
//  PaopaoView.m
//  wangcao
//
//  Created by liu dequan on 2020/5/11.
//  Copyright © 2020 andy. All rights reserved.
//

#import "PaopaoView.h"

@interface PaopaoView()

@property (nonatomic, strong) NSMutableArray <NSValue *> *centerPointArr;

@property (nonatomic, strong) NSMutableArray <PaopaoButton *> *randomBtnArr;

@property (nonatomic, strong) NSMutableArray <PaopaoButton *> *randomBtnArrX;

@property (nonatomic, strong) NSMutableArray <UIButton *> *stealGoldBtnArr;

@property (nonatomic, strong) NSMutableArray <UIButton *> *receiveGoldBtnArr;

@end

@implementation PaopaoView
{
    CGFloat kMargin;
    CGFloat kBtnDiameter;
    CGFloat kBtnMinX;
    CGFloat kBtnMinY;
}

static NSInteger const kTimeLimitedBtnTag = 20000;
static NSInteger const kUnlimitedBtnTag = 30000;

//static CGFloat const kMargin = 10.0;
//static CGFloat const kBtnDiameter = 60.0;
//static CGFloat const kBtnMinX = kBtnDiameter * 0.5 + 0;
//static CGFloat const kBtnMinY = 0.0;


#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"tree_bg"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        kMargin = ANDY_Adapta(10);
        kBtnDiameter = ANDY_Adapta(104);
        kBtnMinX = kBtnDiameter * 0.5 + 0;
        kBtnMinY = 0.0;
    }
    return self;
}

- (void)dealloc
{
    
}


#pragma mark - setter

- (void)setStealGoldArr:(NSArray *)stealGoldArr{
    _stealGoldArr = stealGoldArr;
    for (int i = 0; i < stealGoldArr.count; i ++) {
        RedPackageModel *model = stealGoldArr[i];
        [self createRandomBtnWithType:PaopaoTypeTimeLimited andText:[GGUI goldConversion:[NSString stringWithFormat:@"%ld",model.amount]] withModel:model withType:2];
    }
}

- (void)setReceiveGoldArr:(NSArray *)receiveGoldArr{
    _receiveGoldArr = receiveGoldArr;
    for (int i = 0; i < receiveGoldArr.count; i ++) {
        RedPackageModel *model = receiveGoldArr[i];
        [self createRandomBtnWithType:PaopaoTypeUnlimited andText:[GGUI goldConversion:[NSString stringWithFormat:@"%ld",model.amount]] withModel:model withType:1];
    }
}


#pragma mark - getter

- (NSMutableArray <NSValue *> *)centerPointArr
{
    if (_centerPointArr == nil) {
        _centerPointArr = [NSMutableArray array];
    }
    return _centerPointArr;
}

- (NSMutableArray<PaopaoButton *> *)randomBtnArr
{
    if (_randomBtnArr == nil) {
        _randomBtnArr = [NSMutableArray array];
    }
    return _randomBtnArr;
}

- (NSMutableArray<PaopaoButton *> *)randomBtnArrX
{
    if (_randomBtnArrX == nil) {
        _randomBtnArrX = [NSMutableArray array];
    }
    return _randomBtnArrX;
}

- (NSMutableArray<UIButton *> *)stealGoldBtnArr
{
    if (_stealGoldBtnArr == nil) {
        _stealGoldBtnArr = [NSMutableArray array];
    }
    return _stealGoldBtnArr;
}

- (NSMutableArray<UIButton *> *)receiveGoldBtnArr
{
    if (_receiveGoldBtnArr == nil) {
        _receiveGoldBtnArr = [NSMutableArray array];
    }
    return _receiveGoldBtnArr;
}


#pragma mark - 随机数

- (NSInteger)getRandomNumber:(CGFloat)from to:(CGFloat)to
{
    return (NSInteger)(from + (arc4random() % ((NSInteger)to - (NSInteger)from + 1)));
}


#pragma mark - 随机按钮
//type 1 自己的金币泡泡   2 偷取的金币泡泡
- (void)createRandomBtnWithType:(PaopaoType)fruitType andText:(NSString *)textString withModel:(RedPackageModel *)model withType:(NSInteger)type
{
    CGFloat minY = kBtnMinY + kBtnDiameter * 0.5 + kMargin;
    CGFloat maxY = self.bounds.size.height - kBtnDiameter * 0.5 - kMargin;
    CGFloat minX = kBtnMinX + kMargin;
    CGFloat maxX = SCREENWIDTH - kBtnDiameter * 0.5 - 0 - kMargin;
    
    CGFloat x = [self getRandomNumber:minX to:maxX];
    CGFloat y = [self getRandomNumber:minY to:maxY];
    
    BOOL success = YES;
    for (int i = 0; i < self.centerPointArr.count; i ++) {
        NSValue *pointValue = self.centerPointArr[i];
        CGPoint point = [pointValue CGPointValue];
        //如果是圆 /^2 如果不是圆 不用/^2
//        if (sqrt(pow(point.x - x, 2) + pow(point.y - y, 2)) <= kBtnDiameter + kMargin) {
//            success = NO;
//            [self createRandomBtnWithType:fruitType andText:textString withType:type withId:redid];
//            return;
//        }
    }
    if (success == YES) {
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [self.centerPointArr addObject:pointValue];
        
        PaopaoButton *randomBtn = [PaopaoButton buttonWithType:0];
        randomBtn.redId = model.red_id;
        if (type == 1) {
            randomBtn.stealFlag = model.pickFlag;
        }else{
            randomBtn.stealFlag = model.stealFlag;
        }
        
        randomBtn.bounds = CGRectMake(0, 0, kBtnDiameter, kBtnDiameter);
        randomBtn.center = CGPointMake(x, y);
        [randomBtn setTitleColor:RGBA(255, 202, 20, 1) forState:0];
        randomBtn.titleLabel.font = FontBold_(12);
        [self addSubview:randomBtn];
        [randomBtn addTarget:self action:@selector(randomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.randomBtnArr addObject:randomBtn];
        [self.randomBtnArrX addObject:randomBtn];
       
        //区分
        if (fruitType == PaopaoTypeTimeLimited) {
            randomBtn.tag = kUnlimitedBtnTag + self.centerPointArr.count - 1;
            [self.stealGoldBtnArr addObject:randomBtn];
            [randomBtn setBackgroundImage:[UIImage imageNamed:@"sy_paopao"] forState:0];
        } else if (fruitType == PaopaoTypeUnlimited) {
            randomBtn.tag = kTimeLimitedBtnTag + self.centerPointArr.count - 1;
            [self.receiveGoldBtnArr addObject:randomBtn];
            [randomBtn setBackgroundImage:[UIImage imageNamed:@"sy_paopao"] forState:0];
        }
        //金币
        if (model.type == 1) {
            [randomBtn setImage:[UIImage imageNamed:@"sy_jinbi"] forState:UIControlStateNormal];
        }else{
            
        }
        if (type == 1) {
            [randomBtn setTitle:textString forState:0];
        }else{
            if (model.stealFlag) {
//                [randomBtn setTitle:textString forState:0];
                [randomBtn setTitle:@"可偷取" forState:UIControlStateNormal];
            }else{
                [randomBtn setTitle:[Tools transToHoursTime:model.stealEnableTime] forState:0];
            }
        }
        
        [self animationScaleOnceWithView:randomBtn];
        [self animationUpDownWithView:randomBtn];
    }
}


#pragma mark - 随机按钮被点击
- (void)randomBtnClick:(PaopaoButton *)randomBtn
{
    if (randomBtn.stealFlag) {   //可以被偷取
        [UIView animateWithDuration:0.1 animations:^{
            randomBtn.transform = CGAffineTransformMakeScale(1.15, 1.15);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                randomBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                if (randomBtn.tag >= kUnlimitedBtnTag) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTimeLimitedBtnAtIndex:withButton:)]) {
                        [self.delegate selectTimeLimitedBtnAtIndex:randomBtn.tag - kUnlimitedBtnTag withButton:randomBtn];
                    }
                } else if (randomBtn.tag >= kTimeLimitedBtnTag) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(selectUnlimitedBtnAtIndex:withButton:)]) {
                        [self.delegate selectUnlimitedBtnAtIndex:randomBtn.tag - kTimeLimitedBtnTag withButton:randomBtn];
                    }
                }
            }];
        }];
    }else{
        if (randomBtn.tag >= kUnlimitedBtnTag) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectTimeLimitedBtnAtIndex:withButton:)]) {
                [self.delegate selectTimeLimitedBtnAtIndex:randomBtn.tag - kUnlimitedBtnTag withButton:randomBtn];
            }
        } else if (randomBtn.tag >= kTimeLimitedBtnTag) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectUnlimitedBtnAtIndex:withButton:)]) {
                [self.delegate selectUnlimitedBtnAtIndex:randomBtn.tag - kTimeLimitedBtnTag withButton:randomBtn];
            }
        }
    }
}


#pragma mark - 移除随机按钮
- (void)removeRandomIndex:(NSInteger)index
{
    PaopaoButton *randomBtn = self.randomBtnArr[index];
    
    [UIView animateWithDuration:0.1 animations:^{
        randomBtn.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [randomBtn removeFromSuperview];
        [self.randomBtnArrX removeObject:randomBtn];
        if ([self.stealGoldBtnArr containsObject:randomBtn]) {
            [self.stealGoldBtnArr removeObject:randomBtn];
            if (self.stealGoldBtnArr.count == 0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(allCollected)]) {
                    [self.delegate allCollected];
                }
            }
        } else if ([self.receiveGoldBtnArr containsObject:randomBtn]) {
            [self.receiveGoldBtnArr removeObject:randomBtn];
            if (self.receiveGoldBtnArr.count == 0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(allCollected)]) {
                    [self.delegate allCollected];
                }
            }
        }
//        if (self.stealGoldBtnArr.count == 0 && self.receiveGoldBtnArr.count == 0) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(allCollected)]) {
//                [self.delegate allCollected];
//            }
//        }
    }];
}

- (void)removeAllRandomBtn
{
    for (int i = 0; i < self.randomBtnArr.count; i ++) {
        PaopaoButton *randomBtn = self.randomBtnArr[i];
        [randomBtn removeFromSuperview];
    }
    self.receiveGoldBtnArr = [NSMutableArray array];
    self.stealGoldBtnArr = [NSMutableArray array];
    self.randomBtnArr = [NSMutableArray array];
    self.randomBtnArrX = [NSMutableArray array];
    self.centerPointArr = [NSMutableArray array];
}


#pragma mark - 动画
- (void)animationScaleOnceWithView:(UIView *)view
{
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)animationUpDownWithView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint fromPoint = CGPointMake(position.x, position.y);
    CGPoint toPoint = CGPointZero;
    
    uint32_t typeInt = arc4random() % 100;
    CGFloat distanceFloat = 0.0;
    while (distanceFloat == 0) {
        distanceFloat = (6 + (int)(arc4random() % (9 - 7 + 1))) * 100.0 / 101.0;
    }
    if (typeInt % 2 == 0) {
        toPoint = CGPointMake(position.x, position.y - distanceFloat);
    } else {
        toPoint = CGPointMake(position.x, position.y + distanceFloat);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.autoreverses = YES;
    CGFloat durationFloat = 0.0;
    while (durationFloat == 0.0) {
        durationFloat = 0.9 + (int)(arc4random() % (100 - 70 + 1)) / 31.0;
    }
    [animation setDuration:durationFloat];
    [animation setRepeatCount:MAXFLOAT];

    [viewLayer addAnimation:animation forKey:nil];
}

@end
