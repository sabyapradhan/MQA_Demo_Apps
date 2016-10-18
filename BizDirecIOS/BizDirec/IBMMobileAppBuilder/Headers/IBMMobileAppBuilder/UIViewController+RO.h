//
//  UIViewController+RO.h
//  IBMMobileAppBuilder
//

#import <UIKit/UIKit.h>

/**
 Helpers to UIViewController
 */
@interface UIViewController (RO)

/**
 It's added left button on navigation bar to show left view controller.
 */
- (void)ro_addLeftSlidingButton;

/**
 It's revealed the left view controller
 */
- (void)ro_revealLeftViewController;

/**
 It's revealed the right view controller
 */
- (void)ro_revealRightViewController;

/**
 Dismiss all presented controllers
 */
- (void)ro_dismissAllControllers;

/**
 Add right bar button preserving the current buttons
 @param barButtonItem Bar button item to add
 */
- (void)ro_addRightBarButtonItem:(UIBarButtonItem *)barButtonItem;

/**
 Add bar button to toolbar bottom
 @param barButtonItem Bar button item to add
 */
- (void)ro_addBottomBarButton:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;

/**
 Show the toolbar at the bottom of the screen if there is any buttons
 @param animated Show with animation
 */
- (void)ro_showBottomToolbarAnimated:(BOOL)animated;

/**
 Hide the toolbar at the bottom of the screen
 @param animated Hide with animation
 */
- (void)ro_hideBottomToolbarAnimated:(BOOL)animated;

@end
