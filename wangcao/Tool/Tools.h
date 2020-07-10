//
//  Tools.h
//  wangcao
//
//  Created by liu dequan on 2020/4/29.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)getDateStringOfDate:(NSDate *)date;

+ (void)setTextColor1:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range1 AndAnotherRange:(NSRange)range2 AndColor1:(UIColor *)color1 AndColor2:(UIColor *)color2;

//时间戳--->时间
+(NSString *)transToTime:(NSString *)timsp;
//时间戳--->时间  小时
+(NSString *)transToHoursTime:(NSString *)timsp;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

//分红记录页面日期
+ (NSString *)getProfitDateStringOfDate:(NSDate *)date;

//设置默认显示文字
+ (void)setTextFiledPlaceholder:(NSString *)titleStr font:(UIFont *)font color:(UIColor *)color textFiled:(UITextField *)textfiled;

//传入今天的时间，返回昨天的时间
+ (NSString *)Getyesterday:(NSDate *)aDate;
//传入今天的时间，返回昨天的时间
+ (NSString *)GetTomorrow:(NSDate *)aDate;
//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string;

+ (AVAudioPlayer *)loadMusic:(NSString *)fileName;

#pragma mark - 随机数
+ (NSInteger)getRandomNumber:(CGFloat)from to:(CGFloat)to;
#pragma mark - 动画  上下浮动
+ (void)animationScaleOnceWithView:(UIView *)view;
+ (void)animationUpDownWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
