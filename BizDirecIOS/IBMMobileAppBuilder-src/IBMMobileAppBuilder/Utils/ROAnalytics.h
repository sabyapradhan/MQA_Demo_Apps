//
//  ROAnalytics.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@protocol ROAnalytics <NSObject>

- (void)setup;

- (void)log:(NSString *)message;

- (void)log:(NSString *)message metadata:(NSDictionary *)metadata;

- (void)send;

- (void)enterBackground;

- (void)enterForeground;

- (void)logRequest:(NSString *)url method:(NSString *)method;

- (void)logResponse:(NSString *)url code:(NSNumber *)code body:(id)body;

- (void)logPage:(NSString *)page;

- (void)logAction:(NSString *)action entity:(NSString *)entity;

- (void)logAction:(NSString *)action entity:(NSString *)entity identifier:(NSString *)identifier;

- (void)logAction:(NSString *)action target:(NSString *)target;

- (void)logAction:(NSString *)action target:(NSString *)target datasourceName:(NSString *)datasourceName;

@end
