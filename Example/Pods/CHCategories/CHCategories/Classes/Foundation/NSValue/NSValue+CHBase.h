//
//  NSValue+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2020/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 获取location及length为0的NSRange。等同于NSMakeRange(0, 0)
 */
FOUNDATION_EXTERN const NSRange CHNSRangeZero;

/**
 range1是否包含range2内

 @param range1 Range1
 @param range2 Range2
 @return 包含返回YES, 否则返回NO
 */
NS_INLINE BOOL CHNSRangeInRange(NSRange range1, NSRange range2) {
    return (NSLocationInRange(range2.location, range1) && range2.length <= (range1.length - range2.location)) ? YES : NO;
}

/**
 将CFRange转换为NSRange

 @param range CFRange
 @return NSRange
 */
NS_INLINE NSRange CHNSRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

/**
 将NSRange转换为CFRange

 @param range NSRange
 @return CFRange
 */
NS_INLINE CFRange CHCFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

@interface NSValue (CHBase)

#pragma mark - Base
/**
 根据CGColorRef, 创建NSValue对象(通过ch_CGColorValue获取)

 @param color CGColorRef
 @return NSValue对象
 */
+ (NSValue *)ch_valueWithCGColor:(CGColorRef)color;

/**
 获取NSValue对象内的CGColorRef

 @return CGColorRef
 */
- (CGColorRef)ch_CGColorValue;

/**
根据SEL, 创建NSValue对象

@param selector selector
@return NSValue对象
*/
+ (NSValue *)ch_valueWithSelector:(SEL)selector;

/**
获取NSValue对象内的SEL

@return SEL
*/
- (SEL)ch_selectorValue;

@end

NS_ASSUME_NONNULL_END
