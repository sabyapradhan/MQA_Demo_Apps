//
//  ROSMSAction.h
//  IBMMobileAppBuilder
//

#import "ROUriAction.h"
#import "ROAction.h"

/**
 Open message app
 */
@interface ROSMSAction : ROUriAction<ROAction>

/**
 Phone number has send sms
 */
@property (nonatomic, strong) NSString *phoneNumber;

/**
 Constructor with phone number value
 @param phoneNumber Phone number
 @return Class instance
 */
- (id)initWithValue:(NSString *)phoneNumber;

@end
