//
//  NSDate+RO.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

/**
 Helper to NSDate
 */
@interface NSDate (RO)

/**
 Constructor with date string (several formats)
 @param dateString Date string
 @return Class instance
 */
+ (instancetype)dateWithValue:(NSString *)dateString;

/**
 Full style date representation
 @return Date string value
 */
- (NSString *)stringValue;

/**
 Short style date representation without timezone
 @return Date string value
 */
- (NSString *)shortValue;

/**
 Medium style date representation without timezone
 @return Date string value
 */
- (NSString *)mediumValue;

/**
 All formats allowed
 @return Format allowed
 */
+ (NSArray *)formats;

/**
 Remove time from date
 @return Date without time
 */
- (NSDate *)dateWithoutTime;

/**
 @return time string value from date
 */
- (NSString *)ro_timeStringValue;

/**
 @return date time string value from date
 */
- (NSString *)ro_datetimeStringValue;

/**
 @param format Date format
 @return Date string value
 */
- (NSString *)ro_stringWithFormat:(NSString *)format;

@end