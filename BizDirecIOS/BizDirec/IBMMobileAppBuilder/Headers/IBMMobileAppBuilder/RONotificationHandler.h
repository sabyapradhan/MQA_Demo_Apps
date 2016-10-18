//
//  RONotificationHandler.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@class RONotificationView;

@interface RONotificationHandler : NSObject

@property (nonatomic, strong) RONotificationView *notificationView;

@property (nonatomic, strong, readonly) UIView *containerView;

- (void)showNotification:(NSDictionary *)userInfo;

- (void)dismissNotification;

- (void)tapOnNotification;

@end
