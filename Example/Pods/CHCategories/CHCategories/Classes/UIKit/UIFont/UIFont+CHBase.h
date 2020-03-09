//
//  UIFont+CHBase.h
//  Pods
//
//  Created by CHwang on 17/1/10.
//  
//

#import <UIKit/UIKit.h>
#import <CoreText/CTFont.h> 
#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CHUIFontWeightType) { ///< 字体粗细类型
    CHUIFontWeightTypeLight,                     ///< 细体
    CHUIFontWeightTypeNormal,                    ///< 普通
    CHUIFontWeightTypeBold,                      ///< 粗体
};

@interface UIFont (CHBase)

#pragma mark - Base
@property (nonatomic, readonly) CGFloat ch_fontWeight NS_AVAILABLE_IOS(7_0); ///< 字体宽度(-1.0~1.0, Regular字体宽度为0.0)

/**
 根据当前字体, 创建带粗体的字体

 @return 带粗体的字体
 */
- (UIFont *)ch_fontWithBold NS_AVAILABLE_IOS(7_0);

/**
 根据当前字体, 创建带斜体的字体

 @return 带斜体的字体
 */
- (UIFont *)ch_fontWithItalic NS_AVAILABLE_IOS(7_0);

/**
 根据当前字体, 创建带粗体和斜体的字体

 @return 带粗体和斜体的字体
 */
- (UIFont *)ch_fontWithBoldItalic NS_AVAILABLE_IOS(7_0);

/**
 根据当前字体, 创建普通字体(无粗体/斜体...)

 @return 普通字体(无粗体/斜体...)
 */
- (UIFont *)ch_fontWithNormal NS_AVAILABLE_IOS(7_0);

/**
 根据CTFont, 创建字体

 @param CTFont CTFont
 @return 字体
 */
+ (nullable UIFont *)ch_fontWithCTFont:(CTFontRef)CTFont;

/**
 根据CGFont, 创建字体

 @param CGFont CGFont
 @param size 字体大小
 @return 字体
 */
+ (nullable UIFont *)ch_fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size;

/**
 根据字体, 创建CTFontRef(需调用CFRelease()方法释放)

 @return CTFontRef
 */
- (CTFontRef)ch_CTFontRef CF_RETURNS_RETAINED;

/**
 根据字体, 创建CGFontRef(需调用CFRelease()方法释放)

 @return CGFontRef
 */
- (CGFontRef)ch_CGFontRef CF_RETURNS_RETAINED;

#pragma mark - Create
/**
 获取细体类型的系统字体
 
 @param fontSize 字体大小
 @return 字体
 */
+ (UIFont *)ch_lightSystemFontOfSize:(CGFloat)fontSize;

/**
 根据字体大小、字体粗细类型及是否斜体, 创建系统字体

 @param pointSize 字体大小
 @param weightType 字体粗细类型
 @param italic 是否斜体
 @return 字体
 */
+ (UIFont *)ch_systemFontOfSize:(CGFloat)pointSize
                     weightType:(CHUIFontWeightType)weightType
                         italic:(BOOL)italic;

/**
 根据字体大小、 字体粗细类型及是否斜体, 创建动态系统字体

 @param pointSize 字体大小
 @param weightType 字体粗细类型
 @param italic 是否斜体
 @return 字体
 */
+ (UIFont *)ch_dynamicSystemFontOfSize:(CGFloat)pointSize
                            weightType:(CHUIFontWeightType)weightType
                                italic:(BOOL)italic;

/**
 根据字体大小、 最大字体大小、最小字体大小、字体粗细类型及是否斜体, 创建动态系统字体

 @param pointSize 字体大小
 @param minimumPointSize 最大字体大小
 @param maximumPointSize 最小字体大小
 @param weightType 字体粗细类型
 @param italic 是否斜体
 @return 字体
 */
+ (UIFont *)ch_dynamicSystemFontOfSize:(CGFloat)pointSize
                      minimumPointSize:(CGFloat)minimumPointSize
                      maximumPointSize:(CGFloat)maximumPointSize
                            weightType:(CHUIFontWeightType)weightType
                                italic:(BOOL)italic;

#pragma mark - Check
@property (nonatomic, readonly) BOOL ch_isBold NS_AVAILABLE_IOS(7_0);        ///< 字体是否粗体
@property (nonatomic, readonly) BOOL ch_isItalic NS_AVAILABLE_IOS(7_0);      ///< 字体是否斜体
@property (nonatomic, readonly) BOOL ch_isMonoSpace NS_AVAILABLE_IOS(7_0);   ///< 字体是否等宽
@property (nonatomic, readonly) BOOL ch_isColorGlyphs NS_AVAILABLE_IOS(7_0); ///< 字体是否颜色雕纹(类似Emoji)

#pragma mark - Load & Unload
/**
 根据字体文件路径, 加载字体(支持格式:TTF,OTF)

 @param path 字体文件路径
 @return 加载成功返回YES, 否则返回NO
 */
+ (BOOL)ch_loadFontFromPath:(NSString *)path;

/**
 根据字体文件路径, 卸载字体

 @param path 字体文件路径
 */
+ (void)ch_unloadFontFromPath:(NSString *)path;

/**
 根据字体data, 加载字体(支持格式:TTF,OTF)

 @param data 字体data
 @return  字体
 */
+ (nullable UIFont *)ch_loadFontFromData:(NSData *)data;

/**
 根据字体(通过loadFontFromData:方法加载), 卸载字体

 @param font 字体(通过loadFontFromData:方法加载)
 @return 卸载成功返回YES, 否则返回NO
 */
+ (BOOL)ch_unloadFontFromData:(UIFont *)font;

#pragma mark - Font Data
/**
 解析并返回字体的data(TTF, error -> nil)

 @param font 字体
 @return 字体data
 */
+ (NSData *)ch_dataFromFont:(UIFont *)font;

/**
 解析并返回CGFont字体的data(TTF, error -> nil)

 @param cgFont CGFontRef
 @return CGFont字体data
 */
+ (nullable NSData *)ch_dataFromCGFont:(CGFontRef)cgFont;

@end

NS_ASSUME_NONNULL_END
