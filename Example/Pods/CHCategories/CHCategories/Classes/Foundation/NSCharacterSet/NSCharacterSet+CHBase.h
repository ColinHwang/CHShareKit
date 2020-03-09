//
//  NSCharacterSet+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2020/2/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCharacterSet (CHBase)

#pragma mark - Base
/**
 用户输入URLQuery字符集(在URLQueryAllowedCharacterSet基础上去除“#&=“字符, 用于URL Query里来源于用户输入的Value，避免服务器解析出现异常)
 */
@property (class, readonly, copy) NSCharacterSet *ch_URLQueryUserInputAllowedCharacterSet;

@end


@interface NSMutableCharacterSet (CHBase)

#pragma mark - Base
/**
 创建用户输入URLQuery字符集(在URLQueryAllowedCharacterSet基础上去掉“#&=“字符, 用于URL Query里来源于用户输入的Value，避免服务器解析出现异常)

 @return 用户输入URLQuery字符集
 */
+ (NSMutableCharacterSet *)ch_URLQueryUserInputAllowedCharacterSet;

@end

NS_ASSUME_NONNULL_END
