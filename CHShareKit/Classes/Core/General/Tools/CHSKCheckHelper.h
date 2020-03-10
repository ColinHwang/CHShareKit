//
//  CHSKCheckHelper.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHSKCheckHelper : NSObject

/**
 是否为有效的分享标题

 @param title 分享标题
 @return 是返回YES, 否则返回NO
*/
+ (BOOL)isValidTitle:(NSString *)title;

/**
 是否为有效的分享详情

 @param desc 分享详情
 @return 是返回YES, 否则返回NO
*/
+ (BOOL)isValidDesc:(NSString *)desc;

/**
 是否为有效的分享URL字符串

 @param URLString URL字符串
 @return 是返回YES, 否则返回NO
*/
+ (BOOL)isValidURLString:(NSString *)URLString;

/**
 是否为有效的分享URL

 @param URL URL
 @return 是返回YES, 否则返回NO
*/
+ (BOOL)isValidURL:(NSURL *)URL;

/**
 是否为有效的分享图片

 @param image 分享图片
 @return 是返回YES, 否则返回NO
*/
+ (BOOL)isValidImage:(id)image;

/**
 是否为有效的分享图片组

 @param images 分享图片组
 @return 是返回YES, 否则返回NO
*/
+ (BOOL)isValidImages:(NSArray<id> *)images;

@end

NS_ASSUME_NONNULL_END
