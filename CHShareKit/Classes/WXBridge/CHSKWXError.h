//
//  CHSKWXError.h
//  
//
//  Created by CHwang on 2019/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 微信HTTP错误信息
 */
@interface CHSKWXError : NSObject

@property (nonatomic, copy) NSString *errcode; ///< 错误码
@property (nonatomic, copy) NSString *errmsg; ///< 错误信息

@end

NS_ASSUME_NONNULL_END
