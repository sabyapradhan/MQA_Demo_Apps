//
//  ROLoginService.m
//  IBMMobileAppBuilder
//

#import "ROBasicAuthLoginService.h"
#import "AFNetworking.h"
#import "ROLoginResponse.h"

@interface ROBasicAuthLoginService ()

@end

@implementation ROBasicAuthLoginService

- (instancetype)initWithBaseUrl:(NSString *)baseUrl appId:(NSString *)appId {
    
    self = [super init];
    if (self) {
    
        _baseUrl = baseUrl;
        _appId = appId;
    }
    return self;
}

- (void)loginUser:(NSString *)user
     withPassword:(NSString *)password
          success:(ROLoginServiceSuccessBlock)success
          failure:(ROLoginServiceFailureBlock)failure {
    
    NSURL *baseUrl = [NSURL URLWithString:self.baseUrl];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:baseUrl];
#ifdef DEBUG
    manager.securityPolicy.allowInvalidCertificates = YES;
#endif
    
    // set http basic auth
    [manager.requestSerializer clearAuthorizationHeader];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:user password:password];
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSString *path = [NSString stringWithFormat:@"login/%@", self.appId];
    
    [manager POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if (success) {
                NSDictionary *responseDict = (NSDictionary *) responseObject;
                ROLoginResponse *response = [[ROLoginResponse alloc] initWithDictionary:responseDict];
                success(response);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
        if (error && error.userInfo) {
            NSLog(@"Error in:%s\n%@", __PRETTY_FUNCTION__,  [error.userInfo valueForKey:@"NSLocalizedDescription"]);
        }
#endif
        if (failure) {
            failure(error, operation.response);
        }
    }];
}

@end
