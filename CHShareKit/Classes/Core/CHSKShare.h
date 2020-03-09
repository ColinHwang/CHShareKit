//
//  CHSKShare.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>
#import "CHSKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHSKShare : NSObject

#pragma mark - Base
/**
 处理被打开时的URL, 在application:openURL:sourceApplication:annotation:方法内调用, iOS 9.0以上在application:openURL:options:方法内调用
 
 @param URL URL
 @return 如果能处理, 返回YES, 否则返回NO
 */
+ (BOOL)handleOpenURL:(NSURL *)URL;

#pragma mark - Register
/**
 根据平台类型集, 初始化平台

 @param activePlatforms 平台类型集
 @param configurationHandler 配置回调
 */
+ (void)registerActivePlatforms:(NSArray<NSNumber *> *)activePlatforms
           configurationHandler:(CHSKPlatformConfigurationHandler)configurationHandler;

#pragma mark - Authorize
/**
 根据平台类型, 获取应用授权

 @param platformType 平台类型
 @param authorizeHandler 授权回调
 */
+ (void)authorizeTo:(CHSKPlatformType)platformType
   authorizeHandler:(CHSKAuthorizeHandler)authorizeHandler;

#pragma mark - Share
/**
 根据平台类型及分享消息, 分享内容

 @param platformType 平台类型
 @param message 分享消息
 @param shareHandler 分享回调
 */
+ (void)shareTo:(CHSKPlatformType)platformType
        message:(CHSKShareMessage *)message
   shareHandler:(CHSKShareHandler)shareHandler;

#pragma mark - Extension
/**
 检测是否已安装指定平台

 @param platformType 平台类型
 @return 安装返回YES, 否则返回NO
 */
+ (BOOL)isClientInstalled:(CHSKPlatformType)platformType;

@end

NS_ASSUME_NONNULL_END
