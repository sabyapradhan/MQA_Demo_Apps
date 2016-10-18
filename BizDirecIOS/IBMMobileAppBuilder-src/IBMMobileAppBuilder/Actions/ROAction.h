//
//  ROAction.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

/**
  Generic protocol to handle actions
 */
@protocol ROAction <NSObject>

/**
 Action to do
 */
- (void)doAction;

/**
 Can do action
 */
- (BOOL)canDoAction;

/*
 Action icon
 */
- (UIImage *)actionIcon;

@end
