//
//  ROCloudantReplicatorManagerFactory.m
//  IBMMobileAppBuilder
//

#import "ROCloudantManagerBuilder.h"
#import "ROCloudantManager.h"
#import "ROCloudantDatastoreManagerBuilder.h"
#import "ROUtils.h"

@implementation ROCloudantManagerBuilder

static NSString *const kDatastore = @"cloudant-sync-datastore";

static NSString *const kIndexSearch = @"indexSearch";

static NSString *const kFilterSearch = @"filterSearch";

+ (ROCloudantManager *)buildWithURL:(NSURL *)url datastoreName:(NSString *)datastoreName indexes:(NSArray *)indexes {

    CDTDatastoreManager *datastoreManager = [ROCloudantDatastoreManagerBuilder build:kDatastore];
    
    if (datastoreManager == nil) {
        
        return nil;
    }
    
    CDTReplicatorFactory *factory = [[CDTReplicatorFactory alloc] initWithDatastoreManager:datastoreManager];
    
    NSError *outError = nil;
    
    CDTDatastore *datastore = [datastoreManager datastoreNamed:datastoreName
                                                         error:&outError];
    
    if (nil != outError) {
        
        NSString *log = [NSString stringWithFormat:@"Error creating datastore: %@", outError];
        [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                            log:log
                                          level:ROLoggerLevelError];
        return nil;
    }
    
    if (datastore == nil) {
    
        return nil;
    }
    
    BOOL searchIndexesCreated = NO;
    
    // Create search and filter indexes
    if ([datastore isTextSearchEnabled] && [indexes count] != 0) {
        
        NSDictionary * listIndexes = [datastore listIndexes];
        
        NSDictionary *indexSearch = [listIndexes objectForKey:kIndexSearch];
        if (!indexSearch) {
            
            NSString *index = [datastore ensureIndexed:indexes
                                              withName:kIndexSearch
                                                  type:@"text"];
            
            searchIndexesCreated = (index != nil);
            
            indexSearch = [[datastore listIndexes] objectForKey:kIndexSearch];
            
        } else {
            
            searchIndexesCreated = YES;
        }
        
        if (indexSearch) {
        
            [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                                log:@"Search indexes"
                                              level:ROLoggerLevelInfo
                                           metadata:indexSearch];
        }
        
        
        NSDictionary *filterSearch = [listIndexes objectForKey:kFilterSearch];
        if (!filterSearch) {
            
            NSString *index = [datastore ensureIndexed:indexes
                                              withName:kFilterSearch
                                                  type:@"json"];
            
            if (index) {
            
                filterSearch = [[datastore listIndexes] objectForKey:kFilterSearch];
            }
        }
        
        if (filterSearch) {
        
            [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                                log:@"Filter indexes"
                                              level:ROLoggerLevelInfo
                                           metadata:filterSearch];
        }
    }
    
    ROCloudantManager *cloudantManager = [ROCloudantManager new];
    cloudantManager.url = url;
    cloudantManager.datastore = datastore;
    cloudantManager.replicatorFactory = factory;
    
    cloudantManager.searchIndexesCreated = searchIndexesCreated;

    return cloudantManager;
}

@end
