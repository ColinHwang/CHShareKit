//
//  NSString+CHEmoji.h
//  Pods
//
//  Created by CHwang on 17/2/10.
//
//  字符串Emoji处理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CHEmoji)

/**
 字符串是否Emoji
 
 @return 仅当字符串是单个Emoji返回YES, 否则返回NO
 */
- (BOOL)ch_isEmoji;

/**
 是否包含Emoji
 
 @return 包含返回YES, 否则返回NO
 */
- (BOOL)ch_containsEmoji;

/**
 去除字符串所有的Emoji
 
 @return 新字符串
 */
- (NSString *)ch_stringByTrimmingEmoji;

@end

NS_ASSUME_NONNULL_END
