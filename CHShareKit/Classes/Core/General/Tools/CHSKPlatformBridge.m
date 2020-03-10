//
//  CHSKPlatformBridge.m
//  CHShareKit
//
//  Created by CHwang on 2019/9/17.
//

#import "CHSKPlatformBridge.h"

#import "NSError+CHShareKit.h"

#import "CHSKPrivateDefines.h"

@implementation CHSKPlatformBridge

#pragma mark - Base
- (void)dealloc {
    [self removeNotificationActions];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
        [self addNotificationActions];
    }
    return self;
}

+ (id)sharedBridgeWithType:(CHSKPlatformType)type {
    Class class = [self class];
    switch (type) {
        case CHSKPlatformTypeUndefined:
            break;
            
        case CHSKPlatformTypeWX:
        case CHSKPlatformTypeWXSession:
        case CHSKPlatformTypeWXTimeline:
        {
            class = NSClassFromString(@"CHSKWXBridge");
        }
            break;
            
        case CHSKPlatformTypeQQFriends:
        case CHSKPlatformTypeQZone:
        case CHSKPlatformTypeQQ:
        {
            class = NSClassFromString(@"CHSKQQBridge");
        }
            break;
    }
    
    id instance = [class performSelector:@selector(sharedBridge)];
    return instance;
}

+ (id)sharedBridge {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Notification actions
- (void)addNotificationActions {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeNotificationActions {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <CHSKShareBridgeProtocol>
- (void)registerPlatform:(CHSKPlatformConfiguration *)configuration {
    self.platformConfiguration = configuration;
}

- (BOOL)isClientInstalled {
    return NO;
}

- (BOOL)handleOpenURL:(NSURL *)URL {
    self.isRebackByOpenURL = YES;
    if (!URL.scheme.length) return NO;
    
    return YES;
}

- (void)willEnterForeground {
    if (self.isRebackByOpenURL) {
        self.isRebackByOpenURL = NO;
        return;
    }
    
    // 授权
    if (self.authorizeHandler) {
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateCancel, nil, nil, nil);
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
        self.authorizeHandler = nil;
        return;
    }
    
    // 分享
    if (self.shareMessage) {
        !self.shareHandler ?: self.shareHandler(CHSKResponseStateCancel, nil, nil, nil);
        !self.shareHandler ?: self.shareHandler(CHSKResponseStateFinish, nil, nil, nil);
        self.shareHandler =  nil;
        self.shareMessage = nil;
        return;
    }
}

- (void)authorizeTo:(CHSKPlatformType)platformType authorizeHandler:(CHSKAuthorizeHandler)authorizeHandler {
    NSMutableDictionary *extraData = @{}.mutableCopy;
    NSError *error = nil;
    if (platformType == CHSKPlatformTypeUndefined) {
        error = [NSError ch_sk_errorWithCode:CHSKErrorCodeUninstallPlatform];
        !authorizeHandler ?: authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !authorizeHandler ?: authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
        return;
    }
}

- (void)share:(CHSKShareMessage *)message
 platformType:(CHSKPlatformType)platformType
 shareHandler:(CHSKShareHandler)shareHandler {
    self.shareHandler = nil;
    self.shareMessage = nil;
    
    NSMutableDictionary *extraData = @{}.mutableCopy;
    NSError *error = nil;
    if (platformType == CHSKPlatformTypeUndefined) {
        error = [NSError ch_sk_errorWithCode:CHSKErrorCodeUninstallPlatform];
        !shareHandler ?: shareHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !shareHandler ?: shareHandler(CHSKResponseStateFinish, nil, nil, nil);
        return;
    }
}

- (NSInteger)isValidShareMessage:(CHSKShareMessage *)message platformType:(CHSKPlatformType)platformType {
    if (!message) return CHSKErrorCodeInvalidMessage;
    if (platformType == CHSKMessageTypeUndefined) return CHSKErrorCodeUnsupportMessageType;
    
    return CHSKErrorCodeUnsupportMessageType;
}

#pragma mark - Private methods
- (void)commonInit {
    self.isRebackByOpenURL = NO;
}

@end
