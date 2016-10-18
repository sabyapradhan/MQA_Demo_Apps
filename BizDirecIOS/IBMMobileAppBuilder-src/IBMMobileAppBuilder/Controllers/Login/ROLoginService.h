//
//  ROLoginService.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROLoginResponse.h"

typedef void (^ROLoginServiceSuccessBlock)(ROLoginResponse *loginResponse);
typedef void (^ROLoginServiceFailureBlock)(NSError *error, NSHTTPURLResponse *response);

@protocol ROLoginService <NSObject>

/**
 Logs in a user, given its username and password. Upon login or failure, a corresponding callback is called
 @Param userName User name
 @Param password Password
 @Param success Success block with ROLoginResponse item
 @Param failure Failure block with request error
 */
- (void)loginUser:(NSString *)userName
     withPassword:(NSString *)password
          success:(ROLoginServiceSuccessBlock)success
          failure:(ROLoginServiceFailureBlock)failure;

@end
