//
//  GGUI.m
//  guosuoshan
//
//  Created by 沙狐 on 2020/3/16.
//  Copyright © 2020 沙狐. All rights reserved.
//

#import "GGUI.h"

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>




#define F(string, args...)                  [NSString stringWithFormat:string, args]
@implementation GGUI


#pragma mark - 快速创建UIView

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
        borderColor:(UIColor *)borderColor
{
    
    UIView *view = [[UIView alloc]init];
    view.frame = rect;
    if (backColor) view.backgroundColor = backColor;
    view.alpha = alpha;
    view.layer.cornerRadius = cornerRadius;
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = borderColor.CGColor;
    return view;
}

#pragma mark - 快速创建UILabel

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
               Radius:(CGFloat)Radius
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = rect;
    label.textAlignment = align;
    
    label.text = text?:@"";
    label.textColor = textColor;
    label.numberOfLines = line;
    label.font = font;
    label.layer.cornerRadius = Radius;
    label.layer.masksToBounds = YES;
    return label;
}
#pragma mark - 快速创建UIButton

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
                        click:(void (^)(id x))click
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    if (font) btn.titleLabel.font = font;
    if (normalColor) [btn setTitleColor:normalColor forState:UIControlStateNormal];
    if (normalText) [btn setTitle:normalText forState:UIControlStateNormal];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (click) {
            click(x);
        }
    }];
    return btn;
}

/// 创建指定圆角视图
/// @param rect 坐标
/// @param direction 圆角方向
/// @param toview 圆角View
/// @param sizeMake 圆角大小
+(UIView *) ui_uiViewFillet:(CGRect)rect
              Viewdirection:(YCUIdirection)direction
                     toView:(UIView *)toview
                   sizeMake:(CGFloat)sizeMake
{
    UIBezierPath *maskPath;
    if (direction == YCUIdirectionTop)
    {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(sizeMake, sizeMake)];
         
    }
    else if(direction == YCUIdirectionBotton)
    {
         maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(sizeMake, sizeMake)];
    }
    else if(direction == YCUIdirectionLeft)
    {
         maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(sizeMake, sizeMake)];
    }
    else if(direction == YCUIdirectionRight)
    {
         maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(sizeMake, sizeMake)];
    }
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            maskLayer.path = maskPath.CGPath;
            toview.layer.mask  = maskLayer;
    return toview;
}

#pragma mark - 快速创建textField
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
+ (UITextField *)ui_textField:(CGRect)rect textColor:(UIColor *)textColor backColor:(UIColor *)backColor font:(UIFont *)font maxTextNum:(NSInteger)maxNum placeholderColor:(UIColor *)placeholderColor placeholder:(NSString *)placeholder toMaxNum:(void(^)(UITextField *textField))toMaxNum change:(void(^)(UITextField *textField))change
{
    
    UITextField *tf = [[UITextField alloc]init];
    tf.frame = rect;
    tf.backgroundColor = backColor;
    tf.font = font;
    if (textColor) tf.textColor = textColor;
    
    //默认字
    tf.placeholder = placeholder?:@"";
    //[tf setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    //tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"placeholder" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor], NSFontAttributeName: Font_(13)}];
    
    if (maxNum > 0) {
        [[tf.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
            return value.length >= maxNum;
        }] subscribeNext:^(NSString * _Nullable x) {
            tf.text = [x substringToIndex:maxNum];
            if (toMaxNum) {
                toMaxNum(tf);
            }
        }];
    }
    
    [[tf rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        if (change) {
            change(tf);
        }
    }];
    
    return tf;
}



/// 金币换算单位
/// @param gold 金币
+ (NSString *)goldConversion:(NSString *)gold
{
    NSInteger length = gold.length;
    if (length <= 5)
    {
        return gold;
    }
    if (length < 8)
    {
        double space = pow(1000, 1);
        CGFloat ff = [gold doubleValue]/space;
        if ((int)ff == ff) {
           return F(@"%.0fk",ff);
        }else{
           return F(@"%.2fk",ff);
        }
//        return ff > 10000 ? F(@"%.0fk", ff) : F(@"%.2fk",ff);
    }
    NSInteger number = (length-4)/3;
    double space = pow(1000, number);
    CGFloat point = [gold doubleValue]/space;
    switch (number)
    {
        case 1:
            if ((int)point == point) {
                return F(@"%.0fk",point);
            }else{
                return F(@"%.2fk",point);
            }
            break;
        case 2:
            return F(@"%.0fm", point);
            break;
        case 3:
            return F(@"%.0fg", point);
            break;
        case 4:
            return F(@"%.0ft", point);
            break;
        case 5:
            return F(@"%.0fp", point);
            break;
        case 6:
            return F(@"%.0fe", point);
            break;
        case 7:
            return F(@"%.0fb", point);
            break;
        case 8:
            return F(@"%.0faa", point);
            break;
        case 9:
            return F(@"%.0fbb", point);
            break;
        case 10:
            return F(@"%.0fcc", point);
            break;
        case 11:
            return F(@"%.0fdd", point);
            break;
            
        default:
            break;
    }
    
    return gold;
}


/// 换算时分秒
/// @param totalSeconds 秒
/// @param type 换算类型 0：时分秒 1：分秒 2：其他
+ (NSString *)timeFormatted:(NSInteger)totalSeconds
                       type:(int)type
{
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if(type == 0)
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
    else if(type == 1)
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    else
        return [NSString stringWithFormat:@"%ld", (long)minutes];
        
}


/// UIlabel 文字多种颜色
/// @param title 文字
/// @param index 变换颜色开始位
/// @param fonts 字体
/// @param colors 颜色
+ (NSAttributedString *)attributedTextWith:(NSString *)title
                                     index:(int)index
                                     fonts:(UIFont *)fonts
                                     color:(UIColor *)colors
{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:colors range:NSMakeRange(0,index)];
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(92, 207, 230, 1) range:NSMakeRange(index,title.length-index)];
    [str addAttribute:NSFontAttributeName value:fonts range:NSMakeRange(0, index)];
    [str addAttribute:NSFontAttributeName value:fonts range:NSMakeRange(index, title.length-index)];
    
    return str;
}

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
                                       line:(CGFloat)line
{
    
    NSRange symbolRange = [title rangeOfString:@"元"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:colors range:NSMakeRange(index,toindex)];
    [str addAttribute:NSFontAttributeName value:fonts range:NSMakeRange(index, toindex)];
    [str addAttribute:NSForegroundColorAttributeName value:tocolors range:NSMakeRange(toindex,title.length-toindex)];
    if (symbolRange.location != NSNotFound) {
        [str addAttribute:NSFontAttributeName value:Font_(12) range:NSMakeRange(symbolRange.location, symbolRange.length)];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    
    return str;
}


+ (NSString *)getShowDateWithTime:(NSString *)time
{
    NSDate *timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:[time integerValue]/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd hh:mm";
    NSString *timeStr = [dateFormatter stringFromDate:timeDate];
    return timeStr;
 
}


#pragma mark - 获取本机DNS服务器
///获取本机DNS服务器
+ (NSString *)outPutDNSServers
{
    res_state res = malloc(sizeof(struct __res_state));
    int result = res_ninit(res);
    NSMutableArray *dnsArray = @[].mutableCopy;
    if ( result == 0 )
    {
        for ( int i = 0; i < res->nscount; i++ )
        {
            NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[i].sin_addr)];
            [dnsArray addObject:s];
        }
    }
    else
    {
        NSLog(@"%@",@" res_init result != 0");
    }
    res_nclose(res);

    return dnsArray.firstObject;
}

+ (UIView *)customButtonTopSize:(CGFloat)topSize bgImage:(UIImage *)bgImg image:(UIImage *)image imageSize:(CGFloat)imgSize imgLabelSpace:(CGFloat)space labelSize:(CGFloat)labelsize labelFont:(UIFont *)font labelColor:(UIColor *)color title:(NSString *)title click:(void (^)(id x))click{
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor clearColor];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:bgImg];
    [customView addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(customView);
    }];
    UIImageView *img = [[UIImageView alloc] initWithImage:image];
    [customView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(customView);
        make.top.mas_equalTo(customView.mas_top).inset(topSize);
        make.width.and.height.mas_equalTo(imgSize);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.adjustsFontSizeToFitWidth = YES;
    [customView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_top).inset(space);
        make.left.and.right.mas_equalTo(customView);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(customView);
    }];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (click) {
            click(x);
        }
    }];
    return customView;
}

+ (UIView *)myOtherViewWithIcon:(UIImage *)iconimage title:(NSString *)title withLabel:(UILabel *)label index:(int)index click:(void (^)(id x))click{
    UIView *otherview = [GGUI ui_view:CGRectZero backgroundColor:[UIColor clearColor] alpha:1 cornerRadius:0 borderWidth:0 borderColor:[UIColor clearColor]];
    //图标
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:iconimage];
    [otherview addSubview:iconImg];
    //文字
    UILabel *titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(16) textColor:MYTEXT_COLOR text:title Radius:0];
    [otherview addSubview:titleLabel];
    label = titleLabel;
    //箭头
    UIImageView *jtImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_jiantou"]];
    [otherview addSubview:jtImg];
    //福豆商城
    if (index == 0) {
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ANDY_Adapta(22));
            make.centerY.mas_equalTo(0);
            make.width.and.height.mas_equalTo(ANDY_Adapta(30));
        }];
        titleLabel.textColor = RGBA(143, 67, 11, 1);
        titleLabel.font = FontBold_(16);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconImg.mas_right).offset(ANDY_Adapta(12));
            make.top.and.height.mas_equalTo(otherview);
            make.width.mas_equalTo(ANDY_Adapta(367));
        }];
        UILabel *titleLabel1 = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentRight font:Font_(15) textColor:RGBA(143, 67, 11, 1) text:@"福豆商城" Radius:0];
        [otherview addSubview:titleLabel1];
        [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right);
            make.top.and.height.mas_equalTo(otherview);
            make.width.mas_equalTo(ANDY_Adapta(200));
        }];
        jtImg.image = [UIImage imageNamed:@"my_fdJiantou"];
        [jtImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel1.mas_right);
            make.centerY.mas_equalTo(0);
            make.width.and.height.mas_equalTo(ANDY_Adapta(32));
        }];
//        if (![WXApi isWXAppInstalled] || [PBCache shared].memberModel.userType == 2) {
//            titleLabel1.hidden = YES;
//            jtImg.hidden = YES;
//        }
    }else{   //钱包、典故卡等
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ANDY_Adapta(31));
            make.centerY.mas_equalTo(0);
            make.width.and.height.mas_equalTo(ANDY_Adapta(36));
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconImg.mas_right).offset(ANDY_Adapta(31));
            make.top.and.height.mas_equalTo(otherview);
            make.width.mas_equalTo(ANDY_Adapta(533));
        }];
        [jtImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right);
            make.centerY.mas_equalTo(0);
            make.width.and.height.mas_equalTo(ANDY_Adapta(32));
        }];
        //线
        UIImageView *lineImg = [[UIImageView alloc] init];
        lineImg.backgroundColor = RGBA(204, 204, 204, 1);
        [otherview addSubview:lineImg];
        [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ANDY_Adapta(26));
            make.bottom.mas_equalTo(otherview);
            make.width.mas_equalTo(ANDY_Adapta(638));
            make.height.mas_equalTo(ANDY_Adapta(1));
        }];
    }
    //添加点击
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherview addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(otherview);
    }];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (click) {
            click(x);
        }
    }];
    return otherview;
}

//快速创建黑底和白底view
+ (UIView *)ui_viewBlackAndWhite:(UIColor *)bgColor{
    UIView *view = [[UIView alloc] init];
    view.layer.cornerRadius = ANDY_Adapta(20);
    view.layer.masksToBounds = YES;
    view.backgroundColor = bgColor;
    return view;
}


@end
