//
//  ROUtils.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROAnalytics.h"
#import "ROLogger.h"

@interface ROUtils : NSObject

@property (nonatomic, strong) id<ROAnalytics> analytics;

@property (nonatomic, strong) id<ROLogger> logger;

+ (instancetype)sharedInstance;

@end
