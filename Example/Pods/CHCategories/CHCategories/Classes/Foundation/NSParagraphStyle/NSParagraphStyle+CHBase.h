//
//  NSParagraphStyle+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreText/CTParagraphStyle.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSParagraphStyle (CHBase)

#pragma mark - Base
/**
 根据CTParagraphStyleRef, 创建NSParagraphStyle
 
 @param CTParagraphStyle CTParagraphStyleRef
 
 @return NSParagraphStyle对象
 */
+ (nullable NSParagraphStyle *)ch_paragraphstyleWithCTParagraphStyle:(CTParagraphStyleRef)CTParagraphStyle;

/**
 创建CTParagraphStyleRef(需调用CFRelease()方法释放)

 @return CTParagraphStyleRef
 */
- (CTParagraphStyleRef)ch_CTParagraphStyle CF_RETURNS_RETAINED;

#pragma mark - Creation
/**
 根据行高(最小及最大)、分割模式, 创建NSParagraphStyle

 @param lineHeight 行高(最小及最大)
 @return NSParagraphStyle对象
 */
+ (instancetype)ch_paragraphStyleWithLineHeight:(CGFloat)lineHeight;

/**
 根据行高(最小及最大)及分割模式, 创建NSParagraphStyle

 @param lineHeight    行高(最小及最大)
 @param lineBreakMode 分割模式
 @return NSParagraphStyle对象
 */
+ (instancetype)ch_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 根据行高(最小及最大)、分割模式及对齐方式, 创建NSParagraphStyle

 @param lineHeight    行高(最小及最大)
 @param lineBreakMode 分割模式
 @param textAlignment 对齐方式
 @return NSParagraphStyle对象
 */
+ (instancetype)ch_paragraphStyleWithLineHeight:(CGFloat)lineHeight
                                  lineBreakMode:(NSLineBreakMode)lineBreakMode
                                  textAlignment:(NSTextAlignment)textAlignment;

@end


@interface NSMutableParagraphStyle (CHBase)

#pragma mark - Base
/**
 添加TabStop

 @param tabStop TabStop
 */
- (void)ch_addTabStop:(NSTextTab *)tabStop;

/**
 移除TabStop

 @param tabStop TabStop
 */
- (void)ch_removeTabStop:(NSTextTab *)tabStop;

/**
 根据指定的ParagraphStyle, 替换子属性

 @param paragraphStyle 指定的ParagraphStyl
 */
- (void)ch_setParagraphStyle:(NSParagraphStyle *)paragraphStyle;

@end

NS_ASSUME_NONNULL_END
