//
//  NSDate+Utility.h
//  App
//
//  Created by HBLab-NghiaNH on 6/6/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

@interface NSDate (Utility)
#define D_MINUTE                             60
#define D_HOUR                               3600
#define D_DAY                                86400
#define D_WEEK                               604800
#define D_MONTH                              2592000
#define D_YEAR                               31556926
#define COMMON_DATETIME_FORMAT  @"yyyy-MM-dd HH:mm:ss"

+ (NSDate *) ticksToDate:(NSString *) ticks;
// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;
+ (NSTimeInterval) secondsSince1970;
+ (NSTimeInterval) hoursSince1970;
+ (NSDate *) dateFromString:(NSString *) dateStr format:(NSString *) dateFormatStr;
+ (NSString *) dateToString:(NSDate *) date format:(NSString *) dateFormatStr;
+ (NSDate*)localDateFromGlobalTimeString:(NSString*)dateString inFormat:(NSString*)format;
+ (NSDate *)localTimeFromDouble:(double)localDateFromDouble;
+ (NSString*)getDateTimeStringFromDate:(NSDate*)fromDate;
+ (NSString *)getStartDateAndEndDate:(NSString *)dateStart dateEnd:(NSString *)dateEnd;
+ (NSString *)convertDateToDay:(NSString *)date;

+ (NSString *) convertDateToGMT0:(NSString *) dateStr format:(NSString *) dateFormatStr;
+ (NSDate *) dateFromStringLocalTimeZone:(NSString *) dateStr format:(NSString *) dateFormatStr;


- (NSString *)convertDateToJapanShortDateString;
// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isSameDayWithDate:(NSDate *)aDate; // Add by ThaiTB
- (BOOL) isEqualTodateIgnoringMinute: (NSDate *)aDate; // Add by ThaiTB
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;
- (BOOL)isWeekend;
// Adjusting dates
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;
- (NSDate *) dateAtEndOfDay;
- (NSDate *) dateAt1HourLater;
- (NSDate *)dateWithHour:(NSInteger)hour minute:(NSInteger)minute;
- (NSDate *)dateByAddingYear:(NSInteger)year;
- (NSDate *) dateAtEndOfMin;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger) distanceInDaysToDate:(NSDate *)anotherDate;

// Converters
- (NSString*) utcDateTimeString;
- (NSDate*) utcDateTime;
- (NSDate*) localDateTime;
- (NSDate *)firstDayOfMonth;




// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;
@end
