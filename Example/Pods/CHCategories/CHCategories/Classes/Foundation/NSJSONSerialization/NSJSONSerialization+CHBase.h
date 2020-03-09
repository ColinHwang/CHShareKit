//
//  NSJSONSerialization+CHBase.h
//  Pods
//
//  Created by CHwang on 17/2/4.
//
//  Base

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSJSONSerialization (CHBase)

#pragma mark - Base
/**
 根据JSON字符串, 获取JSONObject(NSDictionary/NSArray, 无法获取返回nil)

 @param string JSON字符串
 @param error Error
 @return NSDictionary/NSArray, 无法获取返回nil
 */
+ (nullable id)ch_JSONObjectWithString:(NSString *)string error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
