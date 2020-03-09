//
//  NSObject+CHShareKit.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CHShareKit)

/**
 是否为适用于分享的图片类别(UIImage、NSURL、NSString)
 
 @return 符合返回YES, 否则返回NO
 */
- (BOOL)ch_sk_isValidClassForShareImage;

/**
 是否为适用于WX分享的图片对象(UIImage、NSURL、NSString, URL及URLString应在10KB以内)
 
 @return 符合返回YES, 否则返回NO
 */
- (BOOL)ch_sk_isValidShareImageForWX;


@end

NS_ASSUME_NONNULL_END
