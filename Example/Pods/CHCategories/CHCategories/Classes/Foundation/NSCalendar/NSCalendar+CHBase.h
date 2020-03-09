//
//  NSCalendar+CHBase.h
//  CHCategories
//
//  Created by CHwang on 2020/1/4.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (CHBase)

#pragma mak - Base
/**
 获取指定月份的首日期
 
 @param month 指定月份
 @return 首日期
 */
- (nullable NSDate *)ch_firstDayOfMonth:(NSDate *)month;

/**
 获取指定月份的尾日期
 
 @param month 指定月份
 @return 尾日期
 */
- (nullable NSDate *)ch_lastDayOfMonth:(NSDate *)month;

/**
 获取指定月份的天数
 
 @param month 月份
 @return 天数
 */
- (NSInteger)ch_numberOfDaysInMonth:(NSDate *)month;

/**
 获取指定星期的首日期
 
 @param week 指定星期
 @return 首日期
 */
- (nullable NSDate *)ch_firstDayOfWeek:(NSDate *)week;

/**
 获取指定星期的尾日期
 
 @param week 指定星期
 @return 尾日期
 */
- (nullable NSDate *)ch_lastDayOfWeek:(NSDate *)week;

/**
 获取指定星期的中间日期
 
 @param week 指定星期
 @return 中间日期
 */
- (nullable NSDate *)ch_middleDayOfWeek:(NSDate *)week;

@end

NS_ASSUME_NONNULL_END
