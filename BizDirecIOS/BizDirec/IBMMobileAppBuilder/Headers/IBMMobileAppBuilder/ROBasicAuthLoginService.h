//
//  ROBasicAuthLoginService.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROLoginService.h"

@interface ROBasicAuthLoginService : NSObject <ROLoginService>

/**
 Base url
 */
@property (nonatomic, strong) NSString *baseUrl;

/**
 App identifier
 */
@property (nonatomic, strong) NSString *appId;

/**
 Initialize the service
 @param baseUrl the url base for the login service <urlbase>/login/<appid>
 @param appId the App id
 */
- (instancetype)initWithBaseUrl:(NSString *)baseUrl appId:(NSString *)appId;

@end
