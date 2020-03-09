//
//  CHSKPrivateDefines.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>

#ifndef CHSKPrivateDefines_h
#define CHSKPrivateDefines_h

#ifndef CH_SK_STR_AVOID_NIL
#define CH_SK_STR_AVOID_NIL( _value_ ) (_value_) ? : @""
#endif

// WX
FOUNDATION_EXTERN NSString * const CHSKPlatformWXIDKey;
FOUNDATION_EXTERN NSString * const CHSKPlatformWXSecretKey;

// QQ
FOUNDATION_EXTERN NSString * const CHSKPlatformQQIDKey;
FOUNDATION_EXTERN NSString * const CHSKPlatformQQSecretKey;

// Message Regular
// Share Message Code
FOUNDATION_EXTERN const NSInteger CHSKWXShareMessageValidCode;
// Share Title Length
FOUNDATION_EXTERN const NSInteger CHSKWXShareTitleMaxLength;
// Share Desc Length
FOUNDATION_EXTERN const NSInteger CHSKWXShareDescMaxLength;
// Share URL Length
FOUNDATION_EXTERN const NSInteger CHSKWXShareURLStringMaxLength;
// Share Image Size
FOUNDATION_EXTERN const CGSize CHSKShareThumbnailImageSize;             // 100x100
FOUNDATION_EXTERN const NSInteger CHSKWXShareImageMaxFileSize;          // 10485760 -> 10M
FOUNDATION_EXTERN const NSInteger CHSKWXShareThumbnailImageMaxFileSize; // 32768 -> 32KB
FOUNDATION_EXTERN const NSInteger CHSKQQShareImageMaxFileSize;          // 5242880 -> 5M
FOUNDATION_EXTERN const NSInteger CHSKQQShareThumbnailImageMaxFileSize; // 1048576 -> 1M
FOUNDATION_EXTERN const CGFloat CHSKShareImageCompressionFactor; // 图片压缩精度系数

// Share Error
FOUNDATION_EXTERN NSString * const CHSKErrorDomin;

// Handler
/**
 图片下载回调处理

 @param image     图片
 @param imageData 图片Data
 @param error     错误信息
 @param finished  完成标识
 */
typedef void(^CHSKImageDownloadCompletionHandler)(UIImage *image, NSData *imageData, NSError *error, BOOL finished);

/**
 消息转换回调处理

 @param toMessage 目标消息
 @param error     错误信息
 */
typedef void(^CHSKMessageConvertCompletionHandler)(id toMessage, NSError *error);

/**
 分享图片数据转换回调处理

 @param imageData          原图数据
 @param thumbnailImageData 缩略图数据
 @param error              错误信息
 */
typedef void(^CHSKImageDataConvertCompletionHandler)(NSData *imageData, NSData *thumbnailImageData, NSError *error);

/**
 加载授权信息回调处理

 @param authorizeInfo 授权信息
 @param error         错误信息
 */
typedef void(^CHSKLoadAuthorizeInfoCompletionHandler)(id authorizeInfo, NSError *error);

#endif /* CHSKPrivateDefines_h */
