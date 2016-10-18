//
//  ROLoginResponse.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROModel.h"

@interface ROLoginResponse : NSObject <ROModelDelegate>

@property (nonatomic, assign) double expirationTime;
@property (nonatomic, strong) NSString *token;

@end
