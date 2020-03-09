//
//  NSURLComponents+CHBase.h
//  Pods
//
//  Created by CHwang on 17/8/8.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLComponents (CHBase)

#pragma mark - Base
/**
 为URLComponentst添加指定的URLQueryItem

 @param queryItem 指定的URLQueryItem
 */
- (void)ch_addQueryItem:(NSURLQueryItem *)queryItem;

/**
 根据URLQueryItem名称及值, 为URLComponentst添加指定的URLQueryItem

 @param name  URLQueryItem名称
 @param value URLQueryItem值
 */
- (void)ch_addQueryItemWithName:(NSString *)name value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
