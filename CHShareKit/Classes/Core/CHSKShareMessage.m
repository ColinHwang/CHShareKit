//
//  CHSKShareMessage.m
//  
//
//  Created by CHwang on 2019/4/16.
//

#import "CHSKShareMessage.h"
#import <CHCategories/CHCategories.h>

@interface CHSKShareMessage ()

@property (nonatomic, copy, readwrite) NSString *title;        ///< 分享标题
@property (nonatomic, copy, readwrite) NSString *desc;         ///< 描述文本
@property (nonatomic, strong, readwrite) NSArray<id> *images;  ///< 分享图片
@property (nonatomic, strong, readwrite) id thumbnail;         ///< 缩略图片
@property (nonatomic, strong, readwrite) NSURL *url;           ///< 分享链接
@property (nonatomic, assign, readwrite) CHSKMessageType type; ///< 分享类型

//for WX
@property (nonatomic, copy, readwrite) NSString *exterInfo;   ///< 扩展信息
@property (nonatomic, strong, readwrite) NSURL *mediaDataUrl; ///< 媒体信息Url
@property (nonatomic, copy, readwrite) NSString *fileExt;     ///< 文件后缀

@end

@implementation CHSKShareMessage

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = CHSKMessageTypeUndefined;
        _desc = @"";
    }
    return self;
}

#pragma mark - Base
+ (instancetype)shareMessageWithTitle:(NSString *)title {
    return [CHSKShareMessage shareMessageWithTitle:title description:@"" image:nil url:nil type:CHSKMessageTypeText];
}

+ (instancetype)shareMessageWithTitle:(NSString *)title
                                image:(id)image {
    return [CHSKShareMessage shareMessageWithTitle:title description:@"" image:image url:nil type:CHSKMessageTypeImage];
}

+ (instancetype)shareMessageWithTitle:(NSString *)title
                                image:(id)image
                             thumbali:(id)thumbImage {
    CHSKShareMessage *shareMessage = [[CHSKShareMessage alloc] init];
    
    shareMessage.title = title;
    NSMutableArray *images = nil;
    if (image) {
        images = @[].mutableCopy;
        if ([image isKindOfClass:[NSArray class]]) {
            [images addObjectsFromArray:image];
        } else {
            [images addObject:image];
        }
    }
    shareMessage.images = images.copy;
    shareMessage.type = CHSKMessageTypeImage;
    
    return shareMessage;
}

+ (instancetype)shareMessageWithTitle:(NSString *)title
                          description:(NSString *)description
                                image:(id)image
                                  url:(NSURL *)url {
    return [CHSKShareMessage shareMessageWithTitle:title description:description image:image url:url type:CHSKMessageTypeWebPage];
}

+ (instancetype)shareMessageWithTitle:(NSString *)title
                          description:(NSString *)desc
                                image:(id)image
                                  url:(NSURL *)url
                                 type:(CHSKMessageType)type {
    NSMutableArray *images = nil;
    if (image) {
        images = @[].mutableCopy;
        if ([image isKindOfClass:[NSArray class]]) {
            [images addObjectsFromArray:image];
        } else {
            [images addObject:image];
        }
    }
    CHSKShareMessage *shareMessage = [self shareMessageWithTitle:title description:desc images:images.copy url:url type:type];
    return shareMessage;
}

+ (instancetype)shareMessageWithTitle:(NSString *)title
                          description:(NSString *)desc
                               images:(id)images
                                  url:(NSURL *)url
                                 type:(CHSKMessageType)type {
    CHSKShareMessage *shareMessage = [[self alloc] init];
    shareMessage.title = title;
    shareMessage.desc = desc?:@"";
    shareMessage.images = images;
    shareMessage.url = url;
    shareMessage.type = type;
    return shareMessage;
}

#pragma mark - Custom
+ (instancetype)shareMessageForWXWithTitle:(NSString *)title
                               description:(NSString *)desc
                                     image:(id)image
                                  thumbali:(id)thumbImage
                                       url:(NSURL *)url
                                 exterInfo:(NSString *)extInfo
                              mediaDataUrl:(NSURL *)mediaDataUrl
                                   fileExt:(NSString *)fileExt
                                      type:(CHSKMessageType)type {
    NSMutableArray *images = nil;
    if (image) {
        images = @[].mutableCopy;
        if ([image isKindOfClass:[NSArray class]]) {
            [images addObjectsFromArray:image];
        } else {
            [images addObject:image];
        }
    }
    CHSKShareMessage *shareMessage = [self shareMessageForWXWithTitle:title description:desc images:images.copy thumbali:thumbImage url:url exterInfo:extInfo mediaDataUrl:mediaDataUrl fileExt:fileExt type:type];
    return shareMessage;
}

+ (instancetype)shareMessageForWXWithTitle:(NSString *)title
                               description:(NSString *)desc
                                    images:(id)images
                                  thumbali:(id)thumbImage
                                       url:(NSURL *)url
                                 exterInfo:(NSString *)extInfo
                              mediaDataUrl:(NSURL *)mediaDataUrl
                                   fileExt:(NSString *)fileExt
                                      type:(CHSKMessageType)type {
    CHSKShareMessage *shareMessage = [[self alloc] init];
    shareMessage.title = title;
    shareMessage.desc = desc;
    shareMessage.images = images;
    shareMessage.thumbnail = thumbImage;
    shareMessage.url = url;
    shareMessage.exterInfo = extInfo;
    shareMessage.mediaDataUrl = mediaDataUrl;
    shareMessage.fileExt = fileExt;
    shareMessage.type = type;
    return shareMessage;
}

+ (instancetype)shareMessageForQQFriendsWithTitle:(NSString *)title
                                      description:(NSString *)desc
                                            image:(id)image
                                         thumbali:(id)thumbImage
                                              url:(NSURL *)url
                                             type:(CHSKMessageType)type {
    NSMutableArray *images = nil;
    if (image) {
        images = @[].mutableCopy;
        if ([image isKindOfClass:[NSArray class]]) {
            [images addObjectsFromArray:image];
        } else {
            [images addObject:image];
        }
    }
    CHSKShareMessage *shareMessage = [self shareMessageForQQFriendsWithTitle:title description:desc images:images.copy thumbali:thumbImage url:url type:type];
    return shareMessage;
}

+ (instancetype)shareMessageForQQFriendsWithTitle:(NSString *)title
                                      description:(NSString *)desc
                                           images:(id)images
                                         thumbali:(id)thumbImage
                                              url:(NSURL *)url
                                             type:(CHSKMessageType)type {
    CHSKShareMessage *shareMessage = [[self alloc] init];
    shareMessage.title = title;
    shareMessage.desc = desc;
    shareMessage.images = images;
    shareMessage.thumbnail = thumbImage;
    shareMessage.url = url;
    shareMessage.type = type;
    return shareMessage;
}


+ (instancetype)shareMessageForQZoneWithTitle:(NSString *)title
                                  description:(NSString *)desc
                                        image:(id)image
                                     thumbali:(id)thumbImage
                                          url:(NSURL *)url
                                         type:(CHSKMessageType)type {
    NSMutableArray *images = nil;
    if (image) {
        images = @[].mutableCopy;
        if ([image isKindOfClass:[NSArray class]]) {
            [images addObjectsFromArray:image];
        } else {
            [images addObject:image];
        }
    }
    CHSKShareMessage *shareMessage = [self shareMessageForQZoneWithTitle:title description:desc images:images.copy thumbali:thumbImage url:url type:type];
    return shareMessage;
}

+ (instancetype)shareMessageForQZoneWithTitle:(NSString *)title
                                  description:(NSString *)desc
                                       images:(id)images
                                     thumbali:(id)thumbImage
                                          url:(NSURL *)url
                                         type:(CHSKMessageType)type {
    CHSKShareMessage *shareMessage = [[self alloc] init];
    shareMessage.title = title;
    shareMessage.desc = desc;
    shareMessage.images = images;
    shareMessage.thumbnail = thumbImage;
    shareMessage.url = url;
    shareMessage.type = type;
    return shareMessage;
}

#pragma mark - setters/getters

@end
