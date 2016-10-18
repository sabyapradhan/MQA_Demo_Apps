//
//  RORestDatasource.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "RODatasource.h"
#import "ROPagination.h"

@protocol ROSearchable;

@class RORestClient;

@interface RORestDatasource : NSObject <RODatasource, ROPagination>

@property (nonatomic, strong) RORestClient *restClient;

@property (nonatomic, assign) Class objectsClass;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *resourceId;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSObject<ROSearchable> *delegate;
@property (nonatomic, strong) NSString *searchField;

- (instancetype)initWithUrlString:(NSString *)urlString
                           apiKey:(NSString *)apiKey
                       resourceId:(NSString *)resourceId
                     objectsClass:(__unsafe_unretained Class)objectsClass;

+ (instancetype)datasourceWithUrlString:(NSString *)urlString
                                 apiKey:(NSString *)apiKey
                             resourceId:(NSString *)resourceId
                           objectsClass:(__unsafe_unretained Class)objectsClass;

- (instancetype)initWithUrlString:(NSString *)urlString
                           userId:(NSString *)userId
                         password:(NSString *)password
                       resourceId:(NSString *)resourceId
                     objectsClass:(__unsafe_unretained Class)objectsClass;

+ (instancetype)datasourceWithUrlString:(NSString *)urlString
                                 userId:(NSString *)userId
                               password:(NSString *)password
                             resourceId:(NSString *)resourceId
                           objectsClass:(__unsafe_unretained Class)objectsClass;

@end
