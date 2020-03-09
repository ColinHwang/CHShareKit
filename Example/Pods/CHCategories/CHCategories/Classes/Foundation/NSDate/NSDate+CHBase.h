//
//  NSDate+CHBase.h
//  CHCategories
//
//  Created by CHwang 17/1/4.
//  Base

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CHNSDateAstrologyZodiacSign) { /// 星座类型
    CHNSDateAstrologyZodiacSignAquarius = 0,              ///< [1-20, 2-18] 水瓶座
    CHNSDateAstrologyZodiacSignPisces,                    ///< [2-19, 3-20] 双鱼座
    CHNSDateAstrologyZodiacSignAries,                     ///< [3-21, 4-19] 白羊座
    CHNSDateAstrologyZodiacSignTaurus,                    ///< [4-20, 5-20] 金牛座
    CHNSDateAstrologyZodiacSignGemini,                    ///< [5-21, 6-20] 双子座
    CHNSDateAstrologyZodiacSignCancer,                    ///< [6-21, 7-22] 巨蟹座
    CHNSDateAstrologyZodiacSignLeo,                       ///< [7-23, 8-22] 狮子座
    CHNSDateAstrologyZodiacSignVirgo,                     ///< [8-23, 9-22] 处女座
    CHNSDateAstrologyZodiacSignLibra,                     ///< [9-23, 10-22] 天秤座
    CHNSDateAstrologyZodiacSignScorpio,                   ///< [10-22, 11-21] 天蝎座
    CHNSDateAstrologyZodiacSignSagittarius,               ///< [11-22, 12-21] 射手座
    CHNSDateAstrologyZodiacSignCapricorn                  ///< [12-22, 1-19] 摩羯座
};

typedef NS_ENUM(NSInteger, CHNSDateAstrologyChineseZodiacSign) { ///< 农历属相类型
    CHNSDateAstrologyChineseZodiacSignRat = 0,                   ///< 鼠(子)
    CHNSDateAstrologyChineseZodiacSignOx,                        ///< 牛(丑)
    CHNSDateAstrologyChineseZodiacSignTiger,                     ///< 虎(寅)
    CHNSDateAstrologyChineseZodiacSignRabbit,                    ///< 兔(卯)
    CHNSDateAstrologyChineseZodiacSignDragon,                    ///< 龙(辰)
    CHNSDateAstrologyChineseZodiacSignSnake,                     ///< 蛇(巳)
    CHNSDateAstrologyChineseZodiacSignHorse,                     ///< 马(午)
    CHNSDateAstrologyChineseZodiacSignGoat,                      ///< 羊(未)
    CHNSDateAstrologyChineseZodiacSignMonkey,                    ///< 猴(申)
    CHNSDateAstrologyChineseZodiacSignRooster,                   ///< 鸡(酉)
    CHNSDateAstrologyChineseZodiacSignDog,                       ///< 狗(戌)
    CHNSDateAstrologyChineseZodiacSignPig                        ///< 猪(亥)
};

@interface NSDate (CHBase)

#pragma mark- Base
@property (nonatomic, readonly) NSInteger ch_era;               ///< 纪元
@property (nonatomic, readonly) NSInteger ch_year;              ///< 年
@property (nonatomic, readonly) NSInteger ch_month;             ///< 月(1~12)
@property (nonatomic, readonly) NSInteger ch_day;               ///< 日(1~31)
@property (nonatomic, readonly) NSInteger ch_hour;              ///< 时(0~23)
@property (nonatomic, readonly) NSInteger ch_minute;            ///< 分(0~59)
@property (nonatomic, readonly) NSInteger ch_second;            ///< 秒(0~59)
@property (nonatomic, readonly) NSInteger ch_nanosecond;        ///< 毫微秒(0~10^10-1)
@property (nonatomic, readonly) NSInteger ch_weekday;           ///< 日期的星期(1~7, 周日为1)
@property (nonatomic, readonly) NSInteger ch_weekdayOrdinal;    ///< 日期是本月的第几个星期几
@property (nonatomic, readonly) NSInteger ch_weekOfMonth;       ///< 日期是本月的第几周(一般周日为星期首日)
@property (nonatomic, readonly) NSInteger ch_weekOfYear;        ///< 日期是本年的第几周(1~53)
@property (nonatomic, readonly) NSInteger ch_yearForWeekOfYear; ///< 日期的weekOfYear中所属的年(ISO Week)
@property (nonatomic, readonly) NSInteger ch_quarter;           ///< 季度

#pragma mark - Time Interval
@property (nonatomic, readonly) NSInteger ch_timeIntervalSince1970; ///< 获取时间戳(单位为毫秒)

#pragma mark - Zodiac Sign
@property (nonatomic, readonly) CHNSDateAstrologyChineseZodiacSign ch_ChineseZodiacSign; ///< 属相
@property (nonatomic, readonly) CHNSDateAstrologyZodiacSign ch_zodiacSign; ///< 星座

#pragma mark - Comparison
@property (nonatomic, readonly) BOOL ch_isLeapYear;              ///< 日期是否为闰年
@property (nonatomic, readonly) BOOL ch_isLastYearLeapYear;      ///< 日期上一年是否为闰年
@property (nonatomic, readonly) BOOL ch_isNextYearLeapYear;      ///< 日期下一年是否为闰年

@property (nonatomic, readonly) BOOL ch_isLeapMonth;             ///< 日期是否为闰月
@property (nonatomic, readonly) BOOL ch_isLastMonthLeapMonth;    ///< 日期上个月否为闰月
@property (nonatomic, readonly) BOOL ch_isNextMonthLeapMonth;    ///< 日期下个月否为闰月

@property (nonatomic, readonly) BOOL ch_isThisYear;              ///< 日期是否今年
@property (nonatomic, readonly) BOOL ch_isLastYear;              ///< 日期是否去年
@property (nonatomic, readonly) BOOL ch_isNextYear;              ///< 日期是否明年

@property (nonatomic, readonly) BOOL ch_isThisMonth;             ///< 日期是否本月
@property (nonatomic, readonly) BOOL ch_isLastMonth;             ///< 日期是否上个月
@property (nonatomic, readonly) BOOL ch_isNextMonth;             ///< 日期是否下个月

@property (nonatomic, readonly) BOOL ch_isThisWeek;              ///< 日期是否这个星期
@property (nonatomic, readonly) BOOL ch_isLastWeek;              ///< 日期是否上个星期
@property (nonatomic, readonly) BOOL ch_isNextWeek;              ///< 日期是否下个星期

@property (nonatomic, readonly) BOOL ch_isToday;                 ///< 日期是否今天(由日期使用locale决定)
@property (nonatomic, readonly) BOOL ch_isYesterday;             ///< 日期是否昨天(由日期使用locale决定)
@property (nonatomic, readonly) BOOL ch_isTomorrow;              ///< 日期是否明天(由日期使用locale决定)
@property (nonatomic, readonly) BOOL ch_isTheDayBeforeYesterday; ///< 日期是否前天(由日期使用locale决定)
@property (nonatomic, readonly) BOOL ch_isTheDayAfterTomorrow;   ///< 日期是否后天(由日期使用locale决定)

@property (nonatomic, readonly) BOOL ch_isThisHour;              ///< 日期是否当前小时内
@property (nonatomic, readonly) BOOL ch_isLastHour;              ///< 日期是否上个小时内
@property (nonatomic, readonly) BOOL ch_isNextHour;              ///< 日期是否下个小时内

@property (nonatomic, readonly) BOOL ch_isThisMinute;            ///< 日期是否当前分钟内
@property (nonatomic, readonly) BOOL ch_isLastMinute;            ///< 日期是否上个分钟内
@property (nonatomic, readonly) BOOL ch_isNextMinute;            ///< 日期是否下个分钟内

@property (nonatomic, readonly) BOOL ch_isThisSecond;            ///< 日期是否当前秒内
@property (nonatomic, readonly) BOOL ch_isLastSecond;            ///< 日期是否上个秒内
@property (nonatomic, readonly) BOOL ch_isNextSecond;            ///< 日期是否下个秒内

/**
 日期是否在指定日期前
 
 @param date 指定日期
 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isEarlierThanDate:(NSDate *)date;

/**
 日期是否在指定日期后
 
 @param date 指定日期
 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isLaterThanDate:(NSDate *)date;

/**
 日期是否在两个日期之间
 
 @param startDate 开始日期
 @param endDate 结束日期
 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isDateBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

/**
 日期是否在当前日期前
 
 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isInPast;

/**
 日期是否在当前日期后
 
 @return 是返回YES, 否则返回NO
 */
- (BOOL)ch_isInFuture;

#pragma mark - Equal
/**
 根据日期匹配项, 判断日期是否与指定日期相等(简单匹配)

 @param other 指定日期
 @param unit  日期匹配项
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isEqualToDate:(NSDate *)other toUnitGranularity:(NSCalendarUnit)unit;

/**
 日期是否与指定日期相等, 忽略时间(时、分、秒等)

 @param other 指定日期
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isEqualToDateIgnoringTime:(NSDate *)other;

/**
 日期的季度是否与指定日期相等
 
 @param other 指定日期
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isQuarterEqualToDate:(NSDate *)other;

/**
 日期的年是否与指定日期相等

 @param other 指定日期
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isYearEqualToDate:(NSDate *)other;

/**
 日期的月是否与指定日期相等

 @param other 指定日期
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isMonthEqualToDate:(NSDate *)other;

/**
 日期的星期是否与指定日期相等
 
 @param other 指定日期
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isWeekdayEqualToDate:(NSDate *)other;

/**
 日期的日是否与指定日期相等

 @param other 指定日期
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isDayEqualToDate:(NSDate *)other;

/**
 日期的时是否与指定日期相等

 @param other 指定日期
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isHourEqualToDate:(NSDate *)other;

/**
 日期的分是否与指定日期相等

 @param other 指定日期
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isMinuteEqualToDate:(NSDate *)other;

/**
 日期的秒是否与指定日期相等

 @param other 指定日期
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isSecondEqualToDate:(NSDate *)other;

/**
 日期的毫微秒是否与指定日期相等

 @param other 指定日期
 @return 相等返回YES, 否则返回NO
 */
- (BOOL)ch_isNanosecondEqualToDate:(NSDate *)other;

#pragma mark - Creation
/**
 根据当前日期, 创建昨天的日期

 @return 昨天的日期
 */
+ (NSDate *)ch_dateYesterday;

/**
 根据当前日期, 创建明天的日期

 @return 明天的日期
 */
+ (NSDate *)ch_dateTomorrow;

#pragma mark - Modify
/**
 获取日期增加指定季度数后的新日期

 @param quarters 指定季度数
 @return 新日期
 */
- (NSDate *)ch_dateByAddingQuarter:(NSInteger)quarters;

/**
 获取日期增加指定年数后的新日期

 @param years 指定年数
 @return 新日期
 */
- (NSDate *)ch_dateByAddingYears:(NSInteger)years;

/**
 获取日期增加指定月数后的新日期

 @param months 指定月数
 @return 新日期
 */
- (NSDate *)ch_dateByAddingMonths:(NSInteger)months;

/**
 获取日期增加指定周数后的新日期

 @param weeks 指定周数
 @return 新日期
 */
- (NSDate *)ch_dateByAddingWeeks:(NSInteger)weeks;

/**
 获取日期增加指定天数后的新日期

 @param days 指定天数
 @return 新日期
 */
- (NSDate *)ch_dateByAddingDays:(NSInteger)days;

/**
 获取日期增加指定小时数后的新日期

 @param hours 指定小时数
 @return 新日期
 */
- (NSDate *)ch_dateByAddingHours:(NSInteger)hours;

/**
 获取日期增加指定分钟数后的新日期

 @param minutes 指定分钟数
 @return 新日期
 */
- (NSDate *)ch_dateByAddingMinutes:(NSInteger)minutes;

/**
 获取日期增加指定秒数后的新日期

 @param seconds 指定秒数
 @return 新日期
 */
- (NSDate *)ch_dateByAddingSeconds:(NSInteger)seconds;

#pragma mark - Date Format
/**
 根据日期格式字符串, 获取日期字符串
 
 @param format 日期格式字符串(@"yyyy-MM-dd HH:mm:ss"...)
 @return 日期字符串
 */
- (NSString *)ch_stringWithFormat:(NSString *)format;

/**
 根据日期格式字符串、目标时区和目标local, 获取日期字符串
 
 @param format 日期格式字符串(@"yyyy-MM-dd HH:mm:ss"...)
 @param timeZone 目标时区
 @param locale 目标local
 @return 日期字符串
 */
- (NSString *)ch_stringWithFormat:(NSString *)format
                         timeZone:(NSTimeZone *)timeZone
                           locale:(NSLocale *)locale;

/**
 根据ISO8601日期格式("2010-07-09T16:13:30+12:00"), 获取日期字符串
 
 @return 日期字符串
 */
- (NSString *)ch_stringWithISOFormat;

/**
 获取日期的属相字符(鼠)

 @return 属相字符(鼠)
 */
- (NSString *)ch_stringForChineseZodiacSign;

/**
 获取日期的星座字符(射手座)

 @return 星座字符(射手座)
 */
- (NSString *)ch_stringForZodiacSign; 

/**
 根据日期字符串和日期格式字符串, 获取日期
 
 @param dateString 日期字符串
 @param format     日期格式字符串(@"yyyy-MM-dd HH:mm:ss"...)
 @return 日期
 */
+ (NSDate *)ch_dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 根据日期字符串、日期格式字符串、目标时区和目标local, 获取日期
 
 @param dateString 日期字符串
 @param format     日期格式字符串(@"yyyy-MM-dd HH:mm:ss"...)
 @param timeZone   目标时区
 @param locale     目标local
 @return 日期
 */
+ (NSDate *)ch_dateWithString:(NSString *)dateString
                       format:(NSString *)format
                     timeZone:(NSTimeZone *)timeZone
                       locale:(NSLocale *)locale;

/**
 根据ISO8601日期格式的日期字符串(@"2010-07-09T16:13:30+08:00"), 获取日期
 
 @param dateString ISO8601日期格式的日期字符串(@"2010-07-09T16:13:30+08:00")
 @return 日期
 */
+ (NSDate *)ch_dateWithISOFormatString:(NSString *)dateString;

@end

NS_ASSUME_NONNULL_END
