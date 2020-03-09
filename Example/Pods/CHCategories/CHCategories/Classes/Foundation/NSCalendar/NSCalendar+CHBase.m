//
//  NSCalendar+CHBase.m
//  CHCategories
//
//  Created by CHwang on 2020/1/4.
//
//

#import "NSCalendar+CHBase.h"
#import "NSObject+CHBase.h"

static const int CH_NS_CALENDAR_PRIVATE_COMPENENTS_KEY;

@implementation NSCalendar (CHBase)

#pragma mark - Base
- (nullable NSDate *)ch_firstDayOfMonth:(NSDate *)month {
    if (!month) return nil;
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    components.day = 1;
    return [self dateFromComponents:components];
}

- (nullable NSDate *)ch_lastDayOfMonth:(NSDate *)month {
    if (!month) return nil;
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    components.month++;
    components.day = 0;
    return [self dateFromComponents:components];
}

- (NSInteger)ch_numberOfDaysInMonth:(NSDate *)month {
    if (!month) return 0;
    NSRange days = [self rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:month];
    return days.length;
}

- (nullable NSDate *)ch_firstDayOfWeek:(NSDate *)week {
    if (!week) return nil;
    NSDateComponents *weekdayComponents = [self components:NSCalendarUnitWeekday fromDate:week];
    NSDateComponents *components = self._ch_privateComponents;
    components.day = - (weekdayComponents.weekday - self.firstWeekday);
    components.day = (components.day-7) % 7;
    NSDate *firstDayOfWeek = [self dateByAddingComponents:components toDate:week options:0];
    firstDayOfWeek = [self dateBySettingHour:0 minute:0 second:0 ofDate:firstDayOfWeek options:0];
    components.day = NSIntegerMax;
    return firstDayOfWeek;
}

- (nullable NSDate *)ch_lastDayOfWeek:(NSDate *)week {
    if (!week) return nil;
    NSDateComponents *weekdayComponents = [self components:NSCalendarUnitWeekday fromDate:week];
    NSDateComponents *components = self._ch_privateComponents;
    components.day = - (weekdayComponents.weekday - self.firstWeekday);
    components.day = (components.day-7) % 7 + 6;
    NSDate *lastDayOfWeek = [self dateByAddingComponents:components toDate:week options:0];
    lastDayOfWeek = [self dateBySettingHour:0 minute:0 second:0 ofDate:lastDayOfWeek options:0];
    components.day = NSIntegerMax;
    return lastDayOfWeek;
}

- (nullable NSDate *)ch_middleDayOfWeek:(NSDate *)week {
    if (!week) return nil;
    NSDateComponents *weekdayComponents = [self components:NSCalendarUnitWeekday fromDate:week];
    NSDateComponents *componentsToSubtract = self._ch_privateComponents;
    componentsToSubtract.day = - (weekdayComponents.weekday - self.firstWeekday) + 3;
    NSDate *middleDayOfWeek = [self dateByAddingComponents:componentsToSubtract toDate:week options:0];
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:middleDayOfWeek];
    middleDayOfWeek = [self dateFromComponents:components];
    componentsToSubtract.day = NSIntegerMax;
    return middleDayOfWeek;
}

- (NSDateComponents *)_ch_privateComponents {
    NSDateComponents *components = [self ch_getAssociatedValueForKey:&CH_NS_CALENDAR_PRIVATE_COMPENENTS_KEY];
    if (!components) {
        components = [[NSDateComponents alloc] init];
        [self ch_setAssociatedValue:components withKey:&CH_NS_CALENDAR_PRIVATE_COMPENENTS_KEY];
    }
    return components;
}

@end
