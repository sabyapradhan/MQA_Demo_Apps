//
//  ROUriAction.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROAction.h"

/**
 Action for URI
 */
@interface ROUriAction : NSObject <ROAction>

/**
 Action URI
 */
@property (nonatomic, strong) NSString *uri;

/**
 Action icon
 */
@property (nonatomic, strong) UIImage *icon;

/**
 Error message action
 */
@property (nonatomic, strong) NSString *errorMessage;

/**
 Action not supported message
 */
@property (nonatomic, strong) NSString *actionNotSupportedMessage;

/**
 Constructor with uri value
 @param uri URI value
 @param icon Action icon 
 @return Class instance
 */
- (id)initWithUri:(NSString *)uri atIcon:(UIImage *)icon;

@end
