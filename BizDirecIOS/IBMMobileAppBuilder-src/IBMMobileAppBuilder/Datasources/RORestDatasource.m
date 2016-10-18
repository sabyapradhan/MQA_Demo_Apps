//
//  RORestDatasource.m
//  IBMMobileAppBuilder
//

#import "RORestDatasource.h"
#import "ROOptionsFilter.h"
#import "RORestClient.h"
#import "ROError.h"
#import "ROFilter.h"
#import "NSString+RO.h"
#import "ROSearchable.h"

@interface RORestDatasource ()

- (NSMutableDictionary *)requestParamsWithOptionsFilter:(ROOptionsFilter *)optionsFilter;

@end

@implementation RORestDatasource

static NSInteger const kRestDataRequestTimeout    = 30;
static NSString *const kRestConditionsParam       = @"conditions";
static NSString *const kRestSortParam             = @"sort";
static NSString *const kRestSkipParam             = @"skip";
static NSString *const kRestLimitParam            = @"limit";
static NSString *const kRestDistinctParam         = @"distinct";
static NSInteger const kRestDataPageSize          = 20;

static NSString *const kRestApiKey                = @"apikey";

- (instancetype)initWithUrlString:(NSString *)urlString apiKey:(NSString *)apiKey resourceId:(NSString *)resourceId objectsClass:(__unsafe_unretained Class)objectsClass {
    
    self = [super init];
    if (self) {
        _apiKey = apiKey;
        _urlString = urlString;
        _resourceId = resourceId;
        _objectsClass = objectsClass;
    }
    return self;
}

+ (instancetype)datasourceWithUrlString:(NSString *)urlString apiKey:(NSString *)apiKey resourceId:(NSString *)resourceId objectsClass:(__unsafe_unretained Class)objectsClass {
    
    return [[self alloc] initWithUrlString:urlString
                                    apiKey:apiKey
                              resourceId:resourceId
                              objectsClass:objectsClass];
}

- (instancetype)initWithUrlString:(NSString *)urlString userId:(NSString *)userId password:(NSString *)password resourceId:(NSString *)resourceId objectsClass:(__unsafe_unretained Class)objectsClass {
    
    self = [super init];
    if (self) {
        _userId = userId;
        _password = password;
        _urlString = urlString;
        _resourceId = resourceId;
        _objectsClass = objectsClass;
    }
    return self;
}

+ (instancetype)datasourceWithUrlString:(NSString *)urlString userId:(NSString *)userId password:(NSString *)passwd resourceId:(NSString *)resourceId objectsClass:(__unsafe_unretained Class)objectsClass {
    
    return [[self alloc] initWithUrlString:urlString
                                    userId:userId
                                  password:passwd
                              resourceId:resourceId
                              objectsClass:objectsClass];
}

- (RORestClient *)restClient {
    
    if (!_restClient) {
        
        _restClient = [[RORestClient alloc] initWithBaseUrlString:self.urlString timeout:kRestDataRequestTimeout];
        NSMutableDictionary *headers = [NSMutableDictionary new];
        [headers setObject:self.apiKey forKey:kRestApiKey];
        _restClient.headerFields = headers;
    }
    return _restClient;
}

- (void)loadOnSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {
    
    [self loadWithOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadWithOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {
    
    NSMutableDictionary *requestParams = [self requestParamsWithOptionsFilter:optionsFilter];
    
    [self.restClient get:self.resourceId params:requestParams responseClass:self.objectsClass successBlock:^(id response) {
        
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

- (void)distinctValues:(NSString *)columnName filters:(NSArray *)filters onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {

    ROOptionsFilter *of = [ROOptionsFilter new];
    of.baseFilters = [NSMutableArray arrayWithArray:filters];
    
    NSMutableDictionary *params = [self requestParamsWithOptionsFilter:of];
    [params setValue:columnName forKey:kRestDistinctParam];
    
    [self.restClient get:self.resourceId params:params responseClass:nil successBlock:^(id response) {
        
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

- (NSString *)imagePath:(NSString *)path {
    
    if ([path isUrl]) {
        
        return path;
    }
    
    return [NSString stringWithFormat:@"%@%@?%@=%@", self.urlString, path, kRestApiKey, self.apiKey];
}

#pragma mark - <ROPagination>

- (NSInteger)pageSize {
    
    return kRestDataPageSize;
}

- (void)loadPageNum:(NSInteger)pageNum onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {
    
    [self loadPageNum:pageNum withOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadPageNum:(NSInteger)pageNum withOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {
    
    if (!optionsFilter) {
        
        optionsFilter = [ROOptionsFilter new];
    }
    NSInteger size = optionsFilter.pageSize ? [optionsFilter.pageSize integerValue] : [self pageSize];
    NSInteger skip = pageNum * size;
    [optionsFilter.extra setObject:[@(skip) stringValue] forKey:kRestSkipParam];
    [optionsFilter.extra setObject:[@(size) stringValue] forKey:kRestLimitParam];
    [self loadWithOptionsFilter:optionsFilter onSuccess:successBlock onFailure:failureBlock];
}

#pragma mark  - Private methods

- (NSMutableDictionary *)requestParamsWithOptionsFilter:(ROOptionsFilter *)optionsFilter {
    
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithDictionary:optionsFilter.extra];
    
    // CONDITIONS
    NSMutableArray *exps = [NSMutableArray new];
    NSArray *searchableFields;
    
    // searchField is proritized
    if (self.searchField) {
        
        searchableFields = [NSArray arrayWithObject:self.searchField];
        
    } else {
        
        if ([self.delegate conformsToProtocol:@protocol(ROSearchable)]) {
            
            searchableFields = [self.delegate searchableFields];
            
        } else {
            
            searchableFields = [NSArray new];
        }
    }
    
    // Search text. This should be a $text index in Rest's mongodb
    if (searchableFields && searchableFields.count > 0 && optionsFilter.searchText) {
        
        NSMutableArray* searches = [NSMutableArray new];
        for(int i = 0; i < searchableFields.count; i++) {
            
            [searches addObject:[NSString stringWithFormat:@"{\"%@\":{\"$regex\":\"%@\",\"$options\":\"i\"}}",
                                 searchableFields[i],
                                 optionsFilter.searchText
                                 ]];
        }
        [exps addObject:[NSString stringWithFormat:@"\"$or\":[%@]",
                         [searches componentsJoinedByString:@","]]];
    }
    
    for (NSObject<ROFilter> *filter in optionsFilter.filters) {
        
        NSString *qs = [filter getQueryString];
        if(qs) {
            
            [exps addObject:qs];
        }
    }
    
    if (optionsFilter.baseFilters && optionsFilter.baseFilters.count != 0) {
        
        NSMutableArray *baseFilters = [NSMutableArray new];
        for (NSObject<ROFilter> *filter in optionsFilter.baseFilters) {
            
            NSString *qs = [filter getQueryString];
            if (qs) {
                
                [baseFilters addObject:[NSString stringWithFormat:@"{%@}", qs]];
            }
        }
        if (baseFilters.count != 0) {
            
            [exps addObject:[NSString stringWithFormat:@"\"$and\":[%@]",
                             [baseFilters componentsJoinedByString:@","]]];
        }
    }
    
    if (exps.count > 0) {
        
        [requestParams setObject:[NSString stringWithFormat:@"{%@}",
                                  [exps componentsJoinedByString:@","]]
                          forKey:kRestConditionsParam];
    }
    
    // SORT
    if (optionsFilter.sortColumn) {
        
        NSString *sortParam;
        if(!optionsFilter.sortAscending){
            
            sortParam = [NSString stringWithFormat:@"-%@", optionsFilter.sortColumn];
        
        } else{
            
            sortParam = optionsFilter.sortColumn;
        }
        [requestParams setObject:sortParam forKey:kRestSortParam];
    }
    
    // Extra
    for (NSString *key in optionsFilter.extra) {
        
        [requestParams setObject:[optionsFilter.extra objectForKey:key] forKey:key];
    }
    
    return requestParams;
}

@end
