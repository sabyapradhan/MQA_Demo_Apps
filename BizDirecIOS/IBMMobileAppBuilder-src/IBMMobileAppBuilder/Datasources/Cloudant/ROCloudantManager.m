//
//  ROCloudantManager.m
//  IBMMobileAppBuilder
//

#import "ROCloudantManager.h"
#import "ROCloudantDatastoreManagerBuilder.h"
#import "ROUtils.h"

@interface ROCloudantManager ()

- (void)log:(NSString*)format, ...;

- (void)startAndFollowReplicator:(CDTReplicator*)replicator label:(NSString*)label;

@end

@implementation ROCloudantManager

static NSString *const kDatastore = @"cloudant-sync-datastore";

static NSString *const kIndexSearch = @"indexSearch";

- (instancetype)init {
    
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - Properties init

- (CDTDatastoreManager *)datastoreManager {

    if (!_datastoreManager) {
    
        _datastoreManager = [ROCloudantDatastoreManagerBuilder build:kDatastore];
    }
    return _datastoreManager;
}

- (CDTReplicatorFactory *)replicatorFactory {

    if (!_replicatorFactory) {
    
        _replicatorFactory = [[CDTReplicatorFactory alloc] initWithDatastoreManager:self.datastoreManager];
    }
    return _replicatorFactory;
}

- (CDTDatastore *)datastore {

    if (!_datastore && self.datastoreName) {
    
        NSError *outError = nil;
        
        _datastore = [self.datastoreManager datastoreNamed:self.datastoreName error:&outError];
        
        if (nil != outError) {
            
            [self log:@"Error creating datastore: %@", outError];
        }
    }
    return _datastore;
}

#pragma mark - Public methods

/**
 Sync by running first a pull then a push replication. This
 method runs synchronously.
 
 I chose this order arbitrarily -- I haven't yet worked
 out whether it's more efficient to run one or the other
 first.
 */
- (void)sync {
    
    [self pull];
    [self push];
}

- (void)pull {
    
    if (self.pullReplicator) {
    
        [self.pullReplicator stop];
    }
    
    [self log:@"Starting pull replication"];

    CDTPullReplication * replicationConfig = [CDTPullReplication replicationWithSource:self.url
                                                                                target:self.datastore];
    CDTReplicatorFactory *factory = self.replicatorFactory;

    NSError *error;
    CDTReplicator *pullReplicator = [factory oneWay:replicationConfig error:&error];
    if (!pullReplicator) {
        
        [self log:@"Error creating pull replicator: %@", error];
        
    } else {
        
        pullReplicator.delegate = self.delegate;
        [self startAndFollowReplicator:pullReplicator
                                 label:@"pull"];
    }
    
    @synchronized(self) {
        
        self.pullReplicator = pullReplicator;
    }
}

- (void)push {
    
    if (self.pushReplicator) {
        
        [self.pushReplicator stop];
    }
    
    [self log:@"Starting push replication"];

    CDTPushReplication *replicationConfig = [CDTPushReplication replicationWithSource:self.datastore
                                                                               target:self.url];
    CDTReplicatorFactory *factory = self.replicatorFactory;
    
    NSError *error;
    CDTReplicator *pushReplicator = [factory oneWay:replicationConfig error:&error];
    if (!pushReplicator) {
        
        [self log:@"Error creating push replicator: %@", error];
        
    } else {
        
        pushReplicator.delegate = self.delegate;
        [self startAndFollowReplicator:pushReplicator
                                 label:@"push"];
    }
    
    @synchronized(self) {

        self.pushReplicator = pushReplicator;
    }
}

#pragma mark - Private methods

/**
 Starts a replication
 */
- (void)startAndFollowReplicator:(CDTReplicator*)replicator label:(NSString*)label {

    NSString *state = [CDTReplicator stringForReplicatorState:replicator.state];
    [self log:@"%@ state: %@ (%d)", label, state, replicator.state];

    NSError *error;
    if (![replicator startWithError:&error]) {
        
        [self log:@"error starting %@ replicator: %@", label, error];
        state = [CDTReplicator stringForReplicatorState:replicator.state];
        [self log:@"%@ state: %@ (%d)", label, state, replicator.state];
        return;
    }
}

- (void)log:(NSString*)format, ... {
    
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

#ifdef DEBUG
    NSLog(@"%@", message);
#endif
    
    [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                        log:message
                                      level:ROLoggerLevelInfo];
}

@end
