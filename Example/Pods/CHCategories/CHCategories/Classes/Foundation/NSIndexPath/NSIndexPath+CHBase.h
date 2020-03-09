//
//  NSIndexPath+CHBase.h
//  CHCategories
//
//  Created by CHwang on 17/1/4.
//  Base

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSIndexPath (CHBase)

#pragma mark - Base
/**
 判断两个IndexPath是否相等

 @param other 另一个indexPath
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isEqualToIndexPath:(NSIndexPath *)other;

@end

NS_ASSUME_NONNULL_END
