//
//  CHSKShare.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "CHSKShare.h"
#import "CHSKShareBridge.h"

@implementation CHSKShare

#pragma mark - Base
+ (BOOL)handleOpenURL:(NSURL *)URL {
    return [[CHSKShareBridge sharedBridge] handleOpenURL:URL];
}

#pragma mark - Register
+ (void)registerActivePlatforms:(NSArray<NSNumber *> *)activePlatforms
           configurationHandler:(CHSKPlatformConfigurationHandler)configurationHandler {
    [[CHSKShareBridge sharedBridge] registerActivePlatforms:activePlatforms configurationHandler:configurationHandler];
}

#pragma mark - Authorize
+ (void)authorizeTo:(CHSKPlatformType)platformType
   authorizeHandler:(CHSKAuthorizeHandler)authorizeHandler {
    [[CHSKShareBridge sharedBridge] authorizeTo:platformType authorizeHandler:authorizeHandler];
}

#pragma mark - Share
+ (void)shareTo:(CHSKPlatformType)platformType
        message:(CHSKShareMessage *)message
   shareHandler:(CHSKShareHandler)shareHandler {
    [[CHSKShareBridge sharedBridge] shareMessage:message platformType:platformType shareHandler:shareHandler];
}

#pragma mark - Extension
+ (BOOL)isClientInstalled:(CHSKPlatformType)platformType {
    return [[CHSKShareBridge sharedBridge] isClientInstalled:platformType];
}

@end
