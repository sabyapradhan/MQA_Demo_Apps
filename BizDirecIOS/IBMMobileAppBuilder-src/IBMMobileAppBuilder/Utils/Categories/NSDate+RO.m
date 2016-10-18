//
//  NSDate+RO.m
//  IBMMobileAppBuilder
//

#import "NSDate+RO.h"
@implementation NSDate (RO)

+ (instancetype)dateWithValue:(NSString *)dateString {
    
    NSDate *date = nil;
    NSArray *formats = [NSDate formats];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    for (NSString *format in formats) {
        [formatter setDateFormat:format];
        if ([formatter dateFromString:dateString]) {
            date = [formatter dateFromString:dateString];
            break;
        }
    }
    if (!date && ![[[NSLocale currentLocale] localeIdentifier] isEqualToString:@"en_US"]) {
        NSLocale *en = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        [formatter setLocale:en];
        for (NSString *format in formats) {
            [formatter setDateFormat:format];
            if ([formatter dateFromString:dateString]) {
                date = [formatter dateFromString:dateString];
                break;
            }
        }
    }
    return date;
}

- (NSString *)stringValue {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formatter stringFromDate:self];
}

- (NSString *)shortValue
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formatter stringFromDate:self];
}

- (NSString *)mediumValue {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formatter stringFromDate:self];
}

+ (NSArray *)formats {
    
    return @[
             @"yyyy-MM-dd'T'HH:mm:ss'Z'",
             @"yyyy-MM-dd'T'HH:mm:ss.SSSZ",
             @"yyyy-MM-dd'T'HH:mm:ss.sss'Z'",
             @"yyyy-MM-dd'T'HH:mm:ss",
             @"yyyy-MM-dd HH:mm:ss.S z",
             @"yyyy-MM-dd HH:mm:ss z",
             @"yyyy-MM-dd z",
             @"yyyy-MM-dd",
             @"mm/dd/yy",
             @"dd/mm/yy",
             @"EEEE, dd MMMM yyyy HH:mm:ss",
             @"EEE, dd MMM yyyy HH:mm:ss zzz",
             @"EEE, dd MMM yyyy HH:mm:ss ZZZ",
             @"EEE, dd MMM yyyy HH:mm:ss Z",
             @"EEE, dd MMM yyyy HH:mm:ss z"
             ];
}

- (NSDate *)dateWithoutTime {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    
    NSDateComponents *dateComponents = [calendar components:comps
                                                   fromDate:self];
    return [calendar dateFromComponents:dateComponents];
}

- (NSString *)ro_timeStringValue {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)ro_datetimeStringValue {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)ro_stringWithFormat:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter dateFromString:format];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [dateFormatter stringFromDate:self];
}

@end