//
//  ROLogger.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ROLoggerLevel) {
    ROLoggerLevelTrace,
    ROLoggerLevelDebug,
    ROLoggerLevelLog,
    ROLoggerLevelInfo,
    ROLoggerLevelWarn,
    ROLoggerLevelError,
    ROLoggerLevelFatal,
    ROLoggerLevelAnalytics
};

@protocol ROLogger <NSObject>

- (void)name:(NSString *)name log:(NSString *)message level:(ROLoggerLevel)level;

- (void)name:(NSString *)name log:(NSString *)message level:(ROLoggerLevel)level metadata:(NSDictionary *)metadata;

@optional

- (NSDictionary *)metadataWithObject:(id)obj;

- (void)send;

@end
