//
//  CHSKCredential.h
//  
//
//  Created by CHwang on 2019/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 授权凭证
 */
@interface CHSKCredential : NSObject

@property (nonatomic, copy) NSString *uid;           ///< 用户标识
@property (nonatomic, copy) NSString *token;         ///< 用户令牌
@property (nonatomic, copy) NSString *secret;        ///< 用户令牌密钥
@property (nonatomic, strong) NSDate *expired;       ///< 过期时间
@property (nonatomic, strong) NSDictionary *rawData; ///< 原始数据

@end

NS_ASSUME_NONNULL_END
