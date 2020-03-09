//
//  CHSKPlatformBridge.h
//  CHShareKit
//
//  Created by CHwang on 2019/9/17.
//

#import <Foundation/Foundation.h>
#import "CHSKShareMessage.h"
#import "CHSKShareBridgeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHSKPlatformBridge : NSObject <CHSKShareBridgeProtocol>

+ (id)sharedBridge;

+ (id)sharedBridgeWithType:(CHSKPlatformType)type;

- (void)commonInit;

@property (nonatomic, strong) CHSKPlatformConfiguration *platformConfiguration;
@property (nonatomic, strong, nullable) CHSKShareMessage *shareMessage;

@property (nonatomic, copy, nullable) __block CHSKShareHandler shareHandler;
@property (nonatomic, copy, nullable) __block CHSKAuthorizeHandler authorizeHandler;
@property (nonatomic, assign) BOOL isRebackByOpenURL;

@end

NS_ASSUME_NONNULL_END
