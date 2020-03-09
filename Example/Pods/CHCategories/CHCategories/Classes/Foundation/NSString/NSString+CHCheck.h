//
//  NSString+CHCheck.h
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//  字符串检测处理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CHCheck)

/**
 字符串是否为十进制数字字符(0-9)

 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isDecimalNumber;

/**
 字符串是否为英文字符

 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isLetter;

/**
 字符串是否为小写英文字符

 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isLowercaseLetter;

/**
 字符串是否为大写英文字符

 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isUppercaseLetter;

/**
 字符串是否为邮箱
 
 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isEmail;

/**
 字符串是否为手机号码
 
 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isMobilePhone;

/**
 字符串是否为固话号码
 
 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isTelNumber;

/**
 字符串是否为中华人民共和国居民身份证
 
 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isValidCardIDOfPRC;

/**
 字符串是否为中华人民共和国香港特别行政区居民身份证
 
 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isValidCardIDOfHK;

@end

NS_ASSUME_NONNULL_END
