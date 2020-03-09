//
//  NSDate+CHBase.m
//  CHCategories
//
//  Created by CHwang 17/1/4.
//

#import "NSDate+CHBase.h"
#import "NSArray+CHBase.h"

@implementation NSDate (CHBase)

#pragma mark - Base
- (NSInteger)ch_era {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitEra fromDate:self] era];
}

- (NSInteger)ch_year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)ch_month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)ch_day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)ch_hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)ch_minute
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)ch_second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)ch_nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitNanosecond fromDate:self] nanosecond];
}

- (NSInteger)ch_weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)ch_weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)ch_weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)ch_weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)ch_yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)ch_quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (NSCalendar *)ch_calendar {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitCalendar fromDate:self] calendar];
}

- (NSTimeZone *)ch_timeZone {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitTimeZone fromDate:self] timeZone];
}

#pragma mark - Zodiac Sign
- (CHNSDateAstrologyChineseZodiacSign)ch_ChineseZodiacSign {
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [chineseCalendar components:NSCalendarUnitYear fromDate:self];
    NSInteger year = components.year;
    return (year - 1) % 12;
}

- (CHNSDateAstrologyZodiacSign)ch_zodiacSign {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSInteger buffer = components.month * 100 + components.day;
    
    static dispatch_once_t onceToken;
    static NSArray<NSNumber *> *signs;
    dispatch_once(&onceToken, ^{
        signs = @[@120, @219, @321, @420, @521, @621, @723, @823, @923, @1023, @1122, @1222];
    });
    
    __block CHNSDateAstrologyZodiacSign sign = CHNSDateAstrologyZodiacSignCapricorn;
    [signs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (buffer < [obj integerValue]) {
            if (idx != 0) sign = idx - 1;
            *stop = YES;
        }
    }];
    return sign;
}

#pragma mark - Time Interval
- (NSInteger)ch_timeIntervalSince1970 {
    return self.timeIntervalSince1970 * 1000;
}

#pragma mark - Comparison
- (BOOL)ch_isLeapYear {
    NSUInteger year = self.ch_year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)ch_isLastYearLeapYear {
    NSDate *added = [self ch_dateByAddingYears:-1];
    return [added ch_isLeapYear];
}

- (BOOL)ch_isNextYearLeapYear {
    NSDate *added = [self ch_dateByAddingYears:1];
    return [added ch_isLeapYear];
}

- (BOOL)ch_isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)ch_isLastMonthLeapMonth {
    NSDate *added = [self ch_dateByAddingMonths:-1];
    return [added ch_isLeapMonth];
}

- (BOOL)ch_isNextMonthLeapMonth {
    NSDate *added = [self ch_dateByAddingMonths:1];
    return [added ch_isLeapMonth];
}

- (BOOL)ch_isThisYear {
    return [self ch_isYearEqualToDate:[NSDate date]];
}

- (BOOL)ch_isLastYear {
    NSDate *added = [self ch_dateByAddingYears:1];
    return [added ch_isThisYear];
}

- (BOOL)ch_isNextYear {
    NSDate *added = [self ch_dateByAddingYears:-1];
    return [added ch_isThisYear];
}

- (BOOL)ch_isThisMonth {
    if (!self.ch_isThisYear) return NO;
    
    return [self ch_isMonthEqualToDate:[NSDate date]];
}

- (BOOL)ch_isLastMonth {
    NSDate *added = [self ch_dateByAddingMonths:1];
    return [added ch_isThisMonth];
}

- (BOOL)ch_isNextMonth {
    NSDate *added = [self ch_dateByAddingMonths:-1];
    return [added ch_isThisMonth];
}

- (BOOL)ch_isThisWeek {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24 * 7) return NO;
    
    return [self ch_isEqualToDate:[NSDate date] toUnitGranularity:NSCalendarUnitWeekOfYear];
}

- (BOOL)ch_isLastWeek {
    NSDate *added = [self ch_dateByAddingWeeks:1];
    return [added ch_isThisWeek];
}

- (BOOL)ch_isNextWeek {
    NSDate *added = [self ch_dateByAddingWeeks:-1];
    return [added ch_isThisWeek];
}

- (BOOL)ch_isToday
{
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO; // 日期与当前日期的时间差距
    return [self ch_isDayEqualToDate:[NSDate new]];
}

- (BOOL)ch_isYesterday {
    NSDate *added = [self ch_dateByAddingDays:1];
    return [added ch_isToday]; // 昨天 + 1 = 今天
}

- (BOOL)ch_isTomorrow {
    NSDate *added = [self ch_dateByAddingDays:-1];
    return [added ch_isToday]; // 明天 - 1 = 今天
}

- (BOOL)ch_isTheDayBeforeYesterday {
    NSDate *added = [self ch_dateByAddingDays:2];
    return [added ch_isToday]; // 前天 + 2 = 今天
}

- (BOOL)ch_isTheDayAfterTomorrow {
    NSDate *added = [self ch_dateByAddingDays:-2];
    return [added ch_isToday]; // 后天 - 2 = 今天
}

- (BOOL)ch_isThisHour {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60) return NO;
    
    return [self ch_isHourEqualToDate:[NSDate new]];
}

- (BOOL)ch_isLastHour {
    NSDate *added = [self ch_dateByAddingHours:1];
    return [added ch_isThisHour];
}

- (BOOL)ch_isNextHour {
    NSDate *added = [self ch_dateByAddingHours:-1];
    return [added ch_isThisHour];
}

- (BOOL)ch_isThisMinute {
    if (fabs(self.timeIntervalSinceNow) >= 60) return NO;
    
    return [self ch_isMinuteEqualToDate:[NSDate new]];
}

- (BOOL)ch_isLastMinute {
    NSDate *added = [self ch_dateByAddingMinutes:1];
    return [added ch_isThisMinute];
}

- (BOOL)ch_isNextMinute {
    NSDate *added = [self ch_dateByAddingMinutes:-1];
    return [added ch_isThisMinute];
}

- (BOOL)ch_isThisSecond {
    if (fabs(self.timeIntervalSinceNow) >= 1) return NO;
    
    return [self ch_isSecondEqualToDate:[NSDate new]];
}

- (BOOL)ch_isLastSecond {
    NSDate *added = [self ch_dateByAddingSeconds:1];
    return [added ch_isThisSecond];
}

- (BOOL)ch_isNextSecond {
    NSDate *added = [self ch_dateByAddingSeconds:-1];
    return [added ch_isThisSecond];
}

- (BOOL)ch_isEarlierThanDate:(NSDate *)date {
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL)ch_isLaterThanDate:(NSDate *)date {
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL)ch_isDateBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    if ([self ch_isEarlierThanDate:startDate]) return NO;
    if ([self ch_isLaterThanDate:endDate]) return NO;
    
    return YES;
}

- (BOOL)ch_isInPast {
    return [self ch_isEarlierThanDate:[NSDate date]];
}

- (BOOL)ch_isInFuture {
    return [self ch_isLaterThanDate:[NSDate date]];
}

#pragma mark - Equal
- (BOOL)ch_isEqualToDate:(NSDate *)other toUnitGranularity:(NSCalendarUnit)unit {
    if (!other) return NO;
    if (![other isKindOfClass:[NSDate class]]) return NO;
    
    if (unit & NSCalendarUnitEra) {
        if (self.ch_era != other.ch_era) return NO;
    }
    
    if (unit & NSCalendarUnitYear) {
        if (self.ch_year != other.ch_year) return NO;
    }
    
    if (unit & NSCalendarUnitMonth) {
        if (self.ch_month != other.ch_month) return NO;
    }
    
    if (unit & NSCalendarUnitDay) {
        if (self.ch_day != other.ch_day) return NO;
    }
    
    if (unit & NSCalendarUnitHour) {
        if (self.ch_hour != other.ch_hour) return NO;
    }
    
    if (unit & NSCalendarUnitMinute) {
        if (self.ch_minute != other.ch_minute) return NO;
    }
    
    if (unit & NSCalendarUnitSecond) {
        if (self.ch_second != other.ch_second) return NO;
    }
    
    if (unit & NSCalendarUnitWeekday) {
        if (self.ch_weekday != other.ch_weekday) return NO;
    }
    
    if (unit & NSCalendarUnitWeekdayOrdinal) {
        if (self.ch_weekdayOrdinal != other.ch_weekdayOrdinal) return NO;
    }
    
    if (unit & NSCalendarUnitQuarter) {
        if (self.ch_quarter != other.ch_quarter) return NO;
    }
    
    if (unit & NSCalendarUnitWeekOfMonth) {
        if (self.ch_weekOfMonth != other.ch_weekOfMonth) return NO;
    }
    
    if (unit & NSCalendarUnitWeekOfYear) {
        if (self.ch_weekOfYear != other.ch_weekOfYear) return NO;
    }
    
    if (unit & NSCalendarUnitYearForWeekOfYear) {
        if (self.ch_yearForWeekOfYear != other.ch_yearForWeekOfYear) return NO;
    }
    
    if (unit & NSCalendarUnitNanosecond) {
        if (self.ch_nanosecond != other.ch_nanosecond) return NO;
    }
    
    if (unit & NSCalendarUnitCalendar) {
        if (![self.ch_calendar isEqual:other.ch_calendar]) return NO;
    }
    
    if (unit & NSCalendarUnitTimeZone) {
        if (![self.ch_timeZone isEqualToTimeZone:other.ch_timeZone]) return NO;
    }
    
    return YES;
}

- (BOOL)ch_isEqualToDateIgnoringTime:(NSDate *)other {
    return [self ch_isEqualToDate:other toUnitGranularity:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay];
}

- (BOOL)ch_isQuarterEqualToDate:(NSDate *)other {
    return [self ch_isEqualToDate:other toUnitGranularity:NSCalendarUnitQuarter];
}

- (BOOL)ch_isYearEqualToDate:(NSDate *)other {
    return [self ch_isEqualToDate:other toUnitGranularity:NSCalendarUnitYear];
}

- (BOOL)ch_isMonthEqualToDate:(NSDate *)other {
    return [self ch_isEqualToDate:other toUnitGranularity:NSCalendarUnitMonth];
}

- (BOOL)ch_isWeekdayEqualToDate:(NSDate *)other {
    return [self ch_isEqualToDate:other toUnitGranularity:NSCalendarUnitWeekday];
}

- (BOOL)ch_isDayEqualToDate:(NSDate *)other {
    return [self ch_isEqualToDate:other toUnitGranularity:NSCalendarUnitDay];
}

- (BOOL)ch_isHourEqualToDate:(NSDate *)other {
    return [self ch_isEqualToDate:other toUnitGranularity:NSCalendarUnitHour];
}

- (BOOL)ch_isMinuteEqualToDate:(NSDate *)other {
    return [self ch_isEqualToDate:other toUnitGranularity:NSCalendarUnitMinute];
}

- (BOOL)ch_isSecondEqualToDate:(NSDate *)other {
    return [self ch_isEqualToDate:other toUnitGranularity:NSCalendarUnitSecond];
}

- (BOOL)ch_isNanosecondEqualToDate:(NSDate *)other {
    return [self ch_isEqualToDate:other toUnitGranularity:NSCalendarUnitNanosecond];
}

#pragma mark - Creation
+ (NSDate *)ch_dateYesterday {
    return [[NSDate date] ch_dateByAddingDays:-1];
}

+ (NSDate *)ch_dateTomorrow {
    return [[NSDate date] ch_dateByAddingDays:1];
}

#pragma mark - Modify
- (NSDate *)ch_dateByAddingQuarter:(NSInteger)quarters {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setQuarter:quarters];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)ch_dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)ch_dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)ch_dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)ch_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days; // 86400 = 60 * 60 * 24, timeIntervalSinceReferenceDate -> 以2001/01/01 00:00:00 UTC为基准时间, 返回实例保存的时间与2001/01/01 00:00:00 UTC的时间间隔
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)ch_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)ch_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)ch_dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark - Date Format
- (NSString *)ch_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSString *)ch_stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

- (NSString *)ch_stringWithISOFormat {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]; // Apple suggest
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter stringFromDate:self];
}

- (NSString *)ch_stringForChineseZodiacSign {
    return [[self._ch_localizedChineseZodiacSignStrings ch_objectOrNilAtIndex:self.ch_ChineseZodiacSign] copy];
}

- (NSString *)ch_stringForZodiacSign {
    return [[self._ch_localizedZodiacSignStrings ch_objectOrNilAtIndex:self.ch_zodiacSign] copy];
}

- (NSArray<NSString *> *)_ch_localizedZodiacSignStrings {
    static NSArray *strings = nil;
    static NSDictionary *dic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{
                @"en" : @[@"Aquarius", @"Pisces", @"Aries", @"Taurus", @"Gemini", @"Cancer", @"Leo", @"Virgo", @"Libra", @"Scorpio", @"Sagittarius", @"Capricorn"],
                @"zh" : @[@"水瓶座", @"双鱼座", @"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座"],
                @"zh_CN" : @[@"水瓶座", @"双鱼座", @"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座"],
                @"zh_HK" : @[@"水瓶座", @"雙魚座", @"白羊座", @"金牛座", @"雙子座", @"巨蟹座", @"獅子座", @"處女座", @"天秤座", @"天蝎座", @"射手座", @"魔蝎座"],
                @"zh_TW" : @[@"水瓶座", @"雙魚座", @"白羊座", @"金牛座", @"雙子座", @"巨蟹座", @"獅子座", @"處女座", @"天秤座", @"天蝎座", @"射手座", @"魔蝎座"],
                };
    });
    if (!strings) strings = dic[@"zh"];
    return strings;
}

- (NSArray<NSString *> *)_ch_localizedChineseZodiacSignStrings {
    static NSArray *strings = nil;
    static NSDictionary *dic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{
                @"en" : @[@"Rat", @"Ox", @"Tiger", @"Rabbit", @"Dragon", @"Snake", @"Horse", @"Goat", @"Monkey", @"Rooster", @"Dog", @"Pig"],
                @"zh" : @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪"],
                @"zh_CN" : @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪"],
                @"zh_HK" : @[@"鼠", @"牛", @"虎", @"兔", @"龍", @"蛇", @"馬", @"羊", @"猴", @"雞", @"狗", @"豬"],
                @"zh_TW" : @[@"鼠", @"牛", @"虎", @"兔", @"龍", @"蛇", @"馬", @"羊", @"猴", @"雞", @"狗", @"豬"],
                };
    });
    if (!strings) strings = dic[@"zh"];
    return strings;
}

+ (NSDate *)ch_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)ch_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)ch_dateWithISOFormatString:(NSString *)dateString {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter dateFromString:dateString];
}

@end
