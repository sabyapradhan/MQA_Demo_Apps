//
//  ROMapSearchBehavior.h
//  IBMMobileAppBuilder
//

#import "ROSearchBehavior.h"

@class RONearFilter;

@interface ROMapSearchBehavior : ROSearchBehavior

- (RONearFilter *)nearFilterWithFieldName:(NSString *)fieldName;

@end
