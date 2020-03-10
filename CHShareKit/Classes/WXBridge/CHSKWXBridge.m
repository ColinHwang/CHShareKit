//
//  CHSKWXBridge.m
//  CHShareKit
//
//  Created by CHwang on 2019/9/16.
//

#import "CHSKWXBridge.h"

#import "CHSKPlatformConfiguration.h"
#import "CHSKWXCredential.h"

#import <CHCategories/CHCategories.h>
#import "CHSKWXCheckHelper.h"
#import "CHSKPrivateDefines.h"
#import "CHSKMessageConvertHelper.h"
#import "CHSKNetworking+CHSKWX.h"
#import "CHSKUser.h"
#import "NSError+CHShareKit.h"
#import "WXApi.h"
#import <YYModel/YYModel.h>

@interface CHSKWXBridge () <WXApiDelegate>

@end

@implementation CHSKWXBridge

#pragma mark - Base
+ (id)sharedBridge {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - <WXApiDelegate>
- (void)onReq:(BaseReq *)req {
}

- (void)onResp:(BaseResp *)resp {
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
    
    // WX授权消息
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == WXSuccess) {
            @weakify(self);
            [self loadWXAuthorizeInfo:(SendAuthResp *)resp completionHandler:^(id authorizeInfo, NSError *error) {
                @strongify(self);
                if (error) {
                    !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
                    !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
                    self.authorizeHandler =  nil;
                    return;
                }

                !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateSuccess, authorizeInfo, extraData.copy, nil);
                !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
                self.authorizeHandler =  nil;
            }];
            return;
        }

        if (resp.errCode == WXErrCodeUserCancel) {
            !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateCancel, nil, extraData.copy, nil);
            !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
            self.authorizeHandler =  nil;
            return;
        }

        error = [NSError ch_sk_errorWithCode:resp.errCode message:resp.errStr];
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !self.authorizeHandler ?: self.authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
        self.authorizeHandler =  nil;
        return;
    }
    
    // WX分享消息
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == WXSuccess) {
            // self.shareMessage ? retain ?
            !self.shareHandler ?: self.shareHandler(CHSKResponseStateSuccess, self.shareMessage, extraData.copy, nil);
            !self.shareHandler ?: self.shareHandler(CHSKResponseStateFinish, nil, nil, nil);
            self.shareHandler =  nil;
            self.shareMessage = nil;
            return;
        }
        
        if (resp.errCode == WXErrCodeUserCancel) {
            !self.shareHandler ?: self.shareHandler(CHSKResponseStateCancel, nil, extraData.copy, nil);
            !self.shareHandler ?: self.shareHandler(CHSKResponseStateFinish, nil, nil, nil);
            self.shareHandler =  nil;
            self.shareMessage = nil;
            return;
        }
        
        error = [NSError ch_sk_errorWithCode:resp.errCode message:resp.errStr];
        !self.shareHandler ?: self.shareHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
        !self.shareHandler ?: self.shareHandler(CHSKResponseStateFinish, nil, nil, nil);
        self.shareHandler =  nil;
        self.shareMessage = nil;
        return;
    }
}

#pragma mark - <CHSKShareBridgeProtocol>
- (void)registerPlatform:(CHSKPlatformConfiguration *)configuration {
    [super registerPlatform:configuration];
    
    [WXApi registerApp:configuration.appId universalLink:configuration.universalLink];
}

- (BOOL)isClientInstalled {
    BOOL flag = [super isClientInstalled];
    
    flag = [WXApi isWXAppInstalled];
    return flag;
}

- (BOOL)canHandleOpenURL:(NSURL *)URL {
    BOOL flag = [super canHandleOpenURL:URL];
    if (!flag) return NO;
    if ([URL.scheme isEqualToString:self.platformConfiguration.appSchemeId]) return YES;
    
    return NO;
}

- (BOOL)handleOpenURL:(NSURL *)URL {
    BOOL flag = [super handleOpenURL:URL];
    if (!flag) return flag;
        
    flag = [WXApi handleOpenURL:URL delegate:self];
    return flag;
}

- (void)authorizeTo:(CHSKPlatformType)platformType authorizeHandler:(CHSKAuthorizeHandler)authorizeHandler {
    [super authorizeTo:platformType authorizeHandler:authorizeHandler];
    
    NSMutableDictionary *extraData = @{}.mutableCopy;
    __block NSError *error = nil;
    
    SendAuthReq *authReq = [SendAuthReq new];
    authReq.scope = @"snsapi_userinfo";
    authReq.state = @"";
    authReq.openID = self.platformConfiguration.appId;
    
    @weakify(self);
    [WXApi sendReq:authReq completion:^(BOOL success) {
        @strongify(self);
        if (!success) {
            error = [NSError ch_sk_errorWithCode:CHSKErrorCodeSDKAPIError];
            !authorizeHandler ?: authorizeHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
            !authorizeHandler ?: authorizeHandler(CHSKResponseStateFinish, nil, nil, nil);
            return;
        }
        
        self.authorizeHandler = authorizeHandler;
    }];
}

- (void)share:(CHSKShareMessage *)message platformType:(CHSKPlatformType)platformType shareHandler:(CHSKShareHandler)shareHandler {
    [super share:message platformType:platformType shareHandler:shareHandler];
    
    NSMutableDictionary *extraData = @{}.mutableCopy;
    
    @weakify(self);
    [self convertShareMessageToWXReq:message wxPlatform:platformType completionHandler:^(BaseReq *toMessage, NSError *error) {
        @strongify(self);
        if (error) {
            !shareHandler ?: shareHandler(CHSKResponseStateFailure, nil, extraData.copy, error);
            !shareHandler ?: shareHandler(CHSKResponseStateFinish, nil, nil, nil);
            return;
        }
        
        [WXApi sendReq:toMessage completion:^(BOOL success) {
            if (!success) {
                NSError *aError = [NSError ch_sk_errorWithCode:CHSKErrorCodeSDKAPIError];
                !shareHandler ?: shareHandler(CHSKResponseStateFailure, nil, extraData.copy, aError);
                !shareHandler ?: shareHandler(CHSKResponseStateFinish, nil, nil, nil);
                return;
            }
            
            self.shareHandler = shareHandler;
            self.shareMessage = message;
        }];
    }];
}

- (NSInteger)isValidShareMessage:(CHSKShareMessage *)message platformType:(CHSKPlatformType)platformType {
    NSInteger code = [super isValidShareMessage:message platformType:platformType];
    
    switch (platformType) {
        case CHSKPlatformTypeWX:
        case CHSKPlatformTypeWXSession:
        case CHSKPlatformTypeWXTimeline:
        {
            code = [self isValidShareMessageForWX:message];
        }
            break;

        default:
            break;
    }
    return code;
}

#pragma mark - Private methods
- (NSInteger)isValidShareMessageForWX:(CHSKShareMessage *)shareMessage {
    if (!shareMessage) return CHSKErrorCodeInvalidMessage;
    
    switch (shareMessage.type) {
        case CHSKMessageTypeUndefined:
            return CHSKErrorCodeUnsupportMessageType;
            break;
        case CHSKMessageTypeText:
        {
            if (![CHSKWXCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
        }
            break;
        case CHSKMessageTypeImage:
        {
            if (![CHSKWXCheckHelper isValidImages:shareMessage.images]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeWebPage:
        {
            if (![CHSKWXCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
            if (![CHSKWXCheckHelper isValidDesc:shareMessage.desc]) return CHSKErrorCodeInvalidMessageDesc;
            if (![CHSKWXCheckHelper isValidURL:shareMessage.url]) return CHSKErrorCodeInvalidMessageURL;
            if (![CHSKWXCheckHelper isValidImages:shareMessage.images] && ![CHSKWXCheckHelper isValidImage:shareMessage.thumbnail]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeVideo:
        case CHSKMessageTypeApp:
        {
            if (![CHSKWXCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
            if (![CHSKWXCheckHelper isValidDesc:shareMessage.desc]) return CHSKErrorCodeInvalidMessageDesc;
            if (![CHSKWXCheckHelper isValidURL:shareMessage.url]) return CHSKErrorCodeInvalidMessageURL;
            if (![CHSKWXCheckHelper isValidImages:shareMessage.images] && ![CHSKWXCheckHelper isValidImage:shareMessage.thumbnail]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeAudio:
        {
            if (![CHSKWXCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
            if (![CHSKWXCheckHelper isValidDesc:shareMessage.desc]) return CHSKErrorCodeInvalidMessageDesc;
            if (![CHSKWXCheckHelper isValidURL:shareMessage.url]) return CHSKErrorCodeInvalidMessageURL;
            if (![CHSKWXCheckHelper isValidURL:shareMessage.mediaDataUrl]) return CHSKErrorCodeInvalidMessageURL;
            if (![CHSKWXCheckHelper isValidImages:shareMessage.images] && ![CHSKWXCheckHelper isValidImage:shareMessage.thumbnail]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeFile:
        {
            if (![CHSKWXCheckHelper isValidTitle:shareMessage.title]) return CHSKErrorCodeInvalidMessageTitle;
            if (![CHSKWXCheckHelper isValidDesc:shareMessage.desc]) return CHSKErrorCodeInvalidMessageDesc;
            if (!shareMessage.fileExt) return CHSKErrorCodeInvalidMessageFileExt;
            if (![CHSKWXCheckHelper isValidImages:shareMessage.images] && ![CHSKWXCheckHelper isValidImage:shareMessage.thumbnail]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
    }
    return CHSKShareMessageValidCode;
}

- (void)loadWXAuthorizeInfo:(SendAuthResp *)authResp completionHandler:(CHSKLoadAuthorizeInfoCompletionHandler)completionHandler {
    [CHSKNetworking getWXAccessTokenWithCode:authResp.code appId:self.platformConfiguration.appId appSecret:self.platformConfiguration.appSecret success:^(id _Nonnull data) {
        CHSKWXCredential *wxCredential = [CHSKWXCredential yy_modelWithJSON:data];
        wxCredential.rawData = data;
        
        CHSKCredential *credential = [CHSKCredential new];
        credential.uid = wxCredential.openid;
        credential.token = wxCredential.access_token;
        credential.expired = [NSDate dateWithTimeIntervalSince1970:wxCredential.expires_in.doubleValue];
        credential.rawData = wxCredential.rawData;
        
        [CHSKNetworking getWXUserInfoWithAccessToken:wxCredential.access_token openId:wxCredential.openid success:^(id  _Nonnull data) {
            
            CHSKUser *user = [CHSKUser new];
            user.credential = credential;
            user.rawData = data;
            
            !completionHandler ?: completionHandler(user, nil);
        } failure:^(NSError * _Nonnull error) {
            !completionHandler ?: completionHandler(nil, error);
        }];
    } failure:^(NSError * _Nonnull error) {
        !completionHandler ?: completionHandler(nil, error);
    }];
}

- (void)convertShareMessageToWXReq:(CHSKShareMessage *)shareMessage
                        wxPlatform:(CHSKPlatformType)platformType
                 completionHandler:(CHSKMessageConvertCompletionHandler)completionHandler {
    __block NSError *aError = nil;
    if (!shareMessage) {
        aError = [NSError ch_sk_errorWithCode:CHSKErrorCodeInvalidMessage];
        !completionHandler ?: completionHandler(nil, aError);
        return;
    }
    
    enum WXScene scene = WXSceneSession;
    switch (platformType) {
        case CHSKPlatformTypeWX:
        case CHSKPlatformTypeWXSession:
        {
            scene = WXSceneSession;
        }
            break;
        case CHSKPlatformTypeWXTimeline:
        {
            scene = WXSceneTimeline;
        }
            break;
            
        default:
            break;
    }
    
    if (shareMessage.type == CHSKMessageTypeUndefined) {
        aError = [NSError ch_sk_errorWithCode:CHSKErrorCodeUndefined];
        !completionHandler ?: completionHandler(nil, aError);
        return;
    }
    // 文本
    if (shareMessage.type == CHSKMessageTypeText) {
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = shareMessage.title;
        req.scene = scene;
        !completionHandler ?: completionHandler(req, nil);
        return;
    }
    // 图片
    id image = [shareMessage.images firstObject];
    if (shareMessage.type == CHSKMessageTypeImage) {
        [CHSKMessageConvertHelper configureShareImageDataWithImage:image maxFileSize:CHSKWXShareImageMaxFileSize thumbnailImage:shareMessage.thumbnail maxThumbnailFileSize:CHSKWXShareThumbnailImageMaxFileSize completionHandler:^(NSData *imageData, NSData *thumbnailImageData, NSError *error) {
            aError = error;
            if (aError) {
                !completionHandler ?: completionHandler(nil, aError);
                return;
            }
            
            WXImageObject *imageObject = [WXImageObject object];
            imageObject.imageData = imageData ?: thumbnailImageData;
            
            WXMediaMessage *mediaMessage = [WXMediaMessage message];
            mediaMessage.thumbData = thumbnailImageData;
            mediaMessage.mediaObject = imageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = mediaMessage;
            req.scene = scene;
            !completionHandler ?: completionHandler(req, nil);
        }];
        return;
    }
    // 网页
    if (shareMessage.type == CHSKMessageTypeWebPage) {
        [CHSKMessageConvertHelper configureShareImageDataWithImage:image maxFileSize:CHSKWXShareThumbnailImageMaxFileSize thumbnailImage:image maxThumbnailFileSize:CHSKWXShareThumbnailImageMaxFileSize completionHandler:^(NSData *imageData, NSData *thumbnailImageData, NSError *error) {
            aError = error;
            if (aError) {
                !completionHandler ?: completionHandler(nil, aError);
                return;
            }
            
            WXWebpageObject *webpageObject = [WXWebpageObject object];
            webpageObject.webpageUrl = shareMessage.url.absoluteString;
            
            WXMediaMessage *mediaMessage = [WXMediaMessage message];
            mediaMessage.title = shareMessage.title;
            mediaMessage.description = shareMessage.desc;
            mediaMessage.thumbData = thumbnailImageData?:imageData;
            mediaMessage.mediaObject = webpageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = mediaMessage;
            req.scene = scene;
            !completionHandler ?: completionHandler(req, nil);
        }];
        return;
    }
}

@end
