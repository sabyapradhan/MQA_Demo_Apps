//
//  ROLoginManager.m
//  IBMMobileAppBuilder
//

#import "ROLoginManager.h"
#import "NSUserDefaults+AESEncryptor.h"

static NSString *const kSuspendDate     = @"SuspendDate";
static NSString *const kExpirationTime  = @"ExpirationTime";
static NSString *const kUserToken       = @"UserToken";

@implementation ROLoginManager

+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (void)saveLastSuspendDate {
    
    NSDate *currentDate = [NSDate date];
    
    [[NSUserDefaults standardUserDefaults] encryptValue:[[NSNumber numberWithDouble:[currentDate timeIntervalSince1970]] stringValue]
                                                withKey:kSuspendDate];
}

- (NSString *)suspendDateString {
    
    return [[NSUserDefaults standardUserDefaults] decryptedValueForKey:kSuspendDate];
}

- (NSString *)expirationTimeString {
    
    return [[NSUserDefaults standardUserDefaults] decryptedValueForKey:kExpirationTime];
}

- (NSString *)userToken {
    
    return [[NSUserDefaults standardUserDefaults] decryptedValueForKey:kUserToken];
}

- (void)resetLoginState {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForAESKey:kUserToken];
    
    [[NSUserDefaults standardUserDefaults] encryptValue:@"0"
                                                withKey:kExpirationTime];
}

- (void)checkLoginStateAndRedirect:(RedirectBlock)redirectBlock {
    
    // check if the user is logged in
    NSString *lastSuspendStr = [self suspendDateString];
    // minutes
    NSString *expirationTimeStr = [self expirationTimeString];
    
    if (expirationTimeStr && lastSuspendStr) {
        
        double lastSuspendDate = [lastSuspendStr doubleValue];
        double expTimeInSeconds = [expirationTimeStr doubleValue] * 60;
        double now = [[NSDate date] timeIntervalSince1970];
        if (expTimeInSeconds != 0 && (lastSuspendDate + expTimeInSeconds < now)) {
            
            if (redirectBlock) {
                redirectBlock();
            }
        }
    }
}

- (void)updateUserToken:(NSString *)userToken expirationTimeString:(NSString *)expirationTimeString {

    [[NSUserDefaults standardUserDefaults] encryptValue:expirationTimeString
                                                withKey:kExpirationTime];
    if (userToken) {
        
        [[NSUserDefaults standardUserDefaults] encryptValue:userToken withKey:kUserToken];
        
    } else if ([[NSUserDefaults standardUserDefaults] decryptedValueForKey:kUserToken]) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForAESKey:kUserToken];
    }
}

- (BOOL)isLogged {

    BOOL logged = NO;
    NSString *expirationTime = [[ROLoginManager sharedInstance] expirationTimeString];
    if (expirationTime && [expirationTime isEqualToString:@"0"]) {
        NSString *token = [[ROLoginManager sharedInstance] userToken];
        if (token) {
            logged = YES;
        }
    }
    return logged;
}

@end
