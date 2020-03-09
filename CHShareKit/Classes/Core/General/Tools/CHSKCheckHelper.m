//
//  CHSKCheckHelper.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "CHSKCheckHelper.h"

#import "CHSKShareMessage.h"

#import "CHSKPrivateDefines.h"
#import "NSArray+CHShareKit.h"
#import "NSObject+CHShareKit.h"
#import "NSString+CHShareKit.h"
#import "NSURL+CHShareKit.h"

@implementation CHSKCheckHelper

#pragma mark - Check Share Message
+ (NSInteger)isValidShareMessage:(CHSKShareMessage *)shareMessage forSharePlatform:(CHSKPlatformType)platformType {
    switch (platformType) {
        case CHSKPlatformTypeWXSession:
        case CHSKPlatformTypeWX:
            return [self isValidShareMessageForWXSession:shareMessage];
        case CHSKPlatformTypeWXTimeline:
            return [self isValidShareMessageForWXTimeline:shareMessage];
        case CHSKPlatformTypeQQ:
        case CHSKPlatformTypeQQFriends:
            return [self isValidShareMessageForQQFriends:shareMessage];
        case CHSKPlatformTypeQZone:
            return [self isValidShareMessageForQZone:shareMessage];
        case CHSKPlatformTypeUndefined:
            return CHSKErrorCodeUndefined;
    }
    return CHSKErrorCodeUndefined;
}

+ (NSInteger)isValidShareMessageForWXSession:(CHSKShareMessage *)shareMessage {
    return [self isValidShareMessageForWX:shareMessage];
}

+ (NSInteger)isValidShareMessageForWXTimeline:(CHSKShareMessage *)shareMessage {
    return [self isValidShareMessageForWX:shareMessage];
}

+ (NSInteger)isValidShareMessageForWX:(CHSKShareMessage *)shareMessage {
    if (!shareMessage) return CHSKErrorCodeInvalidMessage;
    
    switch (shareMessage.type) {
        case CHSKMessageTypeUndefined:
            return CHSKErrorCodeUnsupportMessageType;
            break;
        case CHSKMessageTypeText:
        {
            if (![shareMessage.title ch_sk_isValidTitleForWX]) return CHSKErrorCodeInvalidMessageTitle;
        }
            break;
        case CHSKMessageTypeImage:
        {
            if (![shareMessage.images ch_sk_isValidShareImagesForWX]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeWebPage:
        {            
            if (![shareMessage.title ch_sk_isValidTitleForWX]) return CHSKErrorCodeInvalidMessageTitle;
            if (![shareMessage.desc ch_sk_isValidDescForWX]) return CHSKErrorCodeInvalidMessageDesc;
            if (![shareMessage.url ch_sk_isValidURLForWX]) return CHSKErrorCodeInvalidMessageURL;
            if (![shareMessage.images ch_sk_isValidShareImagesForWX] && ![shareMessage.thumbnail ch_sk_isValidShareImageForWX]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeVideo:
        case CHSKMessageTypeApp:
        {
            if (![shareMessage.title ch_sk_isValidTitleForWX]) return CHSKErrorCodeInvalidMessageTitle;
            if (![shareMessage.desc ch_sk_isValidDescForWX]) return CHSKErrorCodeInvalidMessageDesc;
            if (![shareMessage.url ch_sk_isValidURLForWX]) return CHSKErrorCodeInvalidMessageURL;
            if (![shareMessage.images ch_sk_isValidShareImagesForWX] && ![shareMessage.thumbnail ch_sk_isValidShareImageForWX]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeAudio:
        {
            return CHSKErrorCodeUnsupportMessageType;
            
            if (![shareMessage.title ch_sk_isValidTitleForWX]) return CHSKErrorCodeInvalidMessageTitle;
            if (![shareMessage.desc ch_sk_isValidDescForWX]) return CHSKErrorCodeInvalidMessageDesc;
            if (![shareMessage.url ch_sk_isValidURLForWX]) return CHSKErrorCodeInvalidMessageURL;
            if (![shareMessage.mediaDataUrl ch_sk_isValidURLForWX]) return CHSKErrorCodeInvalidMessageURL;
            if (![shareMessage.images ch_sk_isValidShareImagesForWX] && ![shareMessage.thumbnail ch_sk_isValidShareImageForWX]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeFile:
        {
            return CHSKErrorCodeUnsupportMessageType;
            
            if (![shareMessage.title ch_sk_isValidTitleForWX]) return CHSKErrorCodeInvalidMessageTitle;
            if (![shareMessage.desc ch_sk_isValidDescForWX]) return CHSKErrorCodeInvalidMessageDesc;
            if (!shareMessage.fileExt) return CHSKErrorCodeInvalidMessageFileExt;
            if (![shareMessage.images ch_sk_isValidShareImagesForWX] && ![shareMessage.thumbnail ch_sk_isValidShareImageForWX]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
    }
    return CHSKWXShareMessageValidCode;
}

+ (NSInteger)isValidShareMessageForQQFriends:(CHSKShareMessage *)shareMessage {
    if (!shareMessage) return CHSKErrorCodeInvalidMessage;
    
    switch (shareMessage.type) {
        case CHSKMessageTypeUndefined:
        case CHSKMessageTypeApp:
        case CHSKMessageTypeFile:
            return CHSKErrorCodeUnsupportMessageType;
            break;
        case CHSKMessageTypeText:
        {
            if (!shareMessage.title) return CHSKErrorCodeInvalidMessageTitle;
        }
            break;
        case CHSKMessageTypeImage:
        {
            if (!shareMessage.title) return CHSKErrorCodeInvalidMessageTitle;
            if (!shareMessage.desc) return CHSKErrorCodeInvalidMessageDesc;
            if (![shareMessage.images ch_sk_isValidShareImages]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeWebPage:
        {
            if (!shareMessage.title) return CHSKErrorCodeInvalidMessageTitle;
            if (!shareMessage.desc) return CHSKErrorCodeInvalidMessageDesc;
            if (!shareMessage.url || !shareMessage.url.absoluteString.length) return CHSKErrorCodeInvalidMessageURL;
            if (![shareMessage.images ch_sk_isValidShareImages] && ![shareMessage.thumbnail ch_sk_isValidClassForShareImage]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeAudio:
        case CHSKMessageTypeVideo:
        {
            return CHSKErrorCodeUnsupportMessageType;
            
            if (!shareMessage.title) return CHSKErrorCodeInvalidMessageTitle;
            if (!shareMessage.desc) return CHSKErrorCodeInvalidMessageDesc;
            if (!shareMessage.url || !shareMessage.url.absoluteString.length) return CHSKErrorCodeInvalidMessageURL;
            if (![shareMessage.images ch_sk_isValidShareImages] && ![shareMessage.thumbnail ch_sk_isValidClassForShareImage]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
    }
    return CHSKWXShareMessageValidCode;
}

+ (NSInteger)isValidShareMessageForQZone:(CHSKShareMessage *)shareMessage {
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
            if (!shareMessage.title) return CHSKErrorCodeInvalidMessageTitle;
            if (!shareMessage.desc) return CHSKErrorCodeInvalidMessageDesc;
            if (![shareMessage.images ch_sk_isValidShareImages]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeWebPage:
        {
            if (!shareMessage.title) return CHSKErrorCodeInvalidMessageTitle;
            if (!shareMessage.desc) return CHSKErrorCodeInvalidMessageDesc;
            if (!shareMessage.url || !shareMessage.url.absoluteString.length) return CHSKErrorCodeInvalidMessageURL;
            if (![shareMessage.images ch_sk_isValidShareImages] && ![shareMessage.thumbnail ch_sk_isValidClassForShareImage]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
        case CHSKMessageTypeAudio:
        case CHSKMessageTypeVideo:
        {
            return CHSKErrorCodeUnsupportMessageType;
            
            if (!shareMessage.title) return CHSKErrorCodeInvalidMessageTitle;
            if (!shareMessage.desc) return CHSKErrorCodeInvalidMessageDesc;
            if (!shareMessage.url || !shareMessage.url.absoluteString.length) return CHSKErrorCodeInvalidMessageURL;
            if (![shareMessage.images ch_sk_isValidShareImages] && ![shareMessage.thumbnail ch_sk_isValidClassForShareImage]) return CHSKErrorCodeInvalidMessageImages;
        }
            break;
    }
    return CHSKWXShareMessageValidCode;
}

@end
