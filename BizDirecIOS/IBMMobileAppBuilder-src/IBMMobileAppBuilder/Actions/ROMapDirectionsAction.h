//
//  ROMapDirectionsAction.h
//  IBMMobileAppBuilder
//

#import "ROMapAction.h"

/**
 Open map with driving directions between two address
 */
@interface ROMapDirectionsAction : ROMapAction

/**
 Start address
 */
@property (nonatomic, strong) NSString *start;

/**
 End address
 */
@property (nonatomic, strong) NSString *end;

/**
 Constructor with 'start' and 'end' address
 @param start Start address
 @param end End address
 @return Class instance
 */
- (id)initWithStart:(NSString *)start atEnd:(NSString *)end;

/**
 Constructor with destination address
 @param address Destination address
 @return Class instance
 */
- (id)initWithValue:(NSString *)address;

@end
