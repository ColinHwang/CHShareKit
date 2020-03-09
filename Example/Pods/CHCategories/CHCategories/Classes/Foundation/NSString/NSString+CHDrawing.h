//
//  NSString+CHDrawing.h
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//  文字绘制处理

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/NSParagraphStyle.h>

NS_ASSUME_NONNULL_BEGIN

@class UIFont;

@interface NSString (CHDrawing)

/**
 获取字符串的Size
 
 @param font          字符串Font
 @param size          宽高限制, 用于计算文本绘制时占据的最大矩形块
 @param lineBreakMode 文字换行模式
 @return 字符串的Size
 */
- (CGSize)ch_sizeForFont:(UIFont *)font
                    size:(CGSize)size
                    mode:(NSLineBreakMode)lineBreakMode;

/**
 获取字符串宽度(单行)
 
 @param font 字符串Font
 @return 字符串宽度
 */
- (CGFloat)ch_widthForFont:(UIFont *)font;

/**
 获取字符串高度
 
 @param font  字符串的Font
 @param width 宽度限制, 用于计算文本绘制时占据的最大宽度
 @return 字符串高度
 */
- (CGFloat)ch_heightForFont:(UIFont *)font width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
