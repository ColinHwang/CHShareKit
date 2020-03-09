//
//  NSArray+CHShareKit.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CHShareKit)

/**
 是否为适用于分享的图片数组(UIImage、NSURL、NSString)
 
 @return 符合返回YES, 否则返回NO
 */
- (BOOL)ch_sk_isValidShareImages;

/**
 是否为适用于WX分享的图片数组(UIImage、NSURL、NSString, URL及URLString应在10KB以内)
 
 @return 符合返回YES, 否则返回NO
 */
- (BOOL)ch_sk_isValidShareImagesForWX;

@end

NS_ASSUME_NONNULL_END
