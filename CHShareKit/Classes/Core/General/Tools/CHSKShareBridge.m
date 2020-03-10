//
//  CHSKShareBridge.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "CHSKShareBridge.h"

#import "CHSKPlatformConfiguration.h"
#import "CHSKUser.h"

#import <CHCategories/CHCategories.h>
#import "CHSKMessageConvertHelper.h"
#import "CHSKPrivateDefines.h"
#import "NSError+CHShareKit.h"
#import <YYModel/YYModel.h>
#import "CHSKPlatformBridge.h"

#import "CHSKDefines.h"

@interface CHSKShareBridge ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, CHSKPlatformConfiguration *> *platformConfigurations;

@end

@implementation CHSKShareBridge

#pragma mark - Life cycle
- (void)dealloc {
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Event

#pragma mark - Public methods
#pragma mark - Private methods
- (void)commonInit {
}

#pragma mark - Base
+ (CHSKShareBridge *)sharedBridge {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)handleOpenURL:(NSURL *)URL {
    if (!URL.scheme.length) return NO;
    
    BOOL flag = NO;
    CHSKPlatformBridge *bridge = nil;
    // wx
    bridge = [CHSKPlatformBridge sharedBridgeWithType:CHSKPlatformTypeWX];
    if ([bridge canHandleOpenURL:URL]) {
        flag = [bridge handleOpenURL:URL];
        return  flag;
    }
    
    // QQ
    bridge = [CHSKPlatformBridge sharedBridgeWithType:CHSKPlatformTypeQQ];
    if ([bridge canHandleOpenURL:URL]) {
        flag = [bridge handleOpenURL:URL];
        return  flag;
    }
    return flag;
}

#pragma mark - Register
- (void)registerActivePlatforms:(NSArray<NSNumber *> *)activePlatforms
           configurationHandler:(CHSKPlatformConfigurationHandler)configurationHandler {
    if (!activePlatforms.count) return;
    
    for (NSNumber *platformValue in activePlatforms) {
        if (configurationHandler) {
            NSInteger platformType = platformValue.integerValue;
            CHSKPlatformType targetPlatformType = [self getTargetPlatformType:platformType];;
            CHSKPlatformConfiguration *configuration = configurationHandler(platformType);
            [self updatePlatformConfiguration:configuration forPlatformType:targetPlatformType];
        }
    }
    
    [self registerPlatforms];
}

- (void)updatePlatformConfiguration:(CHSKPlatformConfiguration *)configuration forPlatformType:(CHSKPlatformType)platformType {
    if ([self.platformConfigurations ch_containsKey:@(platformType)]) {
        if (!configuration) {
            [self.platformConfigurations removeObjectForKey:@(platformType)];
        }
    }
    
    if (configuration) {
        [self.platformConfigurations setObject:configuration forKey:@(platformType)];
    }
}

- (void)registerPlatforms {
    [self.platformConfigurations enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, CHSKPlatformConfiguration * _Nonnull obj, BOOL * _Nonnull stop) {
        CHSKPlatformType platformType = key.integerValue;
        [[CHSKPlatformBridge sharedBridgeWithType:platformType] registerPlatform:obj];
    }];
}

- (CHSKPlatformType)getTargetPlatformType:(CHSKPlatformType)platformType {
    switch (platformType) {
        case CHSKPlatformTypeUndefined:
            return CHSKPlatformTypeUndefined;
            
        case CHSKPlatformTypeWX:
        case CHSKPlatformTypeWXTimeline:
        case CHSKPlatformTypeWXSession:
            return CHSKPlatformTypeWX;
            
        case CHSKPlatformTypeQQ:
        case CHSKPlatformTypeQQFriends:
        case CHSKPlatformTypeQZone:
            return CHSKPlatformTypeQQ;
    }
}

- (CHSKPlatformConfiguration *)getPlatformConfigurationForPlatformType:(CHSKPlatformType)platformType {
    NSNumber *key = @([self getTargetPlatformType:platformType]);
    if (!key) return nil;
    
    return [self.platformConfigurations objectForKey:key];
}

- (BOOL)isContainsPlatformConfigurationForPlatformType:(CHSKPlatformType)platformType {
    return [self getPlatformConfigurationForPlatformType:platformType] != nil;
}

#pragma mark - Authorize
- (void)authorizeTo:(CHSKPlatformType)platformType
   authorizeHandler:(CHSKAuthorizeHandler)authorizeHandler {
    NSMutableDictionary *extraData = @{}.mutableCopy;
    NSError *error = nil;
    
    // Begin
    !authorizeHandler ?: authorizeHandler(CHSKResponseStateBegin, nil, extraData.copy, nil);
    
    // 未安装
    if (![self isClientInstalled:platformType]) {
        error = [NSError ch_sk_errorWithCode:CHSKErrorCodeUninstallPlatform];
        !authorizeHandler ?: authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !authorizeHandler ?: authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
        return;
    }
    
    // 未注册
    if (![self isContainsPlatformConfigurationForPlatformType:platformType]) {
        error = [NSError ch_sk_errorWithCode:CHSKErrorCodeUnregisteredPlatform];
        !authorizeHandler ?: authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !authorizeHandler ?: authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
        return;
    }
    
    [[CHSKPlatformBridge sharedBridgeWithType:platformType] authorizeTo:platformType authorizeHandler:authorizeHandler];
}

#pragma mark - Share
- (void)shareMessage:(CHSKShareMessage *)message
        platformType:(CHSKPlatformType)platformType
        shareHandler:(CHSKShareHandler)shareHandler {
    NSMutableDictionary *extraData = @{}.mutableCopy;
    NSError *error = nil;
    
    // Begin
    !shareHandler ?: shareHandler(CHSKResponseStateBegin, nil, extraData.copy, nil);
    
    // 未安装
    if (![self isClientInstalled:platformType]) {
        error = [NSError ch_sk_errorWithCode:CHSKErrorCodeUninstallPlatform];
        !shareHandler ?: shareHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !shareHandler ?: shareHandler(CHSKResponseStateFinish, nil, nil, nil);
        return;
    }
    
    // 未注册
    if (![self isContainsPlatformConfigurationForPlatformType:platformType]) {
        error = [NSError ch_sk_errorWithCode:CHSKErrorCodeUnregisteredPlatform];
        !shareHandler ?: shareHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !shareHandler ?: shareHandler(CHSKResponseStateFinish, nil, nil, nil);
        return;
    }
    
    CHSKPlatformBridge *bridge = [CHSKPlatformBridge sharedBridgeWithType:platformType];
    // 检测分享参数
    NSInteger messageCode = [bridge isValidShareMessage:message platformType:platformType];
    if (messageCode != CHSKShareMessageValidCode) {
        error = [NSError ch_sk_errorWithCode:messageCode];
        !shareHandler ?: shareHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !shareHandler ?: shareHandler(CHSKResponseStateFinish, nil, nil, nil);
        return;
    }

    [bridge share:message platformType:platformType shareHandler:shareHandler];
}

#pragma mark - Extension
- (BOOL)isClientInstalled:(CHSKPlatformType)platformType {
    return [[CHSKPlatformBridge sharedBridgeWithType:platformType] isClientInstalled];
}

#pragma mark - setters/getters
- (NSMutableDictionary<NSNumber *,CHSKPlatformConfiguration *> *)platformConfigurations {
    if (!_platformConfigurations) {
        _platformConfigurations = @{}.mutableCopy;
    }
    return _platformConfigurations;
}

@end
