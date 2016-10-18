//
//  RONavigationAction.h
//  IBMMobileAppBuilder
//

#import "ROAction.h"

/**
 Sets navigation between controllers
 */
@interface RONavigationAction : NSObject <ROAction>

/**
 Root controller
 */
@property (nonatomic, strong) UIViewController *rootViewController;

/**
 Destination controller
 */
@property (nonatomic, strong) UIViewController *destinationController;

/**
 Detail object
 */
@property (nonatomic, strong) NSObject *detailObject;

/**
 Destination controller class
 */
@property (nonatomic, strong) Class destinationClass;

/**
 Contructor with destination controller or class
 @param rootViewController Root controller
 @param destinationValue Destination controller or class
 @return Class instance
 */
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController destinationValue:(id)destinationValue;

/**
 Contructor with destination controller or class
 @param rootViewController Root controller
 @param destinationValue Destination controller or class
 @return Class instance
 */
+ (instancetype)navigationActionWithRootViewController:(UIViewController *)rootViewController destinationValue:(id)destinationValue;

/**
 Navigate to view controller
 @param viewController Destination view controller
 */
- (void)navigateToViewController:(UIViewController *)viewController;

@end
