//
//  CHSKDefines.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>

#ifndef CHShareDefines_h
#define CHShareDefines_h

@class CHSKShareMessage, CHSKPlatformConfiguration, CHSKUser;

typedef NS_ENUM(NSInteger, CHSKPlatformType) { ///< 平台类型
    CHSKPlatformTypeUndefined  = 0,            ///< 未知
    CHSKPlatformTypeWXSession  = 1,            ///< WX好友
    CHSKPlatformTypeWXTimeline = 2,            ///< WX朋友圈
    CHSKPlatformTypeQQFriends  = 3,            ///< QQ好友
    CHSKPlatformTypeQZone      = 4,            ///< QQ空间
    CHSKPlatformTypeWX         = 100,          ///< WX平台
    CHSKPlatformTypeQQ         = 101,          ///< QQ平台
};

typedef NS_ENUM(NSInteger, CHSKResponseState) { ///< 回复状态
    CHSKResponseStateBegin   = 0,               ///< 开始
    CHSKResponseStateSuccess = 1,               ///< 成功
    CHSKResponseStateFailure = 2,               ///< 失败
    CHSKResponseStateCancel  = 3,               ///< 取消
    CHSKResponseStateFinish  = 4,               ///< 完成
};

typedef NS_ENUM(NSInteger, CHSKMessageType) { ///< 消息类型
    CHSKMessageTypeUndefined = 0,             ///< 未知
    CHSKMessageTypeText      = 1,             ///< 文本
    CHSKMessageTypeImage     = 2,             ///< 图片
    CHSKMessageTypeWebPage   = 3,             ///< 网页
    CHSKMessageTypeApp       = 4,             ///< 应用(暂不支持)
    CHSKMessageTypeAudio     = 5,             ///< 音频(暂不支持)
    CHSKMessageTypeVideo     = 6,             ///< 视频(暂不支持)
    CHSKMessageTypeFile      = 7,             ///< 文件(暂不支持)
};

typedef NS_ENUM(NSInteger, CHSKErrorCode) { ///< 错误类型
    CHSKErrorCodeUndefined             = -90000, ///< 未知
    CHSKErrorCodeInvalidMessage        = -90001, ///< 无效的消息
    CHSKErrorCodeUnsupportMessageType  = -90002, ///< 不支持的消息类型
    CHSKErrorCodeInvalidMessageTitle   = -90003, ///< 无效的消息标题
    CHSKErrorCodeInvalidMessageDesc    = -90004, ///< 无效的消息描述
    CHSKErrorCodeInvalidMessageImages  = -90005, ///< 无效的消息图片
    CHSKErrorCodeInvalidMessageURL     = -90006, ///< 无效的消息URL
    CHSKErrorCodeInvalidMessageFileExt = -90007, ///< 无效的消息文件后缀
    CHSKErrorCodeUninstallPlatform     = -90008, ///< 用户未安装相关平台
    CHSKErrorCodeNoResponse            = -90009, ///< 无返回消息
    CHSKErrorCodeSDKAPIError           = -90010, ///< SDK调用失败
    CHSKErrorCodeUnregisteredPlatform  = -90011, ///< 平台未注册
    CHSKErrorCodeNetworkError          = -90012, ///< 网络问题
    CHSKErrorCodeUnvalidAccessToken    = -90013, ///< 无效的AccessToken
    CHSKErrorCodePlatformLoginFailure  = -90014, ///< 平台登录失败
};

typedef NS_ENUM(NSInteger, CHSKUserGender) { ///< 用户性别
    CHSKUserGenderUndefined = -1, ///< 未知
    CHSKUserGenderMale      = 0,  ///< 男
    CHSKUserGenderFemale    = 1,  ///< 女
};

/**
 平台配置回调处理
 
 @param platformType 平台类型
 @return 平台配置
 */
typedef CHSKPlatformConfiguration *(^CHSKPlatformConfigurationHandler)(CHSKPlatformType platformType);

/**
 分享回调处理
 
 @param state     分享状态
 @param message   分享内容, 当且仅当state为CHSKResponseStateSuccess或CHSKResponseStateFailure时返回
 @param extraData 附加数据, 返回状态以外的一些数据描述
 @param error     错误信息, 当且仅当state为CHSKResponseStateFailure时返回
 */
typedef void(^CHSKShareHandler)(CHSKResponseState state, CHSKShareMessage *message, NSDictionary *extraData, NSError *error);

/**
 授权回调处理
 
 @param state     获取状态
 @param user      用户信息, 当且仅当state为CHSKResponseStateSuccess时返回
 @param extraData 附加数据, 返回状态以外的一些数据描述
 @param error     错误信息, 当且仅当state为CHSKResponseStateFailure时返回
 */
typedef void(^CHSKAuthorizeHandler) (CHSKResponseState state, CHSKUser *user, NSDictionary *extraData, NSError *error);

/**
 获取用户信息回调处理

 @param state     获取状态
 @param user      用户信息, 当且仅当state为CHSKResponseStateSuccess时返回
 @param extraData 附加数据, 返回状态以外的一些数据描述
 @param error     错误信息, 当且仅当state为CHSKResponseStateFailure时返回
 */
typedef void(^CHSKGetUserInfoHandler)(CHSKResponseState state, CHSKUser *user, NSDictionary *extraData, NSError *error);

#endif /* CHSKDefines_h */
