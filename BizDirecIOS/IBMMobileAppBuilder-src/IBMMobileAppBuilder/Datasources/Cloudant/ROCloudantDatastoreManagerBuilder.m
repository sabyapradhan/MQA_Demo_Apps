//
//  ROCloudantDatastoreManagerFactory.m
//  IBMMobileAppBuilder
//

#import "ROCloudantDatastoreManagerBuilder.h"
#import "CDTDatastoreManager.h"
#import "ROUtils.h"

@implementation ROCloudantDatastoreManagerBuilder

+ (CDTDatastoreManager *)build:(NSString *)name {
    
    NSError *outError = nil;
    
    NSFileManager *fileManager= [NSFileManager defaultManager];
    
    NSURL *documentsDir = [[fileManager URLsForDirectory:NSDocumentDirectory
                                               inDomains:NSUserDomainMask] lastObject];
    
    NSURL *storeURL = [documentsDir URLByAppendingPathComponent:name];
    
    if (storeURL == nil) {
    
        return nil;
    }
    
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:[storeURL path] isDirectory:&isDir];
    
    if (exists && !isDir) {
        
        NSString *log = [NSString stringWithFormat:@"Can't create datastore directory: file in the way at %@", storeURL];
        [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                            log:log
                                          level:ROLoggerLevelError];
        return nil;
    }
    
    if (!exists) {
        
        [fileManager createDirectoryAtURL:storeURL
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&outError];
        
        if (nil != outError) {
            
            NSString *log = [NSString stringWithFormat:@"Error creating manager directory: %@", outError];
            [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                                log:log
                                              level:ROLoggerLevelError];
            return nil;
        }
    }
    
    NSString *path = [storeURL path];
    
    CDTDatastoreManager *datastoreManager = [[CDTDatastoreManager alloc] initWithDirectory:path
                                                                 error:&outError];
    if (nil != outError) {
        
        NSString *log = [NSString stringWithFormat:@"Error creating manager: %@", outError];
        [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                            log:log
                                          level:ROLoggerLevelError];

        return nil;
    }

    return datastoreManager;
}

@end
