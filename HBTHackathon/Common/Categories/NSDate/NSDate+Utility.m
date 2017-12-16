//
//  NSDate+Utility.m
//  App
//
//  Created by HBLab-NghiaNH on 6/6/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]


//MilliSeconds = (Ticks - 621355968000000000) / 10000
+ (NSDate *)ticksToDate:(NSString *) ticks
{
    if (!ticks) {
        return nil;
    }
    double tickFactor = 10000000;
    double ticksDoubleValue = [ticks doubleValue];
    double seconds = ((ticksDoubleValue - 621355968000000000)/ tickFactor);
    NSDate *returnDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    return returnDate;
}

#pragma mark Relative Dates
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSTimeInterval) secondsSince1970 {
    NSTimeInterval t = round([[NSDate date] timeIntervalSince1970]);
    return t;
}

+ (NSTimeInterval) hoursSince1970 {
    return round([self secondsSince1970] / 3600);
}

+ (NSDate *) dateFromString:(NSString *) dateStr format:(NSString *) dateFormatStr {
    NSDateFormatter* dtFormatter = [NSDateFormatter sharedInstance];
    [dtFormatter setDateFormat:dateFormatStr];
    NSDate* dateOutput = [dtFormatter dateFromString:dateStr];
    
    return dateOutput;
}

+ (NSString *) dateToString:(NSDate *) date format:(NSString *) dateFormatStr {
    if ([date isKindOfClass:[NSDate class]]) {
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:dateFormatStr];
        return [dateFormater stringFromDate:date];
    }
    return nil;
}

+ (NSString *) convertDateToGMT0:(NSString *)dateStr format:(NSString *) dateFormatStr {
    NSDateFormatter* dtFormatter = [NSDateFormatter sharedInstance];
    [dtFormatter setDateFormat:dateFormatStr];
    NSDate* dateOutput = [dtFormatter dateFromString:dateStr];
    
    NSDateFormatter* dt = [NSDateFormatter sharedInstance];
    [dt setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dt setDateFormat:dateFormatStr];
    
    return [dt stringFromDate:dateOutput];
}

+ (NSDate *) dateFromStringLocalTimeZone:(NSString *) dateStr format:(NSString *) dateFormatStr {
    NSDateFormatter* dtFormatter = [NSDateFormatter sharedInstance];
    [dtFormatter setDateFormat:dateFormatStr];
    [dtFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate* dateOutput = [dtFormatter dateFromString:dateStr];
    
    return dateOutput;
}

+ (NSString *)dateFromLong:(long long)dateLong format:(NSString *)dateFormatStr {
    NSTimeInterval seconds = dateLong / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSLog(@"ans date : %@",date);
    
    return @"";
}

// format: date format string, don't allow string which defining timezone (suffix with " Z")
+ (NSDate *)localDateFromGlobalTimeString:(NSString*)dateString inFormat:(NSString*)format {
    if (dateString.length > 0) {
        NSDateFormatter* formatter = [NSDateFormatter sharedInstance];
        [formatter setDateFormat:format];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale: usLocale];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]]; // GMT, not GMT+7
        return [formatter dateFromString:dateString];
    } else {
        return nil;
    }
}
+ (NSDate *)localTimeFromDouble:(double)localDateFromDouble{
    NSDate *localTime = [NSDate dateWithTimeIntervalSince1970:localDateFromDouble];
    NSString *stringFromDate = [NSDate dateToString:localTime format:@"yyyyMMddHHmmss"];
    localTime = [NSDate localDateFromGlobalTimeString:stringFromDate inFormat:@"yyyyMMddHHmmss"];
    return localTime;
}

+ (NSString*)getDateTimeStringFromDate:(NSDate*)fromDate{
    NSDate *toDate = [[NSDate alloc] init];
    toDate = [NSDate date];
    NSString * timeString = @"";
    
    long totals  = (long)[toDate timeIntervalSinceDate:fromDate];
    int minute = 60;
    int hour = 3600;
    int day = 86400;
    long year = 31536000 ;
    
    if ( totals / year > 0 ) {
        timeString = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)fromDate.year, (long)fromDate.month, (long)fromDate.day];
    } else if ( totals / hour > 0 && (toDate.day - (totals/day)) > (toDate.day - 1) ) {
        timeString = [NSString stringWithFormat:NSLocalizedString(@"%d 時間前", @""), totals / hour];
    } else if ( totals / minute > 0 && (toDate.hour - (totals/hour)) > (toDate.hour - 1)) {
        timeString = [NSString stringWithFormat:NSLocalizedString(@"%d 分前", @""), totals / minute];
    } else if ((toDate.hour - (totals/hour)) < 0 && (toDate.hour - (totals/hour)) > -24) {
        timeString = [NSString stringWithFormat:@"昨日 %ld:%02ld", (long)fromDate.hour, (long)fromDate.minute ];
    } else if ((toDate.hour - (totals/hour)) < -24 && (toDate.year - (totals/year)) > (toDate.year - 1)) {
        timeString = [NSString stringWithFormat:@"%ld月%ld日 %ld:%02ld", (long)fromDate.month, (long)fromDate.day, (long)fromDate.hour, (long)fromDate.minute];
    } else if(totals/minute < 1) {
        timeString = @"たった今";
    }
    
    return timeString;
}

+ (NSString *)convertDateToDay:(NSString *)date {
    if (date == nil || [date isEqualToString:@""]) {
        return @"";
    }
    
    NSDateFormatter *dtF = [NSDateFormatter sharedInstance];
    [dtF setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [dtF dateFromString:date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:d];
    NSInteger weekday = [comps weekday];
    
    NSString *day = [[NSString alloc] init];
    
    switch (weekday) {
        case 1:
            day = [NSString stringWithFormat:@"日"];
            break;
        case 2:
            day = [NSString stringWithFormat:@"月"];
            break;
        case 3:
            day = [NSString stringWithFormat:@"火"];
            break;
        case 4:
            day = [NSString stringWithFormat:@"水"];
            break;
        case 5:
            day = [NSString stringWithFormat:@"木"];
            break;
        case 6:
            day = [NSString stringWithFormat:@"金"];
            break;
        case 7:
            day = [NSString stringWithFormat:@"土"];
        default:
            break;
    }
    
    return day;
}

- (NSString *)convertDateToJapanShortDateString {
    if (!self) {
        return @"";
    }
    NSString *resultStr = @"";
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:self];
    NSInteger weekday = [comps weekday];
    NSString *todayDateStr = [NSDate dateToString:self format:@"MM月dd日"];
    NSString *day = [[NSString alloc] init];
    
    switch (weekday) {
        case 1:
            day = [NSString stringWithFormat:@"日"];
            break;
        case 2:
            day = [NSString stringWithFormat:@"月"];
            break;
        case 3:
            day = [NSString stringWithFormat:@"火"];
            break;
        case 4:
            day = [NSString stringWithFormat:@"水"];
            break;
        case 5:
            day = [NSString stringWithFormat:@"木"];
            break;
        case 6:
            day = [NSString stringWithFormat:@"金"];
            break;
        case 7:
            day = [NSString stringWithFormat:@"土"];
        default:
            break;
    }
    if (todayDateStr.length > 0 && day.length > 0) {
        resultStr = [NSString stringWithFormat:@"%@(%@)", todayDateStr, day];
    }
    
    return resultStr;
}

//get weekday start date- end date
+ (NSString *)getStartDateAndEndDate:(NSString *)dateStart dateEnd:(NSString *)dateEnd {
    //===set date====
    NSArray * startDateArray = [dateStart componentsSeparatedByString:@" "];
    NSString *startDate = [startDateArray objectAtIndex:0];
    NSArray * endDateArray = [dateEnd componentsSeparatedByString:@" "];
    NSString *endDate = [endDateArray objectAtIndex:0];
    
    NSString *dayStart = [self convertDateToDay:dateStart];
    NSString *dayEnd = [self convertDateToDay:dateEnd];
    
    //set date start - date end
    return [NSString stringWithFormat:@"%@ (%@) 〜%@ (%@）", startDate, dayStart, endDate, dayEnd];
}



//End
#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL) isSameDayWithDate:(NSDate *)aDate{ // Add by ThaiTB
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:aDate];
    
    return [comp1 day] == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

- (BOOL) isEqualTodateIgnoringMinute: (NSDate *)aDate { // Add by ThaiTB
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitYear;
    
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:aDate];
    
    return [comp1 year]  == [comp2 year]
    && [comp1 month] == [comp2 month]
    && [comp1 day] == [comp2 day]
    && [comp1 hour] == [comp2 hour];
}

- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfMonth != components2.weekOfMonth) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
    // Thanks, baspellis
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL)isWeekend {
    return [CURRENT_CALENDAR isDateInWeekend:self];
}

- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark Adjusting Dates

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateAtEndOfMin
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = self.hour;
    components.minute = self.minute;
    components.second = 59;
    return [CURRENT_CALENDAR dateFromComponents:components];
}
// Add by NghiaNH
- (NSDate *) dateAtEndOfDay
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateAt1HourLater {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = self.hour +1;
    components.minute = 00;
    components.second = 00;
    return [CURRENT_CALENDAR dateFromComponents:components];
    
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
    return dTime;
}

- (NSDate *)dateWithHour:(NSInteger)hour minute:(NSInteger)minute {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = hour;
    components.minute = minute;
    components.second = 00;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)dateByAddingYear:(NSInteger)year {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.year += year;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

- (NSString *) utcDateTimeString{
    NSDateFormatter *dateFormatter = [NSDateFormatter sharedInstance];
    [dateFormatter setDateFormat:COMMON_DATETIME_FORMAT];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [dateFormatter stringFromDate:self];
}

- (NSDate *) utcDateTime{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

// Convert current UTC date to Local date
- (NSDate *)localDateTime{
    NSDateFormatter *localDateFormatter = [NSDateFormatter sharedInstance];
    [localDateFormatter setDateFormat:COMMON_DATETIME_FORMAT];
    [localDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateFormatter *utcDateFormatter = [NSDateFormatter sharedInstance];
    [utcDateFormatter setDateFormat:COMMON_DATETIME_FORMAT];
    [utcDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate* utcDate = [utcDateFormatter dateFromString:[self description]];
    NSDate* localDate = [localDateFormatter dateFromString:[localDateFormatter stringFromDate:utcDate]];
    return localDate;
}


// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark Decomposing Dates

- (NSInteger) nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger) hour
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

- (NSInteger) minute
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

- (NSInteger) seconds
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

- (NSInteger) day
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger) month
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger) week
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekOfMonth;
}

- (NSInteger) weekday
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger) year
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    
    return components.year;
}

- (NSDate *)firstDayOfMonth {
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    [components setDay:1];
    return [CURRENT_CALENDAR dateFromComponents:components];
}
@end
