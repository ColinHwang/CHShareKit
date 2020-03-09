//
//  NSError+CHShareKit.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>
#import "CHSKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSError (CHShareKit)

/**
 根据内部错误码, 创建NSError对象

 @param code 错误码
 @return NSError对象
 */
+ (NSError *)ch_sk_errorWithCode:(CHSKErrorCode)code;

/**
 根据错误码和错误信息, 创建NSError对象

 @param code 错误码
 @param message 错误信息
 @return NSError对象
 */
+ (NSError *)ch_sk_errorWithCode:(NSInteger)code message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
