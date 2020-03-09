//
//  CHSKPlatformConfiguration.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "CHSKPlatformConfiguration.h"

@interface CHSKPlatformConfiguration ()

@property (nonatomic, assign, readwrite) CHSKPlatformType platformType;
@property (nonatomic, copy, readwrite) NSString *appId;
@property (nonatomic, copy, readwrite) NSString *appSecret;
@property (nonatomic, copy, readwrite) NSString *universalLink;

@property (nonatomic, copy, readwrite) NSString *appSchemeId;///< URLScheme Id
@property (nonatomic, copy, readwrite) NSString *appHexSchemeId; ///< URLScheme Id for QQ

@end

@implementation CHSKPlatformConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _platformType = CHSKPlatformTypeUndefined;
    }
    return self;
}


+ (instancetype)configurationForWXWithAppId:(NSString *)appId
                                  appSecret:(NSString *)appSecret
                              universalLink:(NSString *)universalLink {
    CHSKPlatformConfiguration *configuration = [CHSKPlatformConfiguration new];
    configuration.platformType = CHSKPlatformTypeWXSession;
    configuration.appId = appId;
    configuration.appSecret = appSecret;
    configuration.appSchemeId = appId;
    configuration.universalLink = universalLink;
    return configuration;
}

+ (instancetype)configurationForQQWithAppId:(NSString *)appId
                                  appSecret:(NSString *)appSecret {
    CHSKPlatformConfiguration *configuration = [CHSKPlatformConfiguration new];
    configuration.appId = appId;
    configuration.appSecret = appSecret;
    configuration.appSchemeId = [NSString stringWithFormat:@"tencent%d", appId.intValue];
    configuration.appHexSchemeId = [NSString stringWithFormat:@"QQ%08X", appId.intValue];
    return configuration;
}

@end
