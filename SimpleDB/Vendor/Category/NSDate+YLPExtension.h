//
//  NSDate+YLPExtension.h
//
//  Created by qiuyang on 16/4/5.
//  Copyright © 2016年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YLPExtension)

@property (nonatomic, readonly, assign) NSInteger year;
@property (nonatomic, readonly, assign) NSInteger month;
@property (nonatomic, readonly, assign) NSInteger weekday;
@property (nonatomic, readonly, assign) NSInteger weekOfYear;
@property (nonatomic, readonly, assign) NSInteger weekOfMonth;
@property (nonatomic, readonly, assign) NSInteger day;
@property (nonatomic, readonly, assign) NSInteger hour;
@property (nonatomic, readonly, assign) NSInteger minute;
@property (nonatomic, readonly, assign) NSInteger second;

/**
 *  确定  前天  昨天  明天  后天  （与当前时间进行比较）
 *  确定  前天  昨天  明天  后天  （与制定date进行比较）
 */
@property (nonatomic, readonly, assign) BOOL isBeforeYesterday;
@property (nonatomic, readonly, assign) BOOL isYesterday;
@property (nonatomic, readonly, assign) BOOL isToday;
@property (nonatomic, readonly, assign) BOOL isTomorrow;
@property (nonatomic, readonly, assign) BOOL isAfterTomorrow;
@property (nonatomic, readonly, assign) BOOL isCurrentWeek;
@property (nonatomic, readonly, assign) BOOL isCurrentYear;

/**
 *  NSString -> NSDate
 */
+ (id)dateWithString:(NSString *)string  format:(NSString *)format;

/**
 *  NSDate -> NSString
 */
+ (id)stringWithDate:(NSDate *)date format:(NSString *)format;

/**
 *  今天 明天 后天
 */
+ (id)dayStringWithDate:(NSDate *)date;

/**
 *  星期几
 */
+ (id)weekStringWithDate:(NSDate *)date;
+ (NSInteger)weekIntegerWithDate:(NSDate *)date;

/**
 *  几月
 */
+ (id)monthStringWithDate:(NSDate *)date;
+ (NSInteger)monthIntegerWithDate:(NSDate *)date;

/**
 *  计算这个月最开始的一天
 */
+ (NSDate *)firstDayOfMonthWithDate:(NSDate *)date;

/**
 *  计算这个月最后的一天
 */
+ (NSDate *)lastDayOfMonthWithDate:(NSDate *)date;

/**
 *  计算这个月的第一天是周几
 */
+ (NSUInteger)weeklyOrdinalityWithDate:(NSDate *)date;

/**
 *  这个月有多少天
 */
+ (NSUInteger)numberDaysOfMonthWithDate:(NSDate *)date;

/**
 *  这个月有多少周
 */
+ (NSUInteger)numberWeeksOfMonthWithDate:(NSDate *)date;

/**
 *  当前日期之后的几个月
 */
+ (NSDate *)dayInNextWithMonth:(NSInteger)month date:(NSDate *)date;

/**
 *  当前日期之后的几天
 */
+ (NSDate *)dayInNextWithDay:(NSInteger)day date:(NSDate *)date;

/**
 *  上个月
 */
+ (NSDate *)dayInPreMonthWithDate:(NSDate *)date;

/**
 *  下个月
 */
+ (NSDate *)dayInNextMonthWihtDate:(NSDate *)date;

- (BOOL)isBeforeYesterdayWithDate:(NSDate *)date;
- (BOOL)isYesterdayWithDate:(NSDate *)date;
- (BOOL)isTodayWithDate:(NSDate *)date;
- (BOOL)isTomorrowWithDate:(NSDate *)date;
- (BOOL)isAfterTomorrowWithDate:(NSDate *)date;

- (NSDate *)dateByEndDay;
- (NSDate *)dateByBeginDay;

/**
 *  时间戳转时间
 *
 *  @param timeInterval 时间戳，毫秒
 *  @param format       返回格式 HH:mm:ss
 *
 *  @return 返回格式如：00:00:00
 */
+ (NSString *)timeFromTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format;

@end
