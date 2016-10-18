//
//  RODateRangeFilter.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFilter.h"

/**
 * Date range filter
 */
@interface RODateRangeFilter : NSObject  <ROFilter>

@property (nonatomic, strong) NSArray *fieldValue;

+ (RODateRangeFilter *)create:(NSString *)fieldName minDate:(NSDate *)minDate maxDate:(NSDate *) maxDate;

@end