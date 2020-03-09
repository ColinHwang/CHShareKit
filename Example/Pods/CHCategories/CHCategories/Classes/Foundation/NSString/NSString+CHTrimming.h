//
//  NSString+CHTrimming.h
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//  字符串筛除处理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CHTrimming)

/**
 去除字符串所有的十进制数字字符(0-9)
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingDecimalNumbers;

/**
 去除字符串所有的英文字符(大小写)
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingLetters;

/**
 去除字符串所有的大写英文字符
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingUppercaseLetters;

/**
 去除字符串所有的小写英文字符
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingLowercaseLetters;

/**
 去除字符串所有的英文(大小写)及十进制数字(0-9)字符
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingAlphanumericCharacters;

/**
 去除字符串所有的英文标点符号
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingPunctuation;

/**
 去除字符串所有的指定字符
 
 @param character 指定字符
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingCharacter:(unichar)character;

/**
 去除字符串所有的空格
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingAllWhitespace;

/**
 去除字符串的多余空格(首尾空格及中间空格，@" A  is     Ok. " -> @"A is Ok."), 仅用于以空格分隔的语言
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingExtraWhitespace;

/**
 去除字符串首尾的空格(Unico字符)
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingWhitespace;

/**
 去除字符串首尾的空格和换行(Unico字符)
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingWhitespaceAndNewline;

/**
 去除字符串所有的换行符号(\n\r)

 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingLineBreakCharacters;

/**
 去除字符串所有的未知字符, 避免UI上的展示问题

 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingUnknownCharacters;

/**
 获取过滤空格字符及换行字符的子字符串集

 @return 过滤空格字符及换行字符(Unico字符)的子字符串集
 */
- (NSArray<NSString *> *)ch_substringsByTrimmingWhitespaceAndNewline;

@end

NS_ASSUME_NONNULL_END
