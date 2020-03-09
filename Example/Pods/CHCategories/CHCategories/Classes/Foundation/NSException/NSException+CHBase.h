//
//  NSException+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2019/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSException (CHBase)

#pragma mark - Base
/**
 设置是否开启KVC访问私有变量断言处理

 @param enabled YES开启, 否则不开启
 */
+ (void)ch_setupKVCAccessProhibitedExceptionEnabled:(BOOL)enabled;

/**
 是否开启KVC访问私有变量断言处理

 @return YES开启, 否则不开启
 */
+ (BOOL)ch_KVCAccessProhibitedExceptionEnabled;

@end

NS_ASSUME_NONNULL_END

