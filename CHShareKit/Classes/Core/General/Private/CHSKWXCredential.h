//
//  CHSKWXCredential.h
//  HDLive
//
//  Created by CHwang on 2019/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 WX授权信息
 */
@interface CHSKWXCredential : NSObject

@property (nonatomic, copy) NSString *access_token; ///< 接口调用凭证
@property (nonatomic, copy) NSString *expires_in; ///< access_token接口调用凭证超时时间，单位（秒）
@property (nonatomic, copy) NSString *refresh_token; ///< 用户刷新access_token
@property (nonatomic, copy) NSString *openid; ///< 授权用户唯一标识
@property (nonatomic, copy) NSString *scope; ///< 用户授权的作用域，使用逗号（,）分隔
@property (nonatomic, strong) NSDictionary *rawData; ///< 原始数据

@end

NS_ASSUME_NONNULL_END
