//
//  ROLoginResponse.m
//  IBMMobileAppBuilder
//

#import "ROLoginResponse.h"
#import "NSDictionary+RO.h"

static NSString *const kToken = @"token";
static NSString *const kExpirationTime = @"expirationTime";

@implementation ROLoginResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    self.token = [dictionary ro_stringForKey:kToken];
    self.expirationTime = [dictionary ro_doubleForKey:kExpirationTime];
}

@end
