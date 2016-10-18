//
//  ROFilterBehavior.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROBehavior.h"

@protocol RODataDelegate;

@interface ROFilterBehavior : NSObject <ROBehavior>

/**
 Filter view controller class
 */
@property (nonatomic, strong) Class filterControllerClass;

@property (nonatomic, strong) UIViewController<RODataDelegate> *viewController;

- (instancetype)initWithViewController:(UIViewController<RODataDelegate> *)viewController filterControllerClass:(Class)filterControllerClass;

+ (instancetype)behaviorViewController:(UIViewController<RODataDelegate> *)viewController filterControllerClass:(Class)filterControllerClass;

@end
