//
//  RODateRangeFilter.m
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "RODateRangeFilter.h"
#import "NSDate+RO.h"

@interface RODateRangeFilter () {
    
    NSDate *dateMin;
    NSDate *dateMax;
    NSString *field;
    
}

@end

@implementation RODateRangeFilter

+ (RODateRangeFilter *)create:(NSString *)fieldName minDate:(NSDate *)minDate maxDate:(NSDate *) maxDate{
    return [[RODateRangeFilter alloc] initWith:fieldName dateMin:minDate dateMax:maxDate];
}

- initWith:(NSString *)fieldName dateMin:(NSDate *)min dateMax:(NSDate *)max{
    self = [super init];
    if(self){
        
        dateMax = max;
        dateMin = min;
        
        field = fieldName;
    }
    return self;
}

- (NSString *) fieldName{
    return field;
}

- (NSArray *)fieldValue {

    return @[dateMin, dateMax];
}

- (NSString *) getQueryString{
    if(dateMin == nil && dateMax == nil)
        return nil;
    
    NSMutableString *res = [NSMutableString stringWithString:@"\""];
    [res appendString:field];
    [res appendString:@"\":{"];
    if(dateMin != nil){
        [res appendString:@"\"$gte\":\""];
        [res appendString: [self formatISODate:dateMin]];
        [res appendString:@"\""];
    }
    if(dateMax != nil){
        if(dateMin != nil){
            [res appendString:@","];
        }
        [res appendString:@"\"$lte\":\""];
        [res appendString:[self formatISODate:dateMax]];
        [res appendString:@"\""];
    }
    [res appendString:@"}"];
    
    return res;
}

- (BOOL) applyFilter:(NSObject *)fieldValue{
    // dates are strings for local datasources
    NSString *theDate = (NSString *) fieldValue;
    NSDate *date = [self dateFromString:theDate];
    
    if (date) {

        if(dateMin != nil) {
            
            NSComparisonResult result = [date compare:dateMin];
            if(result != NSOrderedDescending && result != NSOrderedSame)
                return NO;
        }
        
        if(dateMax != nil) {

            NSComparisonResult result = [date compare:dateMax];
            if(result != NSOrderedAscending && result != NSOrderedSame)
                return NO;
        }
    }
    return YES;
}

- (NSString *)formatISODate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [df stringFromDate:[date dateWithoutTime]];
}

- (NSDate *)dateFromString:(NSString *)dateStr
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *date = [df dateFromString:dateStr];
    return [date dateWithoutTime];
}

@end
