//
//  UITableViewCell+RO.h
//  IBMMobileAppBuilder
//

#import <UIKit/UIKit.h>
#import "ROAction.h"

@interface UITableViewCell (RO)

- (void)ro_configureSelectedView;

- (void)ro_configureAction:(NSObject<ROAction> *)action;

@end
