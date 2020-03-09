//
//  CHSKShareBridge.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>
#import "CHSKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHSKShareBridge : NSObject

#pragma mark - Base
+ (CHSKShareBridge *)sharedBridge;

- (BOOL)handleOpenURL:(NSURL *)URL;

#pragma mark - Register
- (void)registerActivePlatforms:(NSArray<NSNumber *> *)activePlatforms
           configurationHandler:(CHSKPlatformConfigurationHandler)configurationHandler;

#pragma mark - Authorize
- (void)authorizeTo:(CHSKPlatformType)platformType
   authorizeHandler:(CHSKAuthorizeHandler)authorizeHandler;

#pragma mark - Share
- (void)shareMessage:(CHSKShareMessage *)message
        platformType:(CHSKPlatformType)platformType
        shareHandler:(CHSKShareHandler)shareHandler;

#pragma mark - Extension
- (BOOL)isClientInstalled:(CHSKPlatformType)platformType;

@end

NS_ASSUME_NONNULL_END
