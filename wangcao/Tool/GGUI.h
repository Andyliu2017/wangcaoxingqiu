//
//  ANDYUI.h
//  wangcao
//
//  Created by Andy on 2020/3/16.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger
{
    YCUIdirectionTop = 0,
    YCUIdirectionBotton,
    YCUIdirectionLeft,
    YCUIdirectionRight,
}YCUIdirection;

@interface GGUI : NSObject


/// 快速创建UIView
/// @param rect 坐标
/// @param backColor 背景颜色
/// @param alpha 背景是否透明
/// @param cornerRadius 圆角大小
/// @param borderWidth 边框
/// @param borderColor 边框颜色
+ (UIView *)ui_view:(CGRect)rect
    backgroundColor:(UIColor *)backColor
              alpha:(CGFloat)alpha
       cornerRadius:(CGFloat)cornerRadius
        borderWidth:(CGFloat)borderWidth
        borderColor:(UIColor *)borderColor;


/// 快速创建UILabel
/// @param rect 坐标
/// @param line 行数
/// @param align 字体位置
/// @param font 字体
/// @param textColor 字体颜色
/// @param text 内容
/// @param Radius 圆角大小
+ (UILabel *)ui_label:(CGRect)rect
                lines:(NSInteger)line
                align:(NSTextAlignment)align
                 font:(UIFont *)font
            textColor:(UIColor *)textColor
                 text:(NSString *)text
               Radius:(CGFloat)Radius;

/// 快速创建UIButton
/// @param rect 坐标
/// @param font 字体
/// @param normalColor 字体颜色
/// @param normalText 文字
/// @param click 点击事件
+ (UIButton *)ui_buttonSimple:(CGRect)rect
                         font:(UIFont *)font
                  normalColor:(UIColor *)normalColor
                   normalText:(NSString *)normalText
                        click:(void (^)(id x))click;

/// 创建指定圆角视图
/// @param rect 坐标
/// @param direction 圆角方向
/// @param toview 圆角View
/// @param sizeMake 圆角大小
+(UIView *) ui_uiViewFillet:(CGRect)rect
              Viewdirection:(YCUIdirection)direction
                     toView:(UIView *)toview
                   sizeMake:(CGFloat)sizeMake;


/// 金币换算单位
/// @param gold 金币
+(NSString *)goldConversion:(NSString *)gold;

/// 换算时分秒
/// @param totalSeconds 秒
/// @param type 换算类型 1 时分秒 其他 分秒
+ (NSString *)timeFormatted:(NSInteger)totalSeconds
                       type:(int)type;


/// @param title 文字
/// @param index 变换颜色开始位
/// @param fonts 字体
/// @param colors 颜色
+ (NSAttributedString *)attributedTextWith:(NSString *)title
                                     index:(int)index
                                     fonts:(UIFont *)fonts
                                     color:(UIColor *)colors;

/**
 创建textField
 
 @param rect 尺寸大小
 @param backColor 背景颜色
 @param font 字体大小
 @param maxNum 最大数量 传0表示没有限制
 @param placeholderColor 默认字体颜色
 @param placeholder 默认字
 @param toMaxNum 设置了最大数量后回调
 @param change 监听内容改变
 @return 对象
 */
+ (UITextField *)ui_textField:(CGRect)rect textColor:(UIColor *)textColor backColor:(UIColor *)backColor font:(UIFont *)font maxTextNum:(NSInteger)maxNum placeholderColor:(UIColor *)placeholderColor placeholder:(NSString *)placeholder toMaxNum:(void(^)(UITextField *textField))toMaxNum change:(void(^)(UITextField *textField))change;

/// UIlabel 某个位置文字多种颜色
/// @param title 文字
/// @param index 变换颜色开始位
/// @param toindex 结束位
/// @param fonts 字体
/// @param colors 颜色
/// @param tocolors 其他字段颜色
/// @param line 间距
+ (NSAttributedString *)attributedTextWiths:(NSString *)title
                                     index:(NSInteger)index
                                    toindex:(NSInteger)toindex
                                     fonts:(UIFont *)fonts
                                     color:(UIColor *)colors
                                     tocolor:(UIColor *)tocolors
                                       line:(CGFloat)line;

+ (NSString *)getShowDateWithTime:(NSString *)time;


+ (NSString *)outPutDNSServers;

/*
 topSize 图片顶部距离
 bgImg 背景图片
 image 里面的小图标
 imgSize 图片大小
 space 图片和label的距离
 labelSize label高
 font label字体大小
 color label文字颜色
 title label文字
 click 点击事件
 */
+ (UIView *)customButtonTopSize:(CGFloat)topSize bgImage:(UIImage *)bgImg image:(UIImage *)image imageSize:(CGFloat)imgSize imgLabelSpace:(CGFloat)space labelSize:(CGFloat)labelsize labelFont:(UIFont *)font labelColor:(UIColor *)color title:(NSString *)title click:(void (^)(id x))click;


/*
 我的页面 福豆商城、我的钱包、典故卡创建
 */
+ (UIView *)myOtherViewWithIcon:(UIImage *)iconimage title:(NSString *)title withLabel:(UILabel *)label index:(int)index click:(void (^)(id x))click;

//快速创建黑底和白底view
+ (UIView *)ui_viewBlackAndWhite:(UIColor *)bgColor;

@end

NS_ASSUME_NONNULL_END
