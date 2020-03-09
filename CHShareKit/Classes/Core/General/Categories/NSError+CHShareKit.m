//
//  NSError+CHShareKit.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "NSError+CHShareKit.h"
#import "CHSKPrivateDefines.h"

@implementation NSError (CHShareKit)

+ (NSError *)ch_sk_errorWithCode:(NSInteger)code message:(NSString *)message {
    NSMutableDictionary *userInfo = @{}.mutableCopy;
    userInfo[@"error"] = @(code);
    userInfo[@"error_description"] = CH_SK_STR_AVOID_NIL(message);
    return [NSError errorWithDomain:CHSKErrorDomin code:code userInfo:userInfo.copy];
}

+ (NSError *)ch_sk_errorWithCode:(CHSKErrorCode)code {
    NSString *message = @"";
    switch (code) {
        case CHSKErrorCodeUndefined:
        {
            message = @"未知错误";
        }
            break;
        case CHSKErrorCodeInvalidMessage:
        {
            message = @"无效的分享消息";
        }
            break;
        case CHSKErrorCodeUnsupportMessageType:
        {
            message = @"不支持的消息类型";
        }
            break;
        case CHSKErrorCodeInvalidMessageTitle:
        {
            message = @"无效的消息标题";
        }
            break;
        case CHSKErrorCodeInvalidMessageDesc:
        {
            message = @"无效的消息描述";
        }
            break;
        case CHSKErrorCodeInvalidMessageImages:
        {
            message = @"无效的消息图片";
        }
            break;
        case CHSKErrorCodeInvalidMessageURL:
        {
            message = @"无效的消息URL";
        }
            break;
        case CHSKErrorCodeInvalidMessageFileExt:
        {
            message = @"无效的消息文件后缀";
        }
            break;
        case CHSKErrorCodeUninstallPlatform:
        {
            message = @"用户未安装相关平台";
        }
            break;
        case CHSKErrorCodeNoResponse:
        {
            message = @"无返回消息";
        }
            break;
        case CHSKErrorCodeSDKAPIError:
        {
            message = @"SDKAPI调用失败";
        }
            break;
        case CHSKErrorCodeUnregisteredPlatform:
        {
            message = @"相关平台未注册";
        }
            break;
        case CHSKErrorCodeNetworkError:
        {
            message = @"网络问题";
        }
            break;
        case CHSKErrorCodeUnvalidAccessToken:
        {
            message = @"无效的AccessToken";
        }
            break;
        case CHSKErrorCodePlatformLoginFailure:
        {
            message = @"平台登录失败";
        }
            break;
    }
    return [NSError ch_sk_errorWithCode:code message:message];
}

@end
