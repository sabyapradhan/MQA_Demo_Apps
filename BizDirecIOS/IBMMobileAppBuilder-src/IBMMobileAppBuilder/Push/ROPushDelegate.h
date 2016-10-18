//
//  ROPushDelegate.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@protocol ROPushDelegate <NSObject>

- (void)registerRemoteNotifications;

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo;

@end
