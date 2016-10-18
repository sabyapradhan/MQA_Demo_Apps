//
//  NSDictionary+RO.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RO)

- (NSString *)ro_stringForKey:(id)key;

- (NSNumber *)ro_numberForKey:(id)key;

- (NSNumber *)ro_numberForKey:(id)key format:(NSNumberFormatter *)format;

- (double)ro_doubleForKey:(id)key;

- (NSDate *)ro_dateForKey:(id)key;

- (NSDate *)ro_dateForKey:(id)key format:(NSString *)format;

@end
