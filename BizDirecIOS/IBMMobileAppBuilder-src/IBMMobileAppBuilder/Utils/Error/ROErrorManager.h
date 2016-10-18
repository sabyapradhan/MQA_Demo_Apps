//
//  ROErrorManager.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@class ROError;

@interface ROErrorManager : NSObject

@property (nonatomic, strong) NSMutableArray *errors;

+ (instancetype)sharedInstance;

- (void)addError:(ROError *)error;

- (void)processError:(ROError *)error;

@end
