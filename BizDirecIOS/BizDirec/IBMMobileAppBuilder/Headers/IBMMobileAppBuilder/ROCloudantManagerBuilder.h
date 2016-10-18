//
//  ROCloudantReplicatorManagerFactory.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@class ROCloudantManager;

@interface ROCloudantManagerBuilder : NSObject

+ (ROCloudantManager *)buildWithURL:(NSURL *)url datastoreName:(NSString *)datastoreName indexes:(NSArray *)indexes;

@end
