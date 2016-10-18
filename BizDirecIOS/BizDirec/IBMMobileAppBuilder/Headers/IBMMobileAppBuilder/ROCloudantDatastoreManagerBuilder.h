//
//  ROCloudantDatastoreManagerFactory.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@class CDTDatastoreManager;

@interface ROCloudantDatastoreManagerBuilder : NSObject

+ (CDTDatastoreManager *)build:(NSString *)name;

@end
