//
//  NSDate+BTDAdditions.m
//  ByteDanceKit
//
//  Created by wangdi on 2018/2/27.
//

#import "NSDate+BTDAdditions.h"
#import <sys/sysctl.h>
#import <mach/mach_time.h>

static BOOL _btd_optimizeDateFormatterEnabled = YES;

@implementation NSDate (BTDAdditions)

- (NSInteger)btd_year
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)btd_month
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)btd_day
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)btd_weekday
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)btd_hour
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)btd_minute
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)btd_second
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (BOOL)btd_isSameDay:(NSDate *)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

- (BOOL)btd_isEarlierThanDate:(NSDate *)anotherDate {
    return ([self compare:anotherDate] == NSOrderedAscending);

}

- (BOOL)btd_isLaterThanDate:(NSDate *)anotherDate {
    return ([self compare:anotherDate] == NSOrderedDescending);
}

- (NSDate *)btd_dateByAddingYears:(NSInteger)years
{
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)btd_dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)btd_dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)btd_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)btd_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)btd_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)btd_dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (time_t)btd_uptime
{
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    (void)time(&now);
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0){
        uptime = now - boottime.tv_sec;
    }
    return uptime;
}

- (NSString *)btd_stringWithFormat:(NSString *)format
{
    return [self btd_stringWithFormat:format timeZone:nil locale:[NSLocale currentLocale]];
}

- (NSString *)btd_stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = NSDate.btd_optimizeDateFormatterEnabled && [NSThread isMainThread] ? _DateFormatterForMainThread() : [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

+ (NSDate *)btd_dateWithString:(NSString *)dateString format:(NSString *)format
{
    return [self btd_dateWithString:dateString format:format timeZone:nil locale:nil];
}

+ (NSDate *)btd_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = NSDate.btd_optimizeDateFormatterEnabled && [NSThread isMainThread] ? _DateFormatterForMainThread() : [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (nullable NSDate *)btd_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSString *formatString = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:%02ld",year,month,day,hour,minute,second];
    return [self btd_dateWithString:dateString format:formatString];
}

+ (NSUInteger)btd_daysInMonth:(NSInteger)month year:(NSInteger)year
{
    NSDate *date = [self btd_dateWithYear:year month:month day:1 hour:0 minute:0 second:0];
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

static NSDateFormatter *_DateFormatterForMainThread() {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
    }
    return formatter;
}

static NSDateFormatter *_ISO8601DateFormatter() {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return formatter;
}

- (NSString *)btd_ISO8601FormatedString {
    return [_ISO8601DateFormatter() stringFromDate:self];
}

+ (NSDate *)btd_dateWithISO8601FormatedString:(NSString *)dateString {
    if (dateString.length) {
        return [_ISO8601DateFormatter() dateFromString:dateString];
    }
    return nil;
}

+ (BOOL)btd_optimizeDateFormatterEnabled {
    return _btd_optimizeDateFormatterEnabled;
}

+ (void)setBtd_optimizeDateFormatterEnabled:(BOOL)btd_optimizeDateFormatterEnabled {
    _btd_optimizeDateFormatterEnabled = btd_optimizeDateFormatterEnabled;
}

@end

uint64_t BTDCurrentMachTime() {
    return mach_absolute_time();
}

double BTDMachTimeToSecs(uint64_t time) {
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /
    (double)timebase.denom / NSEC_PER_SEC;
}
