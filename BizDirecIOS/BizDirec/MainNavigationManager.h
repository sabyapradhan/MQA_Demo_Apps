//
//  MainNavigationManager.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import <Foundation/Foundation.h>
#import "ROAction.h"

@interface MainNavigationManager : NSObject

@property (nonatomic, strong, readonly) UIViewController *rootViewController;

@property (nonatomic, strong) UIViewController *mainViewController;

+ (instancetype)sharedInstance;

- (void)enterBackground;

- (void)enterForeground;

- (void)terminate;

- (void)logout;

- (id<ROAction>)logoutAction;

@end
