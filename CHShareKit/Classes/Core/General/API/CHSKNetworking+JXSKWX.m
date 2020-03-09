//
//  CHSKNetworking+CHSKWX.m
//  HDLive
//
//  Created by CHwang on 2019/5/10.
//

#import "CHSKNetworking+CHSKWX.h"

#import "CHSKWXError.h"

#import "CHSKPrivateDefines.h"
#import "NSError+CHShareKit.h"
#import <YYModel/YYModel.h>

@implementation CHSKNetworking (CHSKWX)

+ (void)getWXAccessTokenWithCode:(NSString *)code
                           appId:(NSString *)appId
                       appSecret:(NSString *)appSecret
                         success:(void (^)(id data))success
                         failure:(void (^)(NSError *error))failure {
    NSString *URLString = @"https://api.weixin.qq.com/sns/oauth2/access_token";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = CH_SK_STR_AVOID_NIL(appId);
    params[@"secret"] = CH_SK_STR_AVOID_NIL(appSecret);
    params[@"code"] = CH_SK_STR_AVOID_NIL(code);
    params[@"grant_type"] = CH_SK_STR_AVOID_NIL(@"authorization_code");
    
    [CHSKNetworking GET:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        CHSKWXError *wxError = [CHSKWXError yy_modelWithJSON:data];
        if (wxError.errcode.length) {
            NSError *aError = [NSError ch_sk_errorWithCode:wxError.errcode.integerValue message:wxError.errmsg];
            !failure ?: failure(aError);
            return;
        }
        
        !success ?: success(data);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

+ (void)getWXUserInfoWithAccessToken:(NSString *)accessToken
                              openId:(NSString *)openId
                             success:(void (^)(id data))success
                             failure:(void (^)(NSError *error))failure {
    NSString *URLString = @"https://api.weixin.qq.com/sns/userinfo";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = CH_SK_STR_AVOID_NIL(accessToken);
    params[@"openid"] = CH_SK_STR_AVOID_NIL(openId);
    
    [CHSKNetworking GET:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        CHSKWXError *wxError = [CHSKWXError yy_modelWithJSON:data];
        if (wxError.errcode.length) {
            NSError *aError = [NSError ch_sk_errorWithCode:wxError.errcode.integerValue message:wxError.errmsg];
            !failure ?: failure(aError);
            return;
        }
        
        !success ?: success(data);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

@end