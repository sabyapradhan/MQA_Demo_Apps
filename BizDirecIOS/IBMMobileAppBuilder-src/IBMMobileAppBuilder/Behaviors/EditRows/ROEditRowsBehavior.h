//
//  ROEditRowsBehavior.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROBehavior.h"

@protocol RODataDelegate;

@class ROTableViewController;

@interface ROEditRowsBehavior : NSObject <ROBehavior, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ROTableViewController<RODataDelegate, UITableViewDataSource, UITableViewDelegate> *viewController;

- (instancetype)initWithViewController:(ROTableViewController<RODataDelegate, UITableViewDataSource, UITableViewDelegate> *)viewController;

+ (instancetype)behaviorViewController:(ROTableViewController<RODataDelegate, UITableViewDataSource, UITableViewDelegate> *)viewController;

@end
