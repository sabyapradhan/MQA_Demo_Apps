//
//  ROCollectionCloudDatasource.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "RODatasource.h"
#import "ROPagination.h"

@class RORestClient;

@interface ROCollectionCloudDatasource : NSObject <RODatasource,ROPagination>

@property (nonatomic, strong) RORestClient *restClient;

@property (nonatomic, assign) Class objectsClass;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *dsId;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *appId;

- (id)initWithUrlString:(NSString *) urlString
              withAppId:(NSString *) appId
             withApiKey:(NSString *) apiKey
         atDatasourceId:(NSString *) datasourceId
         atObjectsClass:(Class) objectsClass;

@end
