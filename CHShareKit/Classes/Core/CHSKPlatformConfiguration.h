//
//  CHSKPlatformConfiguration.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>
#import "CHSKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHSKPlatformConfiguration : NSObject

@property (nonatomic, assign, readonly) CHSKPlatformType platformType;
@property (nonatomic, copy, readonly) NSString *appId;
@property (nonatomic, copy, readonly) NSString *appSecret;
@property (nonatomic, copy, readonly) NSString *universalLink;

@property (nonatomic, copy, readonly) NSString *appSchemeId;///< URLScheme Id
@property (nonatomic, copy, readonly) NSString *appHexSchemeId; ///< URLScheme Id for QQ

/**
 创建WX配置信息

 @param appId appId
 @param appSecret appSecret
 @param universalLink universalLink
 @return WX配置信息
 */
+ (instancetype)configurationForWXWithAppId:(NSString *)appId
                                  appSecret:(NSString *)appSecret
                              universalLink:(NSString *)universalLink;

/**
 创建QQ配置信息

 @param appId appId
 @param appSecret appSecret
 @return QQ配置信息
 */
+ (instancetype)configurationForQQWithAppId:(NSString *)appId
                                  appSecret:(NSString *)appSecret;

@end

NS_ASSUME_NONNULL_END
