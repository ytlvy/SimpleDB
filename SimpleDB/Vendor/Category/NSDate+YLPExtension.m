//
//  NSDate+YLPExtension.m
//
//  Created by qiuyang on 16/4/5.
//  Copyright © 2016年 peter. All rights reserved.
//

#import "NSDate+YLPExtension.h"

@implementation NSDate (YLPExtension)

- (NSInteger)year {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)month {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)weekday {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday;
}

- (NSInteger)weekOfYear {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self].weekOfYear;
}

- (NSInteger)weekOfMonth {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self].weekOfMonth;
}

- (NSInteger)day {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].day;
}

- (NSInteger)hour {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self].hour;
}

- (NSInteger)minute {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self].minute;
}

- (NSInteger)second {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self].second;
}

- (BOOL)isBeforeYesterday {
    NSDate *today = [NSDate date];
    return [self isBeforeYesterdayWithDate:today];
}

- (BOOL)isYesterday {
    NSDate *today = [NSDate date];
    return [self isYesterdayWithDate:today];
}

- (BOOL)isToday {
    NSDate *today = [NSDate date];
    return [self isTodayWithDate:today];
}

- (BOOL)isTomorrow {
    NSDate *today = [NSDate date];
    return [self isTomorrowWithDate:today];
}

- (BOOL)isAfterTomorrow {
    NSDate *today = [NSDate date];
    return [self isAfterTomorrowWithDate:today];
}

- (BOOL)isCurrentWeek {
//    if (!self.isCurrentYear) return NO;
    NSInteger weekdayOfYear        = self.weekOfYear;
    NSInteger currentWeekdayOfYear = [NSDate date].weekOfYear;
    if (!self.isCurrentYear) {
        
    }
    return weekdayOfYear == currentWeekdayOfYear ? YES : NO;
}

- (BOOL)isCurrentYear {
    NSInteger year = self.year;
    NSInteger currentYear = [NSDate date].year;
    return year == currentYear ? YES : NO;
}

////////////////////////////////////////////////////////////////////////////////////

+ (id)dateWithString:(NSString *)string  format:(NSString *)format {
	if (nil == format) format = @"yyyy-MM-dd HH:mm:ss";
	if (nil == string) return nil;
	NSDateFormatter *df     = [[NSDateFormatter alloc] init];
	[df setDateFormat:format];
	NSDate *result          = [df dateFromString:string];
	return result;
}

+ (id)stringWithDate:(NSDate *)date format:(NSString *)format {
	if (nil == format) format = @"yyyy-MM-dd HH:mm:ss";
	if (nil == date) return nil;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:format];
	NSString *dateStr = [NSString stringWithFormat:@"%@", [df stringForObjectValue:date]];
	return dateStr;
}

+ (id)dayStringWithDate:(NSDate *)date {
	NSDate *todate = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
	NSDateComponents *comps_today= [calendar components:(NSCalendarUnitYear |
														 NSCalendarUnitMonth |
														 NSCalendarUnitDay |
														 NSCalendarUnitWeekday) fromDate:todate];
	
	
	NSDateComponents *comps_other= [calendar components:(NSCalendarUnitYear |
														 NSCalendarUnitMonth |
														 NSCalendarUnitDay |
														 NSCalendarUnitWeekday) fromDate:date];
    
	if (comps_today.year == comps_other.year &&
		comps_today.month == comps_other.month &&
		comps_today.day == comps_other.day) {
		return @"今天";
	} else if (comps_today.year == comps_other.year &&
			  comps_today.month == comps_other.month &&
			  (comps_today.day - comps_other.day) == -1){
		return @"明天";
	} else if (comps_today.year == comps_other.year &&
			  comps_today.month == comps_other.month &&
			  (comps_today.day - comps_other.day) == -2){
		return @"后天";
	}
	return @"";
}

+ (id)weekStringWithDate:(NSDate *)date {
    NSInteger weekday    = [[self class] weekIntegerWithDate:date];
	NSString *result     = nil;
	NSArray * weekArray  = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
	switch (weekday) {
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
			result = [weekArray objectAtIndex:weekday - 1];;
			break;
		default:
			result = @"";
			break;
	}
	return result;
}

+ (NSInteger)weekIntegerWithDate:(NSDate *)date {
    NSInteger weekday    = [[NSDate stringWithDate:date format:@"c"] integerValue];
    return weekday;
}

+ (id)monthStringWithDate:(NSDate *)date {
    NSInteger month    = [[self class] monthIntegerWithDate:date];
	NSString *result   = nil;
	NSArray * monthArray = @[@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月"];
	switch (month) {
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
		case 10:
		case 11:
		case 12:
			result = [monthArray objectAtIndex:month - 1];
			break;
		default:
			result = @"";
			break;
	}
	return result;
}

+ (NSInteger)monthIntegerWithDate:(NSDate *)date {
    NSInteger month    = [[NSDate stringWithDate:date format:@"MM"] integerValue];
    return month;
}

+ (NSDate *)firstDayOfMonthWithDate:(NSDate *)date {
	NSDate * startDate = nil;
	BOOL isOk = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:date];
	NSAssert1(isOk, @"Failed to calculate the first day of the month based on %@", self);
	return startDate;
}

+ (NSDate *)lastDayOfMonthWithDate:(NSDate *)date {
	NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:date];
	dateComponents.day = [NSDate numberDaysOfMonthWithDate:date];
	return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

+ (NSUInteger)weeklyOrdinalityWithDate:(NSDate *)date {
	return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfYear forDate:date];
}

+ (NSUInteger)numberDaysOfMonthWithDate:(NSDate *)date {
	return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+ (NSUInteger)numberWeeksOfMonthWithDate:(NSDate *)date {
	NSUInteger weekday = [NSDate weeklyOrdinalityWithDate:[NSDate firstDayOfMonthWithDate:date]];
	NSUInteger days = [NSDate numberDaysOfMonthWithDate:date];
	NSUInteger weeks = 0;
	if (weekday > 1) {
		weeks += 1;
		days -= (7 - weekday + 1);
	}
	weeks += days / 7;
	weeks += (days % 7 > 0) ? 1 : 0;
	return weeks;
}

+ (NSDate *)dayInNextWithMonth:(NSInteger)month date:(NSDate *)date {
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	dateComponents.month = month;
    NSDate *retDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return retDate;
}

+ (NSDate *)dayInNextWithDay:(NSInteger)day date:(NSDate *)date {
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	dateComponents.day = day;
    NSDate *retDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return retDate;
}

+ (NSDate *)dayInPreMonthWithDate:(NSDate *)date {
	return [NSDate dayInNextWithMonth:-1 date:date];
}

+ (NSDate *)dayInNextMonthWihtDate:(NSDate *)date {
	return [NSDate dayInNextWithMonth:1 date:date];
}

- (BOOL)isBeforeYesterdayWithDate:(NSDate *)date {
	//时间增加  -24小时， 就是前天啦  而后再获得一天的结束
	NSDate *beforeYesterday = [[date dateByAddingTimeInterval:-24 * 3600] dateByBeginDay];
	NSDate *selfDay         = [self dateByBeginDay];
	if ([selfDay timeIntervalSinceDate:beforeYesterday] < 0) {
		return YES;
	}
	return NO;
}

- (BOOL)isYesterdayWithDate:(NSDate *)date {
	NSDate *yesterday       = [[date dateByAddingTimeInterval:-24 * 3600] dateByBeginDay];
	NSDate *selfDay         = [self dateByBeginDay];
	if (fabs([selfDay timeIntervalSinceDate:yesterday]) < 1.0e-1) {
		return YES;
	}
	return NO;
}

- (BOOL)isTodayWithDate:(NSDate *)date {
	NSDate *selfBegin = [self dateByBeginDay];
	NSDate *dateBegin = [date dateByBeginDay];
	if (fabs([selfBegin timeIntervalSinceDate:dateBegin]) < 1.0e-6) {
		return YES;
	}
	return NO;
}

- (BOOL)isTomorrowWithDate:(NSDate *)date {
	NSDate *tomorrow        = [[date dateByAddingTimeInterval:24 * 3600] dateByBeginDay];
	NSDate *selfDay         = [self dateByBeginDay];
	if (fabs([selfDay timeIntervalSinceDate:tomorrow]) < 1.0e-1) {
		return YES;
	}
	return NO;
}

- (BOOL)isAfterTomorrowWithDate:(NSDate *)date {
	NSDate *afterTomorrow   = [[date dateByAddingTimeInterval:24 * 3600] dateByBeginDay];
	NSDate *selfDay         = [self dateByBeginDay];
	if ([selfDay timeIntervalSinceDate:afterTomorrow] > 0) {
		return YES;
	}
	return NO;
}

/**
 * 以下两处获取时间 不必考虑时区问题， 因为使用的是 GMT时区，不存在因时区差异而导致的时间获取不一致。
 */
- (NSDate *)dateByEndDay {
    //iOS 4.1开始  NSDate date  获得的是GMT时间。与北京时间相差8小时
    
	//今天的结束  15：59：59为结束 8小时时区  后面一天开始  也就是 今天的 23:59:59
	unsigned int flags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
	NSDateComponents *parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
	[parts setHour:23];
	[parts setMinute:59];
	[parts setSecond:59];
	return [[NSCalendar currentCalendar] dateFromComponents:parts];
	
}

- (NSDate *)dateByBeginDay {
	//前一天的结束  16:00为结束  8小时时区  今天开始 也就是说 前一天的00:00:00
	unsigned int flags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
	NSDateComponents *parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
	[parts setHour:0];
	[parts setMinute:0];
	[parts setSecond:0];
	return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

+ (NSString *)timeFromTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format {
    if (nil == format) format = @"HH:mm:ss";
    NSTimeInterval formatTimeInterval = timeInterval / 1000;
    NSInteger perMinutes = 60;
    NSInteger perHours   = perMinutes * perMinutes;
    NSInteger hours      = formatTimeInterval / perHours;
    NSInteger minutes    = (formatTimeInterval - hours * perHours) / perMinutes;
    NSInteger seconds    = formatTimeInterval - hours * perHours - minutes * perMinutes;
    if ([format isEqualToString:@"HH:mm:ss"]) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    } else if ([format isEqualToString:@"mm:ss"]) {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    } else if ([format isEqualToString:@"HH:mm"]) {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)hours, (long)minutes];
    }
    return nil;
}

@end
