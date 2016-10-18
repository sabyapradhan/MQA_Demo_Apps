//
//  RODataDelegate.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "RODataLoader.h"

@class ROError;

@protocol RODataDelegate <NSObject>

/**
 Data loader
 @return dataLoader
 */
- (NSObject<RODataLoader> *)dataLoader;

/**
 Load data
 */
- (void)loadData;

/**
 Load data success
 @param dataObject
 */
- (void)loadDataSuccess:(id)dataObject;

/**
 Load data error
 */
- (void)loadDataError:(ROError *)error;

@end
