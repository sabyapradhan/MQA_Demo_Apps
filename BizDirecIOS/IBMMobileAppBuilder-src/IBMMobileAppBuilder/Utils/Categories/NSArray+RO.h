//
//  NSArray+RO.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

/**
 Helper to NSArray
 */
@interface NSArray (RO)

/**
 Return subarray with range
 @param range Range
 @return Return subarray with range
 */
- (NSArray *)ro_subarrayWithRange:(NSRange)range;

/**
 Return shuffled array
 @return Return shuffled array
 */
- (NSArray *)ro_shuffled;

@end
