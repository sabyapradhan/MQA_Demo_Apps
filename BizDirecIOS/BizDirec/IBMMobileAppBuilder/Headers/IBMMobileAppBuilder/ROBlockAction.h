//
//  ROCustomAction.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROAction.h"

typedef void (^ROActionBlock)();

/**
 Generic action based in block
 */
@interface ROBlockAction : NSObject <ROAction>

/**
 Action block
 */
@property (readwrite, nonatomic, copy) ROActionBlock actionBlock;

/**
 Constructor with action block
 @return Class instance
 */
- (instancetype)initWithBlock:(ROActionBlock)actionBlock;

/**
 Constructor with action block
 @return Class instance
 */
+ (instancetype)actionWithBlock:(ROActionBlock)actionBlock;

@end
