//
//  CHSKShareBridgeProtocol.h
//  CHShareKit
//
//  Created by CHwang on 2019/9/16.
//

#import <Foundation/Foundation.h>

@class CHSKPlatformConfiguration;

@protocol CHSKShareBridgeProtocol <NSObject>

@optional

- (void)registerPlatform:(CHSKPlatformConfiguration *)configuration;

- (BOOL)canHandleOpenURL:(NSURL *)URL;

- (BOOL)handleOpenURL:(NSURL *)URL;

- (BOOL)isClientInstalled;

- (void)willEnterForeground;

- (void)authorizeTo:(CHSKPlatformType)platformType authorizeHandler:(CHSKAuthorizeHandler)authorizeHandler;

- (void)share:(CHSKShareMessage *)message
 platformType:(CHSKPlatformType)platformType
 shareHandler:(CHSKShareHandler)shareHandler;

- (NSInteger)isValidShareMessage:(CHSKShareMessage *)message
                    platformType:(CHSKPlatformType)platformType;

@end
