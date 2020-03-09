//
//  CHSKShareMessage.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>
#import "CHSKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHSKShareMessage : NSObject

@property (nonatomic, copy, readonly) NSString *title;        ///< 分享标题
@property (nonatomic, copy, readonly) NSString *desc;         ///< 描述文本
@property (nonatomic, strong, readonly) NSArray<id> *images;  ///< 分享图片
@property (nonatomic, strong, readonly) id thumbnail;         ///< 缩略图片
@property (nonatomic, strong, readonly) NSURL *url;           ///< 分享链接
@property (nonatomic, assign, readonly) CHSKMessageType type; ///< 分享类型

//for WX
@property (nonatomic, copy, readonly) NSString *exterInfo;   ///< 扩展信息
@property (nonatomic, strong, readonly) NSURL *mediaDataUrl; ///< 媒体信息Url
@property (nonatomic, copy, readonly) NSString *fileExt;     ///< 文件后缀

#pragma mark - Base
/**
 创建文本分享类信息
 
 @param title title 分享标题(必须)
 */
+ (instancetype)shareMessageWithTitle:(NSString *)title;

/**
 创建图片类分享信息
 
 @param title 分享标题(必须)
 @param image 分享图片(必须, 可以为UIImage、NSString<图片路径>、NSURL<图片路径>)
 */
+ (instancetype)shareMessageWithTitle:(NSString *)title
                                image:(id)image;

/**
 创建图片类分享信息
 
 @param title      分享标题(必须)
 @param image      分享图片(必须, 可以为UIImage、NSString<图片路径>、NSURL<图片路径>)
 @param thumbImage 缩略图(可选, 可以为UIImage、NSString<图片路径>、NSURL（图片路径>)
 */
+ (instancetype)shareMessageWithTitle:(NSString *)title
                                image:(id)image
                             thumbali:(id)thumbImage;

/**
 创建网页类分享信息
 
 @param title       分享标题(必须)
 @param description 描述文本(必须)
 @param image       分享图片(必须, 文件大小应不大于32KB, 可以为UIImage、NSString<图片路径>、NSURL<图片路径>)
 @param url         分享链接(必须, 链接长度应小于256个字节)
 */
+ (instancetype)shareMessageWithTitle:(NSString *)title
                          description:(NSString *)description
                                image:(id)image
                                  url:(NSURL *)url;

#pragma mark - Custom
/**
 创建WX分享信息
 
 @param title        分享标题
 @param desc         描述文本
 @param image        分享图片, 可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 @param thumbImage   缩略图片, 可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 @param url          分享链接
 @param extInfo      扩展信息
 @param mediaDataUrl 音乐文件链接地址
 @param fileExt      文件后缀名
 @param type         分享类型, 仅支持Text、Image、WebPage、APP、Audio、Video类型
 */
+ (instancetype)shareMessageForWXWithTitle:(NSString *)title
                               description:(NSString *)desc
                                     image:(id)image
                                  thumbali:(id)thumbImage
                                       url:(NSURL *)url
                                 exterInfo:(NSString *)extInfo
                              mediaDataUrl:(NSURL *)mediaDataUrl
                                   fileExt:(NSString *)fileExt
                                      type:(CHSKMessageType)type;

/**
 创建QQ好友分享信息
 
 @param title      分享标题
 @param desc       描述文本
 @param image      分享图片, 可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 @param thumbImage 缩略图片, 可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 @param url        分享链接(如果分享类型为音频/视频时, 应该传入音频/视频的网络URL地址)
 @param type       分享类型, 仅支持Text、Image、WebPage、Audio、Video类型
 */
+ (instancetype)shareMessageForQQFriendsWithTitle:(NSString *)title
                                      description:(NSString *)desc
                                            image:(id)image
                                         thumbali:(id)thumbImage
                                              url:(NSURL *)url
                                             type:(CHSKMessageType)type;

/**
 创建QQ空间分享信息
 
 @param title      分享标题
 @param desc       描述文本
 @param image      分享图片, 可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 @param thumbImage 缩略图片, 可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 @param url        分享链接(如果分享类型为音频/视频时, 应该传入音频/视频的网络URL地址)
 @param type       分享类型, 仅支持Image、WebPage、Audio、Video类型
 */
+ (instancetype)shareMessageForQZoneWithTitle:(NSString *)title
                                  description:(NSString *)desc
                                        image:(id)image
                                     thumbali:(id)thumbImage
                                          url:(NSURL *)url
                                         type:(CHSKMessageType)type;

@end

NS_ASSUME_NONNULL_END
