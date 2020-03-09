//
//  NSAttributedString+CHCreation.h
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//  AttributedString便捷创建方法

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NSParagraphStyle, UIFont, UIColor;

@interface NSAttributedString (CHCreation)

#pragma mark - Creation
/**
 根据字符串及文字颜色, 创建NSAttributedString
 
 @param string    字符串
 @param textColor 文字颜色
 @return NSAttributedString对象
 */
+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string textColor:(UIColor *)textColor;

/**
 根据字符串及背景颜色, 创建NSAttributedString
 
 @param string          字符串
 @param backgroundColor 背景颜色
 @return NSAttributedString对象
 */
+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string backgroundColor:(UIColor *)backgroundColor;

/**
 根据字符串及Font, 创建NSAttributedString
 
 @param string 字符串
 @param font   字体
 @return NSAttributedString对象
 */
+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string font:(UIFont *)font;

/**
 根据字符串及ParagraphStyle, 创建NSAttributedString
 
 @param string         字符串
 @param paragraphStyle ParagraphStyle
 @return NSAttributedString对象
 */
+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string paragraphStyle:(NSParagraphStyle *)paragraphStyle;

/**
 根据字符串, 文字颜色, 背景颜色, Font及ParagraphStyle, 创建NSAttributedString
 
 @param string          字符串
 @param textColor       文字颜色
 @param backgroundColor 背景颜色
 @param font            字体
 @param paragraphStyle  ParagraphStyle
 @return NSAttributedString对象
 */
+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string
                                            textColor:(nullable UIColor *)textColor
                                      backgroundColor:(nullable UIColor *)backgroundColor
                                                 font:(nullable UIFont *)font
                                       paragraphStyle:(nullable NSParagraphStyle *)paragraphStyle;

#pragma mark - Mask
/**
 根据字符串, 文字颜色, Font及遮盖范围, 创建NSAttributedString并遮盖部分文字(遮盖颜色:透明)
 
 @param string    字符串
 @param color     文字颜色
 @param font      Font
 @param maskRange 遮盖范围
 @return NSAttributedString对象
 */
+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string
                                            textColor:(UIColor *)color
                                                 font:(UIFont *)font
                                            maskRange:(NSRange)maskRange;

/**
 根据字符串, 字符属性集, 遮盖范围及遮盖属性集, 创建NSAttributedString并遮盖部分文字
 
 @param string    字符串
 @param attrs     字符属性集
 @param maskRange 遮盖范围
 @param maskAttrs 遮盖属性集
 @return NSAttributedString对象
 */
+ (NSAttributedString *)ch_attributedStringWithString:(NSString *)string
                                           attributes:(NSDictionary<NSString *, id> *)attrs
                                            maskRange:(NSRange)maskRange
                                       maskAttributes:(NSDictionary<NSString *, id> *)maskAttrs;

#pragma mark - Size
/**
 根据占位宽度, 创建占位NSAttributedString

 @param width 占位宽度
 @return NSAttributedString对象
 */
+ (NSAttributedString *)ch_attributedStringWithWidth:(CGFloat)width;

/**
 根据占位高度, 创建占位NSAttributedString

 @param height 占位高度
 @return NSAttributedString对象
 */
+ (NSAttributedString *)ch_attributedStringWithHeight:(CGFloat)height;

/**
 根据占位尺寸, 创建占位NSAttributedString

 @param size 占位尺寸
 @return NSAttributedString对象
 */
+ (NSAttributedString *)ch_attributedStringWithSize:(CGSize)size;

#pragma mark - Image
/**
 根据图片, 创建图片NSAttributedString(无图片则返回nil)

 @param image 图片
 @return NSAttributedString对象(无图片则返回nil)
 */
+ (nullable NSAttributedString *)ch_attributedStringWithImage:(UIImage *)image;

/**
 根据图片、图片相对基线的垂直偏移、图片距离左侧内容的间距及距离右侧内容的间距, 创建图片NSAttributedString(无图片则返回nil)

 @param image 图片
 @param baselineOffset 图片相对基线的垂直偏移（baselineOffset>0, 则图片向上偏移）
 @param leftSpacing 图片距离左侧内容的间距(大于或等于0)
 @param rightSpacing 图片距离右侧内容的间距(大于或等于0)
 @return NSAttributedString对象(无图片则返回nil)
 */
+ (nullable NSAttributedString *)ch_attributedStringWithImage:(UIImage *)image
                                               baselineOffset:(CGFloat)baselineOffset
                                                  leftSpacing:(CGFloat)leftSpacing
                                                 rightSpacing:(CGFloat)rightSpacing;

#pragma mark - HTML
/**
 根据HTML字符串, 创建NSAttributedString对象

 @param HTMLString HTML字符串
 @return NSAttributedString对象
 */
- (nullable instancetype)ch_initWithHTMLString:(NSString *)HTMLString;

@end

NS_ASSUME_NONNULL_END
