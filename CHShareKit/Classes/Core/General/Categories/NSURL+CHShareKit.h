//
//  NSURL+CHShareKit.h
//  
//
//  Created by CHwang on 2019/4/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (CHShareKit)

/**
 是否为适用于WX分享的URL(10KB以内)
 
 @return 符合返回YES, 否则返回NO
 */
- (BOOL)ch_sk_isValidURLForWX;

@end

NS_ASSUME_NONNULL_END
