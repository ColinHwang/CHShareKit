//
//  CHSKQQBridge.m
//  CHShareKit
//
//  Created by CHwang on 2019/9/18.
//

#import "CHSKQQBridge.h"

#import "CHSKCredential.h"
#import "CHSKPlatformConfiguration.h"
#import "CHSKUser.h"

#import <CHCategories/CHCategories.h>
#import "CHSKMessageConvertHelper.h"
#import "CHSKPrivateDefines.h"
#import "CHSKCheckHelper.h"
#import "NSError+CHShareKit.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <YYModel/YYModel.h>

@interface CHSKQQBridge () <QQApiInterfaceDelegate, TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation CHSKQQBridge

#pragma mark - Base
- (void)dealloc {
    if (_tencentOAuth) {
        [_tencentOAuth logout:self];
    }
}

+ (id)sharedBridge {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - <QQApiInterfaceDelegate>
- (void)onReq:(QQBaseReq *)req {
}

- (void)onResp:(QQBaseResp *)resp {
    NSMutableDictionary *extraData = @{}.mutableCopy;
    NSError *error = nil;
    if (!resp) {
        error = [NSError ch_sk_errorWithCode:CHSKErrorCodeNoResponse];
        // 授权
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
        self.authorizeHandler =  nil;
        
        // 分享
        !self.shareHandler ?: self.shareHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !self.shareHandler ?: self.shareHandler(CHSKResponseStateFinish, nil, nil, nil);
        self.shareHandler =  nil;
        self.shareMessage = nil;
        return;
    }
    
    // QQ分享消息
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        NSInteger errCode = [(SendMessageToQQResp *)resp result].intValue;
        NSString *errMsg = [(SendMessageToQQResp *)resp errorDescription];
        if (errCode == 0) {
            // self.shareMessage ? retain ?
            !self.shareHandler ?: self.shareHandler(CHSKResponseStateSuccess, self.shareMessage, extraData.copy, nil);
            !self.shareHandler ?: self.shareHandler(CHSKResponseStateFinish, nil, nil, nil);
            self.shareHandler =  nil;
            self.shareMessage = nil;
            return;
        }
        
        // 取消
        if (errCode == -4) {
            !self.shareHandler ?: self.shareHandler(CHSKResponseStateCancel, nil, extraData.copy, nil);
            !self.shareHandler ?: self.shareHandler(CHSKResponseStateFinish, nil, nil, nil);
            self.shareHandler =  nil;
            self.shareMessage = nil;
            return;
        }
        
        error = [NSError ch_sk_errorWithCode:errCode message:errMsg];
        !self.shareHandler ?: self.shareHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !self.shareHandler ?: self.shareHandler(CHSKResponseStateFinish, nil, nil, nil);
        self.shareHandler =  nil;
        self.shareMessage = nil;
        return;
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
}

#pragma mark - <TencentSessionDelegate>
- (void)tencentDidLogin {
    NSMutableDictionary *extraData = @{}.mutableCopy;
    if (!self.tencentOAuth.accessToken.length) {
        NSError *error = [NSError ch_sk_errorWithCode:CHSKErrorCodeUnvalidAccessToken];
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
        self.authorizeHandler =  nil;
        return;
    }
    
    [self.tencentOAuth getUserInfo];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSMutableDictionary *extraData = @{}.mutableCopy;
    if (cancelled) {
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateCancel, nil, extraData.copy, nil);
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
        self.authorizeHandler =  nil;
        return;
    }
    
    NSError *error = [NSError ch_sk_errorWithCode:CHSKErrorCodeSDKAPIError];
    !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
    !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
    self.authorizeHandler =  nil;
}

- (void)tencentDidNotNetWork {
    NSMutableDictionary *extraData = @{}.mutableCopy;
    NSError *error = [NSError ch_sk_errorWithCode:CHSKErrorCodeNetworkError];
    !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
    !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
    self.authorizeHandler =  nil;
}

- (void)getUserInfoResponse:(APIResponse *)response {
    NSMutableDictionary *extraData = @{}.mutableCopy;
    if (response && response.retCode == 0) {
        CHSKCredential *credential = [CHSKCredential new];
        credential.uid = [self.tencentOAuth.unionid copy];
        credential.token = [self.tencentOAuth.accessToken copy];
        credential.expired = [self.tencentOAuth.expirationDate copy];
        
        NSMutableDictionary *credentialData = [[credential yy_modelToJSONObject] mutableCopy];
        [credentialData setObject:CH_STRING_AVOID_NIL(self.tencentOAuth.openId) forKey:@"openid"];
        [credentialData setObject:CH_STRING_AVOID_NIL(self.tencentOAuth.accessToken) forKey:@"accesstoken"];
        [credentialData setObject:CH_STRING_AVOID_NIL(self.tencentOAuth.unionid) forKey:@"unionid"];
        [credentialData addEntriesFromDictionary:self.tencentOAuth.passData];
        credential.rawData = credentialData.copy;
        
        CHSKUser *user = [CHSKUser new];
        user.credential = credential;
        user.rawData = response.jsonResponse;
        
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateSuccess, user, extraData.copy, nil);
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
        self.authorizeHandler =  nil;
        return;
    }
    
    NSError *error = [NSError ch_sk_errorWithCode:response.retCode message:response.errorMsg];
    !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
    !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
    self.authorizeHandler =  nil;
    return;
}


#pragma mark - <CHSKShareBridgeProtocol>
- (void)registerPlatform:(CHSKPlatformConfiguration *)configuration {
    [super registerPlatform:configuration];
    
    if (self.tencentOAuth) {
        [self.tencentOAuth logout:self];
    }
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:configuration.appId andDelegate:self];
    self.tencentOAuth.authMode = kAuthModeClientSideToken;
}

- (BOOL)isClientInstalled {
    BOOL flag = [super isClientInstalled];
    
    flag = [QQApiInterface isQQInstalled];
    if (flag) return flag;
    
    flag = [QQApiInterface isTIMInstalled];
    if (flag) return flag;
    
    flag = NO;
    return flag;
}

- (BOOL)canHandleOpenURL:(NSURL *)URL {
    BOOL flag = [super canHandleOpenURL:URL];
    if (!flag) return NO;
    if ([URL.scheme isEqualToString:self.platformConfiguration.appHexSchemeId]) return YES; // qq分享
    if ([URL.scheme isEqualToString:self.platformConfiguration.appSchemeId]) return YES; // qq授权
    
    return NO;
}

- (BOOL)handleOpenURL:(NSURL *)URL {
    BOOL flag = [super handleOpenURL:URL];
    if (!flag) return flag;
    
    // qq分享
    if([URL.scheme isEqualToString:self.platformConfiguration.appHexSchemeId]) {
        flag = [QQApiInterface handleOpenURL:URL delegate:self];
        return flag;
    }
    
    // qq授权
    if ([URL.scheme isEqualToString:self.platformConfiguration.appSchemeId]) {
        flag = [TencentOAuth HandleOpenURL:URL];
        return flag;
    }
    return flag;
}

- (void)authorizeTo:(CHSKPlatformType)platformType authorizeHandler:(CHSKAuthorizeHandler)authorizeHandler {
    [super authorizeTo:platformType authorizeHandler:authorizeHandler];
    
    NSMutableDictionary *extraData = @{}.mutableCopy;
    NSError *error = nil;
    
    NSArray *pemissions = @[
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO
                            ];
    BOOL sendState = [self.tencentOAuth authorize:pemissions inSafari:NO];
    if (!sendState) {
        error = [NSError ch_sk_errorWithCode:CHSKErrorCodeSDKAPIError];
        !authorizeHandler ?: authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !authorizeHandler ?: authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
        return;
    }
    
    self.authorizeHandler = authorizeHandler;
}

- (void)share:(CHSKShareMessage *)message platformType:(CHSKPlatformType)platformType shareHandler:(CHSKShareHandler)shareHandler {
    [super share:message platformType:platformType shareHandler:shareHandler];
    
    NSMutableDictionary *extraData = @{}.mutableCopy;
    
    @weakify(self);
    void(^convertHandler)(CHSKPlatformType platformType, QQBaseReq *toMessage, NSError *error, CHSKShareHandler shareHandler) = ^(CHSKPlatformType platformType, QQBaseReq *toMessage, NSError *error, CHSKShareHandler shareHandler) {
        @strongify(self);
        if (error) {
            !shareHandler ?: shareHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
            !shareHandler ?: shareHandler(CHSKResponseStateFinish, nil, nil, nil);
            return;
        }
        
        QQApiSendResultCode sendResult = EQQAPISENDFAILD;
        switch (platformType) {
            case CHSKPlatformTypeQQ:
            case CHSKPlatformTypeQQFriends:
            {
                sendResult = [QQApiInterface sendReq:toMessage];
            }
                break;
            case CHSKPlatformTypeQZone:
            {
                sendResult = [QQApiInterface SendReqToQZone:toMessage];
            }
                break;
                
            default:
                break;
        }
        if (sendResult != EQQAPISENDSUCESS) {
            error = [NSError ch_sk_errorWithCode:CHSKErrorCodeSDKAPIError message:[NSString stringWithFormat:@"QQ调用失败:%ld", (long)sendResult]];
            !shareHandler ?: shareHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
            !shareHandler ?: shareHandler(CHSKResponseStateFinish, nil, nil, nil);
            return;
        }
        
        self.shareHandler = shareHandler;
        self.shareMessage = message;
    };
    
    switch (platformType) {
        case CHSKPlatformTypeQQ:
        case CHSKPlatformTypeQQFriends:
        case CHSKPlatformTypeQZone:
        {
            [self convertShareMessageToQQReq:message completionHandler:^(QQBaseReq *toMessage, NSError *error) {
                !convertHandler ?: convertHandler(platformType, toMessage, error, shareHandler);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)isValidShareMessage:(CHSKShareMessage *)message platformType:(CHSKPlatformType)platformType {
    NSInteger code = [super isValidShareMessage:message platformType:platformType];
    
    switch (platformType) {
        case CHSKPlatformTypeQQ:
        case CHSKPlatformTypeQQFriends:
        {
            code = [self isValidShareMessageForQQFriends:message];
        }
            break;
        case CHSKPlatformTypeQZone:
        {
            code = [self isValidShareMessageForQZone:message];
        }
            break;
            
        default:
            break;
    }
    return code;
}

#pragma mark - Private methods
- (NSInteger)isValidShareMessageForQQFriends:(CHSKShareMessage *)shareMessage {
    if (!shareMessage) return CHSKErrorCodeInvalidMessage;
    
    switch (shareMessage.type) {
        case CHSKMessageTypeUndefined:
        case CHSKMessageTypeApp:
        case CHSKMessageTypeFile:
            return CHSKErrorCodeUnsupportMessageType;
            break;
        case CHSKMessageTypeText:
        {
            if (![CHSKCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
        }
            break;
        case CHSKMessageTypeImage:
        {
            if (![CHSKCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
            if (![CHSKCheckHelper isValidDesc:shareMessage.desc]) return CHSKErrorCodeInvalidMessageDesc;
            if (![CHSKCheckHelper isValidImages:shareMessage.images]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeWebPage:
        {
            if (![CHSKCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
            if (![CHSKCheckHelper isValidDesc:shareMessage.desc]) return CHSKErrorCodeInvalidMessageDesc;
            if (![CHSKCheckHelper isValidURL:shareMessage.url]) return CHSKErrorCodeInvalidMessageURL;
            if (![CHSKCheckHelper isValidImages:shareMessage.images] && ![CHSKCheckHelper isValidImage:shareMessage.thumbnail]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeAudio:
        case CHSKMessageTypeVideo:
        {
            if (![CHSKCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
            if (![CHSKCheckHelper isValidDesc:shareMessage.desc]) return CHSKErrorCodeInvalidMessageDesc;
            if (![CHSKCheckHelper isValidURL:shareMessage.url]) return CHSKErrorCodeInvalidMessageURL;
            if (![CHSKCheckHelper isValidImages:shareMessage.images] && ![CHSKCheckHelper isValidImage:shareMessage.thumbnail]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
    }
    return CHSKShareMessageValidCode;
}

- (NSInteger)isValidShareMessageForQZone:(CHSKShareMessage *)shareMessage {
    if (!shareMessage) return CHSKErrorCodeInvalidMessage;
    
    switch (shareMessage.type) {
        case CHSKMessageTypeUndefined:
        case CHSKMessageTypeText:
        case CHSKMessageTypeApp:
        case CHSKMessageTypeFile:
            return CHSKErrorCodeUnsupportMessageType;
            break;
        case CHSKMessageTypeImage:
        {
            if (![CHSKCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
            if (![CHSKCheckHelper isValidDesc:shareMessage.desc]) return CHSKErrorCodeInvalidMessageDesc;
            if (![CHSKCheckHelper isValidImages:shareMessage.images]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeWebPage:
        {
            if (![CHSKCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
            if (![CHSKCheckHelper isValidDesc:shareMessage.desc]) return CHSKErrorCodeInvalidMessageDesc;
            if (![CHSKCheckHelper isValidURL:shareMessage.url]) return CHSKErrorCodeInvalidMessageURL;
            if (![CHSKCheckHelper isValidImages:shareMessage.images] && ![CHSKCheckHelper isValidImage:shareMessage.thumbnail]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeAudio:
        case CHSKMessageTypeVideo:
        {
            if (![CHSKCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
            if (![CHSKCheckHelper isValidDesc:shareMessage.desc]) return CHSKErrorCodeInvalidMessageDesc;
            if (![CHSKCheckHelper isValidURL:shareMessage.url]) return CHSKErrorCodeInvalidMessageURL;
            if (![CHSKCheckHelper isValidImages:shareMessage.images] && ![CHSKCheckHelper isValidImage:shareMessage.thumbnail]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
    }
    return CHSKShareMessageValidCode;
}

- (void)convertShareMessageToQQReq:(CHSKShareMessage *)shareMessage
                 completionHandler:(CHSKMessageConvertCompletionHandler)completionHandler {
    __block NSError *aError = nil;
    if (!shareMessage) {
        aError = [NSError ch_sk_errorWithCode:CHSKErrorCodeInvalidMessage];
        !completionHandler ?: completionHandler(nil, aError);
        return;
    }
    
    if (shareMessage.type == CHSKMessageTypeUndefined) {
        aError = [NSError ch_sk_errorWithCode:CHSKErrorCodeUndefined];
        !completionHandler ?: completionHandler(nil, aError);
        return;
    }
    // 文本
    if (shareMessage.type == CHSKMessageTypeText) {
        QQApiTextObject *textObject = [[QQApiTextObject alloc] initWithText:shareMessage.title];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:textObject];
        !completionHandler ?: completionHandler(req, nil);
        return;
    }
    // 图片
    id image = [shareMessage.images firstObject];
    if (shareMessage.type == CHSKMessageTypeImage) {
        [CHSKMessageConvertHelper configureShareImageDataWithImage:image maxFileSize:CHSKQQShareImageMaxFileSize thumbnailImage:shareMessage.thumbnail maxThumbnailFileSize:CHSKWXShareThumbnailImageMaxFileSize completionHandler:^(NSData *imageData, NSData *thumbnailImageData, NSError *error) {
            aError = error;
            if (aError) {
                !completionHandler ?: completionHandler(nil, aError);
                return;
            }
            
            QQApiImageObject *imageObject = [[QQApiImageObject alloc] initWithData:imageData ?: thumbnailImageData
                                                                  previewImageData:thumbnailImageData
                                                                             title:shareMessage.title
                                                                       description:shareMessage.desc];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imageObject];
            !completionHandler ?: completionHandler(req, nil);
        }];
        return;
    }
    // 网页
    if (shareMessage.type == CHSKMessageTypeWebPage) {
        [CHSKMessageConvertHelper configureShareImageDataWithImage:image maxFileSize:CHSKQQShareThumbnailImageMaxFileSize thumbnailImage:image maxThumbnailFileSize:CHSKQQShareThumbnailImageMaxFileSize completionHandler:^(NSData *imageData, NSData *thumbnailImageData, NSError *error) {
            aError = error;
            if (aError) {
                !completionHandler ?: completionHandler(nil, aError);
                return;
            }
            
            QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:shareMessage.url
                                                                title:shareMessage.title
                                                          description:shareMessage.desc
                                                     previewImageData:thumbnailImageData?:imageData];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            !completionHandler ?: completionHandler(req, nil);
        }];
        return;
    }
}

@end
