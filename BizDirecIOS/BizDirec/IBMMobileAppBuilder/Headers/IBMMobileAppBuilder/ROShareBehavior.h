//
//  ROShareBehavior.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROBehavior.h"

@interface ROShareBehavior : NSObject <ROBehavior>

@property (nonatomic, strong) UIViewController *viewController;

- (instancetype)initWithViewController:(UIViewController *)viewController;

+ (instancetype)behaviorViewController:(UIViewController *)viewController;

@end
