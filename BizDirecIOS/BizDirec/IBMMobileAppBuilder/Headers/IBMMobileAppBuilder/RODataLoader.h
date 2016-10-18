//
//  RODataLoader.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "RODatasource.h"

@class ROError;
@class ROOptionsFilter;

typedef void (^RODataSuccessBlock)(id object);
typedef void (^RODataFailureBlock)(ROError *error);

@protocol RODataLoader <NSObject>

- (NSObject<RODatasource> *)datasource;

- (void)setDatasource:(NSObject<RODatasource> *)datasource;

- (void)setOptionsFilter:(ROOptionsFilter *)optionsFilter;

- (ROOptionsFilter *)optionsFilter;

/**
 *  Refresh data
 */
- (void)refreshDataSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock;

/**
 *  Load data
 */
- (void)loadDataSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock;

@end
