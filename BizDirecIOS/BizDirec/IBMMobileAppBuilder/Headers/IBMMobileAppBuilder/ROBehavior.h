//
//  ROBehavior.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@protocol ROBehavior <NSObject>

- (void)viewDidLoad;

- (UIViewController *)viewController;

@optional

- (void)viewDidAppear:(BOOL)animated;

- (void)viewDidDisappear:(BOOL)animated;

- (void)onDataSuccess:(id)dataObject;

@end
