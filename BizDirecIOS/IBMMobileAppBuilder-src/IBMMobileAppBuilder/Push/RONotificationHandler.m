//
//  RONotificationHandler.m
//  IBMMobileAppBuilder
//

#import "RONotificationHandler.h"
#import "RONotificationView.h"
#import "UIImage+RO.h"

@interface RONotificationHandler ()

@property (nonatomic, assign, readonly) CGFloat height;

@end

@implementation RONotificationHandler

static CGFloat const kDuration      = 0.2f;
static CGFloat const kVisibleTime   = 5.0f;

#pragma mark - Properties init

- (RONotificationView *)notificationView {
    
    if (!_notificationView) {
        
        _notificationView = [RONotificationView new];
        _notificationView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _notificationView;
}

#pragma mark - Private methods

- (UIView *)containerView {
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController.view;
}

- (void)showNotification:(NSDictionary *)userInfo {
    
    [self.notificationView removeFromSuperview];
    
    [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelStatusBar+1];
    
    NSString *title = nil;
    NSString *msg = nil;
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    if (aps) {
        
        id alert = [aps objectForKey:@"alert"];
        if ([alert isKindOfClass:[NSString class]]) {
            
            msg = alert;
            
        } else if ([alert isKindOfClass:[NSDictionary class]]) {
            
            title = [alert objectForKey:@"title"];
            msg = [alert objectForKey:@"body"];
        }
    }
    
    if (msg) {
        
        if (title == nil) {
            
            title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        }
        
        if (self.notificationView.imageView.image == nil) {
            
            self.notificationView.imageView.image = [UIImage ro_imageNamed:@"logoROapp"];
        }
        self.notificationView.textLabel.text = title;
        self.notificationView.detailTextLabel.text = msg;
        
        self.notificationView.frame = CGRectMake(0, -self.height, CGRectGetWidth([[UIScreen mainScreen] bounds]), self.height);
        
        [self.containerView addSubview:self.notificationView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnNotification)];
        tap.numberOfTapsRequired = 1;
        [self.notificationView addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotification)];
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self.notificationView addGestureRecognizer:swipe];
        
        [UIView animateWithDuration:kDuration animations:^{
            
            self.notificationView.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), self.height);
            
        }];
        
        [NSTimer scheduledTimerWithTimeInterval:kVisibleTime
                                         target:self
                                       selector:@selector(dismissNotification)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)dismissNotification {
    
    if ([self.notificationView superview]) {
        
        [UIView animateWithDuration:kDuration animations:^{
            
            self.notificationView.frame = CGRectMake(0, -self.height, CGRectGetWidth([[UIScreen mainScreen] bounds]), self.height);
            
        } completion:^(BOOL finished) {
            
            [self.notificationView removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
            
        }];
    }
}

- (void)tapOnNotification {

    [self dismissNotification];
}

#pragma mark - Private methods

- (CGFloat)height {

    CGFloat height;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            height = 44.0f;
            break;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        default:
            height = 66.0f;
            break;
    }
    
    return height;
}

@end
