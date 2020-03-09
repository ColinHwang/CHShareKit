//
//  CHSKNetworking.m
//  
//
//  Created by CHwang on 2019/5/10.
//

#import "CHSKNetworking.h"

#import <AFNetworking/AFNetworking.h>
#import "CHSKAPIDefines.h"

@interface CHSKNetworking ()

@property (nonatomic, strong) AFHTTPSessionManager *HTTPSessionManager;

@end

@implementation CHSKNetworking

#pragma mark - Life cycle
+ (instancetype)defaultManagger {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Public methods
+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *task, id data))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [[CHSKNetworking defaultManagger].HTTPSessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success ?: success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(task, error);
    }];;
}

+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSURLSessionDataTask *task, id data))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [[CHSKNetworking defaultManagger].HTTPSessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success ?: success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(task, error);
    }];
}

#pragma mark - Private methods

#pragma mark - setters/getters
- (AFHTTPSessionManager *)HTTPSessionManager {
    if (!_HTTPSessionManager) {
        NSURL *baseURL = [NSURL URLWithString:nil];
        _HTTPSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
        [acceptableContentTypes addObject:@"text/plain"];
        jsonResponseSerializer.acceptableContentTypes = acceptableContentTypes.copy;
        _HTTPSessionManager.responseSerializer = jsonResponseSerializer;
        
        _HTTPSessionManager.requestSerializer.timeoutInterval = 20.f;
        [_HTTPSessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request) {
            return request;
        }];
    }
    return _HTTPSessionManager;
}

@end
