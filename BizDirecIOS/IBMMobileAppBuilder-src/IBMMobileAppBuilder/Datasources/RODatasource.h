//
//  RODatasource.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@class ROOptionsFilter;

typedef void (^RODatasourceSuccessBlock)(NSArray *objects);
typedef void (^RODatasourceErrorBlock)(NSError *error, NSHTTPURLResponse *response);

@protocol RODatasource <NSObject>

- (void)loadOnSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock;

- (void)loadWithOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock;

- (void)distinctValues:(NSString *)columnName filters:(NSArray *)filters onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock;

- (NSString *)imagePath:(NSString *)path;

- (__unsafe_unretained Class)objectsClass;

@end