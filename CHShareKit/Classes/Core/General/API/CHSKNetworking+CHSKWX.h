//
//  CHSKNetworking+CHSKWX.h
//  HDLive
//
//  Created by CHwang on 2019/5/10.
//

#import "CHSKNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHSKNetworking (CHSKWX)

/**
 获取WX用户的AccessToken

 @param code 业务码
 @param appId appId
 @param appSecret appSecret
 @param success success description
 @param failure failure description
 */
+ (void)getWXAccessTokenWithCode:(NSString *)code
                           appId:(NSString *)appId
                       appSecret:(NSString *)appSecret
                         success:(void (^)(id data))success
                         failure:(void (^)(NSError *error))failure;

/**
 获取WX用户信息

 @param accessToken AccessToken
 @param openId openId
 @param success success description
 @param failure failure description
 */
+ (void)getWXUserInfoWithAccessToken:(NSString *)accessToken
                              openId:(NSString *)openId
                             success:(void (^)(id data))success
                             failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
