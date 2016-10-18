//
//  ROCloudantDatasource.m
//  IBMMobileAppBuilder
//

#import "ROCloudantDatasource.h"
#import "ROOptionsFilter.h"
#import "ROCloudantItem.h"
#import "ROCloudantDatastoreManagerBuilder.h"
#import "ROCloudantManagerBuilder.h"
#import "ROUtils.h"
#import "ROCloudantManager.h"
#import "ROFilter.h"
#import "ROSearchable.h"
#import "AFNetworkReachabilityManager.h"

@interface ROCloudantDatasource () <CDTReplicatorDelegate>

@property (nonatomic, strong) NSMutableDictionary *query;

@property (nonatomic, assign) NSInteger skip;

@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSArray *sort;

@property (readwrite, nonatomic, copy) RODatasourceSuccessBlock successBlock;

@property (readwrite, nonatomic, copy) RODatasourceErrorBlock failureBlock;

@property (nonatomic, strong) NSString *syncKey;

@property (nonatomic, assign) BOOL synchronizing;

- (NSMutableDictionary *)queryWithOptionsFilter:(ROOptionsFilter *)optionsFilter;

- (void)loadDataWithQuery:(NSMutableDictionary *)query skip:(NSInteger)skip limit:(NSInteger)limit sort:(NSArray *)sort success:(RODatasourceSuccessBlock)successBlock failure:(RODatasourceErrorBlock)failureBlock;

- (NSMutableArray *)itemsWithQuery:(NSMutableDictionary *)query skip:(NSInteger)skip limit:(NSInteger)limit sort:(NSArray *)sort;

- (NSMutableArray *)find:(NSMutableDictionary *)query skip:(NSInteger)skip limit:(NSInteger)limit sort:(NSArray *)sort;

- (NSMutableArray *)allItems:(NSInteger)skip limit:(NSInteger)limit;

@end

@implementation ROCloudantDatasource

static NSInteger const kCloudantPageSize = 20;

- (instancetype)initWithUrlString:(NSString *)urlString datastoreName:(NSString *)datastoreName objectsClass:(__unsafe_unretained Class)objectsClass {

    self = [super init];
    if (self) {
    
        _urlString = urlString;
        _datastoreName = datastoreName;
        _objectsClass = objectsClass;
        
        [self setSynchronized:NO];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

#ifdef DEBUG
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
#endif
        }];
    }
    return self;
}

+ (instancetype)datasourceWithUrlString:(NSString *)urlString datastoreName:(NSString *)datastoreName objectsClass:(__unsafe_unretained Class)objectsClass {

    return [[self alloc] initWithUrlString:urlString datastoreName:datastoreName objectsClass:objectsClass];
}

- (void)dealloc {

    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark - Properties init

- (ROCloudantManager *)cloudantManager {

    if (!_cloudantManager) {
        
        NSArray *indexes;
        if ([self.delegate conformsToProtocol:@protocol(ROSearchable)]) {
            
            indexes = [self.delegate searchableFields];
        }
        
        _cloudantManager = [ROCloudantManagerBuilder buildWithURL:[NSURL URLWithString:self.urlString]
                                                     datastoreName:self.datastoreName
                                                           indexes:indexes];
        _cloudantManager.delegate = self;
    }
    return _cloudantManager;
}

- (NSString *)syncKey {

    if (!_syncKey) {
    
        _syncKey = [NSString stringWithFormat:@"%@-sync", NSStringFromClass([self class])];
    }
    return _syncKey;
}

#pragma mark - Private methods

- (NSMutableDictionary *)queryWithOptionsFilter:(ROOptionsFilter *)optionsFilter {
    
    NSMutableDictionary *query = [NSMutableDictionary new];
    if (self.cloudantManager.searchIndexesCreated && optionsFilter.searchText) {
        
        NSString *search = [NSString stringWithFormat:@"%@*", optionsFilter.searchText];
        [query setObject:@{ @"$search": search }
                  forKey:@"$text"];
    }
    
    if ([optionsFilter.baseFilters count] != 0) {
        
        for (NSObject<ROFilter> *filter in optionsFilter.baseFilters) {
            
            [query setObject:[filter fieldValue]
                      forKey:[filter fieldName]];
        }
    }
    
    //TODO: Supporting runtime filters

    return query;
}

- (void)loadDataWithQuery:(NSMutableDictionary *)query skip:(NSInteger)skip limit:(NSInteger)limit sort:(NSArray *)sort success:(RODatasourceSuccessBlock)successBlock failure:(RODatasourceErrorBlock)failureBlock {

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSMutableArray *items = [self itemsWithQuery:query
                                                skip:skip
                                               limit:limit
                                                sort:sort];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (items) {
                
                if (successBlock) {
                    
                    successBlock(items);
                }
                
            } else if (failureBlock) {
                
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                           NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Find query error.", nil)
                                           };
                NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                     code:0
                                                 userInfo:userInfo];
                
                failureBlock(error, nil);
            }
        });
    });
}

- (NSMutableArray *)itemsWithQuery:(NSMutableDictionary *)query skip:(NSInteger)skip limit:(NSInteger)limit sort:(NSArray *)sort {

    NSMutableDictionary *metadata = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    @"skip"     : @(skip),
                                                                                    @"limit"    : @(limit)
                                                                                    }];
    if (query) {
        
        [metadata setObject:query
                     forKey:@"query"];
    }
    if (sort) {
    
        [metadata setObject:sort
                     forKey:@"sort"];
    }
    [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                        log:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
                                      level:ROLoggerLevelInfo
                                   metadata:metadata];
    
    if (sort || [query count] != 0) {
    
        return [self find:query skip:skip limit:limit sort:sort];
    }
    
    return [self allItems:skip limit:limit];
}

- (NSMutableArray *)find:(NSMutableDictionary *)query skip:(NSInteger)skip limit:(NSInteger)limit sort:(NSArray *)sort {

    CDTQResultSet *result = [[self.cloudantManager datastore] find:query
                                                              skip:skip
                                                             limit:limit
                                                            fields:nil
                                                              sort:sort];
    
    if (result) {
        
        NSMutableArray *items = [NSMutableArray array];
        
        if (self.objectsClass && [[self.objectsClass alloc] respondsToSelector:@selector(initWithDocumentRevision:)]) {
            
            [result enumerateObjectsUsingBlock:^(CDTDocumentRevision *rev, NSUInteger idx, BOOL *stop) {
                
                id obj = [[self.objectsClass alloc] initWithDocumentRevision:rev];
                [items addObject:obj];
                
            }];
            
        } else {
            
            [result enumerateObjectsUsingBlock:^(CDTDocumentRevision *rev, NSUInteger idx, BOOL *stop) {
                
                [items addObject:rev.body];
                
            }];
        }
        
        return items;
    }
    
    return nil;
}

- (NSMutableArray *)allItems:(NSInteger)skip limit:(NSInteger)limit {

    NSMutableArray *items = [NSMutableArray array];
    
    NSArray *documents = [[self.cloudantManager datastore] getAllDocumentsOffset:skip
                                                                           limit:limit
                                                                      descending:YES];
    for (CDTDocumentRevision *rev in documents) {
        
        id obj = [[self.objectsClass alloc] initWithDocumentRevision:rev];
        [items addObject:obj];
    }
    
    return items;
}

#pragma mark - <RODatasource>

- (void)loadOnSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {

    [self loadWithOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadWithOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {

    [self loadPageNum:0 withOptionsFilter:optionsFilter onSuccess:successBlock onFailure:failureBlock];
}

- (void)distinctValues:(NSString *)columnName filters:(NSArray *)filters onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {

#warning TODO distinct values
    // TODO: distinct
    
}

- (NSString *)imagePath:(NSString *)path {

    return path;
}

#pragma mark - <ROPagination>

- (NSInteger)pageSize {

    return kCloudantPageSize;
}

- (void)loadPageNum:(NSInteger)pageNum onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {

    [self loadPageNum:pageNum withOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadPageNum:(NSInteger)pageNum withOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock {
    
    if (self.cloudantManager == nil && failureBlock) {
        
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Cloudant manager undefined.", nil)
                                   };
        NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                             code:0
                                         userInfo:userInfo];
        failureBlock(error, nil);
        
        return;
    }
    
    if (!optionsFilter) {
        
        optionsFilter = [ROOptionsFilter new];
    }
    
    NSArray *sort;
    if (optionsFilter.sortColumn) {
        
        sort = @[
                 @{ optionsFilter.sortColumn : optionsFilter.sortAscending ? @"asc" : @"desc"}
                 ];
    }
    
    NSInteger limit = [self pageSize];
    if (optionsFilter.pageSize) {
    
        limit = [optionsFilter.pageSize integerValue];
    }
    
    NSMutableDictionary *query = [self queryWithOptionsFilter:optionsFilter];

    NSInteger skip = pageNum * limit;
    
    if (![self synchronized]) {
    
        self.synchronizing = YES;
        
        self.query = query;
        self.sort = sort;
        self.skip = skip;
        self.limit = limit;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;

        [self sync];
        
    } else if (!self.synchronizing) {
    
        [self loadDataWithQuery:query
                           skip:skip
                          limit:limit
                           sort:sort
                        success:successBlock
                        failure:failureBlock];
    }
}

#pragma mark - <ROSynchronize>

- (void)sync {
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
    
        [self setSynchronized:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.cloudantManager sync];
        });
    
    } else {
    
        if (self.successBlock || self.failureBlock) {
            
            [self loadDataWithQuery:self.query
                               skip:self.skip
                              limit:self.limit
                               sort:self.sort
                            success:self.successBlock
                            failure:self.failureBlock];
        }

    }
}

- (BOOL)synchronized {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:self.syncKey];
}

- (void)setSynchronized:(BOOL)synchronized {
    
    [[NSUserDefaults standardUserDefaults] setBool:synchronized
                                            forKey:self.syncKey];
}

#pragma mark - <CDTReplicatorDelegate>

- (void)replicatorDidComplete:(CDTReplicator *)replicator {
    
    NSString *log = [NSString stringWithFormat:@"%@ complete", replicator];
    
    [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                        log:log
                                      level:ROLoggerLevelInfo];
    
    if (replicator == self.cloudantManager.pullReplicator) {

        self.synchronizing = NO;
        
        [self setSynchronized:YES];
        
        if (self.successBlock || self.failureBlock) {
        
            [self loadDataWithQuery:self.query
                               skip:self.skip
                              limit:self.limit
                               sort:self.sort
                            success:self.successBlock
                            failure:self.failureBlock];
        }
    }
}

- (void)replicatorDidError:(CDTReplicator *)replicator info:(NSError *)info {
    
    NSString *log = [NSString stringWithFormat:@"%@ error: %@", replicator, info];
    
    [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                        log:log
                                      level:ROLoggerLevelError
                                   metadata:[info userInfo]];
    
    if (replicator == self.cloudantManager.pullReplicator) {
        
        self.synchronizing = NO;
        
        if (self.failureBlock) {
        
            self.failureBlock(info, nil);
        }
    }
}

- (void)replicatorDidChangeState:(CDTReplicator *)replicator {
    
    NSString *state = [CDTReplicator stringForReplicatorState:replicator.state];
    NSString *log = [NSString stringWithFormat:@"%@ new state: %@ (%ld)", replicator, state, (long)replicator.state];
    
    [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                        log:log
                                      level:ROLoggerLevelInfo];
}

- (void)replicatorDidChangeProgress:(CDTReplicator *)replicator {
    
    NSString *state = [CDTReplicator stringForReplicatorState:replicator.state];
    NSString *log = [NSString stringWithFormat:@"%@ changes total %ld. changes processed %ld. state: %@ (%ld)", replicator, (long)replicator.changesTotal, (long)replicator.changesProcessed, state, (long)replicator.state];
    
    [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                        log:log
                                      level:ROLoggerLevelInfo];
}

@end
