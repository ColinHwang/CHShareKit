//
//  CHSKNetworking.h
//  HDLive
//
//  Created by CHwang on 2019/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 网络请求工具类
 */
@interface CHSKNetworking : NSObject

#pragma mark - Public methods
+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *task, id data))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSURLSessionDataTask *task, id data))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
