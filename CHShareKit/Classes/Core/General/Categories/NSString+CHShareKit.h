//
//  NSString+CHShareKit.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CHShareKit)

/**
 是否为适用于微信分享的标题(512Bytes以内)
 
 @return 符合返回YES, 否则返回NO
 */
- (BOOL)ch_sk_isValidTitleForWX;

/**
 是否为适用于微信分享的描述文本(1KB以内)
 
 @return 符合返回YES, 否则返回NO
 */
- (BOOL)ch_sk_isValidDescForWX;

/**
 是否为适用于微信分享的URLString(10KB以内)
 
 @return 符合返回YES, 否则返回NO
 */
- (BOOL)ch_sk_isValidURLStringForWX;

- (NSString *)ch_sk_stringByAddingPercentEscapesForURL;

@end

NS_ASSUME_NONNULL_END
