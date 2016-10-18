//
//  ROCollectionCloudDatasource.m
//  IBMMobileAppBuilder
//

#import "ROCollectionCloudDatasource.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSUserDefaults+AESEncryptor.h"
#import "ROOptionsFilter.h"
#import "ROFilter.h"
#import "ROModel.h"
#import "NSString+RO.h"
#import "RORestClient.h"
#import "ROError.h"

static NSInteger const kCloudDataPageSize               = 20;
static NSString *const kCloudDataRequestParamPageStart  = @"offset";
static NSString *const kCloudDataRequestParamPageSize   = @"blockSize";
static NSString *const kCloudDataParamSortField         = @"sortingColumn";
static NSString *const kCloudDataParamSortType          = @"sortAscending";
static NSString *const kCloudDataParamSearchText        = @"searchText";
static NSString *const kCloudDataParamCondition         = @"condition";

static NSString *const kApiKey                          = @"apiKey";

static NSInteger const kCloudDataRequestTimeout         = 30;

@interface ROCollectionCloudDatasource ()

- (NSString *)allFilters:(ROOptionsFilter *)optionsFilter;

- (NSString *)filterQuery:(NSMutableArray *)filters;

@end

@implementation ROCollectionCloudDatasource

- (id)initWithUrlString:(NSString *)urlString
              withAppId:(NSString *)appId
             withApiKey:(NSString *)apiKey
         atDatasourceId:(NSString *)datasourceId
         atObjectsClass:(Class)objectsClass {
    
    self = [super init];
    if (self) {
        _appId = appId;
        _apiKey = apiKey;
        _urlString = urlString;
        _dsId = datasourceId;
        _objectsClass = objectsClass;
    }
    return self;
}

- (NSString *)imagePath:(NSString *)path {
    
    if ([path isUrl]) {
        return path;
    }
    
    return [NSString stringWithFormat:@"%@%@?%@=%@", self.urlString, path, kApiKey, self.apiKey];
}

- (RORestClient *)restClient {
    
    if (!_restClient) {
        _restClient = [[RORestClient alloc] initWithBaseUrlString:self.urlString timeout:kCloudDataRequestTimeout];
        [_restClient.manager.requestSerializer clearAuthorizationHeader];
        [_restClient.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_appId password:_apiKey];
    }
    NSString *token = [[NSUserDefaults standardUserDefaults] decryptedValueForKey:@"UserToken"];
    if (token) {
        [_restClient.manager.requestSerializer setValue:token forHTTPHeaderField:@"UserToken"];
    }
    return _restClient;
}

- (void)loadOnSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {
    
    [self loadWithOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadWithOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {
    
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithDictionary:optionsFilter.extra];
    if (optionsFilter.searchText) {
        [requestParams setObject:optionsFilter.searchText forKey:kCloudDataParamSearchText];
    }
    if (optionsFilter.sortColumn) {
        [requestParams setObject:optionsFilter.sortColumn forKey:kCloudDataParamSortField];
        NSString *sortType = optionsFilter.sortAscending ? @"true" : @"false";
        [requestParams setObject:sortType forKey:kCloudDataParamSortType];
    }
    
    // filters
    NSString *allFilters = [self allFilters:optionsFilter];
    if (allFilters) {
        [requestParams setObject:allFilters forKey:kCloudDataParamCondition];
    }
    
    [self.restClient get:_dsId params:requestParams responseClass:self.objectsClass successBlock:^(id response) {
        
        if (successBlock) {
            if ([response isKindOfClass:[NSArray class]]) {
                successBlock (response);
            } else {
                successBlock([NSArray new]);
            }
        }
        
    } failureBlock:^(ROError *error) {
        
        if (failureBlock) {
            failureBlock(error.error, nil);
        }
        
    }];
    
}

- (NSString *)allFilters:(ROOptionsFilter *)optionsFilter {
 
    NSMutableArray *query = [NSMutableArray arrayWithArray:optionsFilter.baseFilters];
    
    [query addObjectsFromArray:optionsFilter.filters];
    
    return [self filterQuery:query];
}

- (NSString *)filterQuery:(NSMutableArray *)filters {
    if(!filters || filters.count == 0)
        return nil;
    
    NSMutableArray *conditions = [NSMutableArray new];
    for(NSObject<ROFilter> *filter in filters){
        NSString *qs = [filter getQueryString];
        if(qs){
            [conditions addObject:[NSString stringWithFormat:@"{%@}", qs]];
        }
    }
    
    if(conditions.count > 0) {
        
        return [NSString stringWithFormat:@"[%@]", [conditions componentsJoinedByString:@","]];
    
    } else {
        
        return nil;
    }
}

- (void)distinctValues:(NSString *)columnName filters:(NSArray *)filters onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {
    
    NSString *path = [NSString stringWithFormat:@"%@/distinct/%@", _dsId, columnName];
    
    ROOptionsFilter *optionsFilter = [ROOptionsFilter new];
    optionsFilter.baseFilters = [NSMutableArray arrayWithArray:filters];
    
    NSMutableDictionary *requestParams = [NSMutableDictionary new];
    NSString *query = [self allFilters:optionsFilter];
    if (query) {
        [requestParams setObject:query forKey:kCloudDataParamCondition];
    }
    
    [self.restClient get:path params:requestParams responseClass:nil successBlock:^(id response) {
        
        if (successBlock) {
            if ([response isKindOfClass:[NSArray class]]) {
                successBlock (response);
            } else {
                successBlock([NSArray new]);
            }
        }
        
    } failureBlock:^(ROError *error) {
        
        if (failureBlock) {
            failureBlock(error.error, nil);
        }
        
    }];
}

#pragma mark - ROPagination

- (NSInteger)pageSize {
    
    return kCloudDataPageSize;
}

- (void)loadPageNum:(NSInteger)pageNum onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {
    
    [self loadPageNum:pageNum withOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadPageNum:(NSInteger)pageNum withOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {
    
    if (!optionsFilter) {
        optionsFilter = [ROOptionsFilter new];
    }
    NSInteger size = optionsFilter.pageSize ? [optionsFilter.pageSize integerValue] : [self pageSize];
    [optionsFilter.extra setObject:[@(pageNum) stringValue] forKey:kCloudDataRequestParamPageStart];
    [optionsFilter.extra setObject:[@(size) stringValue] forKey:kCloudDataRequestParamPageSize];
    [self loadWithOptionsFilter:optionsFilter onSuccess:successBlock onFailure:failureBlock];
}

@end
