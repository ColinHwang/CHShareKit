//
//  NSString+CHChinese.h
//  Pods
//
//  Created by CHwang on 17/6/15.
//
//  字符串中文处理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, CHNSStringChineseType) {   // 中文字符类型
    CHNSStringChineseTypeCharacter              = 1 << 0, // 中文文字
    CHNSStringChineseTypePunctuation            = 1 << 1, // 中文标点
    CHNSStringChineseTypeRadical                = 1 << 2, // 中文部首
    CHNSStringChineseTypeStroke                 = 1 << 3, // 中文笔划
    CHNSStringChineseTypeIdeographicDescription = 1 << 4, // 中文构字描述符
    CHNSStringChineseTypeAll = CHNSStringChineseTypeCharacter | CHNSStringChineseTypePunctuation | CHNSStringChineseTypeRadical | CHNSStringChineseTypeStroke | CHNSStringChineseTypeIdeographicDescription
};

@interface NSString (CHChinese)

/**
 字符串是否为中文字符

 @param type 中文字符类型
 @return 仅当字符串是单个中文字符返回YES, 否则返回NO
 */
- (BOOL)ch_isChinese:(CHNSStringChineseType)type;

/**
 字符串是否包含中文字符

 @param type 中文字符类型
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsChinese:(CHNSStringChineseType)type;

/**
 获取指定范围内, 字符串中的所有中文字符

 @param range 指定范围
 @param type  中文字符类型
 @return 新字符串
 */
- (NSString *)ch_substringWithChinese:(CHNSStringChineseType)type inRange:(NSRange)range;

/**
 根据遍历范围, 遍历字符串中的所有中文字符
 
 @param range 遍历范围
 @param type  中文字符类型
 @param block 处理回调
 */
- (void)ch_enumerateChinese:(CHNSStringChineseType)type
                    inRange:(NSRange)range
                 usingBlock:(void (^)(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop))block;

/**
 将字符串中的所有中文字符替换为指定字符

 @param type        中文字符类型
 @param replacement 指定字符
 @return 新字符串
 */
- (NSString *)ch_stringByReplacingChinese:(CHNSStringChineseType)type withString:(NSString *)replacement;

/**
 去除字符串中所有的中文字符

 @param type 中文字符类型
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingChinese:(CHNSStringChineseType)type;

@end

NS_ASSUME_NONNULL_END
