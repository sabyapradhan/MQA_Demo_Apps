//
//  AppDelegate.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MainNavigationManager.h"
#import "ROStyle.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "NSUserDefaults+AESEncryptor.h"
#import "DatasourceManager.h"
@import Q4M;

@interface AppDelegate()

- (void)setup;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setup];

    // Apply styles
    [[ROStyle sharedInstance] apply];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.
    self.window.backgroundColor = [[ROStyle sharedInstance] backgroundColor];

    // Set root view controller
    [self.window setRootViewController:[[MainNavigationManager sharedInstance] rootViewController]];
    [self.window makeKeyAndVisible];
    
    //MQA Setup
    [[MQALogger settings] setMode:MQAModeQA];
    //[[MQALogger settings] setMode:MQAModeMarket];

    // Starts a quality assurance session using a placeholder key and QA mode
    [MQALogger startNewSessionWithApplicationKey:@"1g37bbc63d962812ad76a1da43cc8f314520fb0f42g0g2g37d00d11"];

    // Enables the quality assurance application crash reporting
    NSSetUncaughtExceptionHandler(&MQAUncaughtExceptionHandler);
    
    
    [MQALogger showReportScreen];

    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [[MainNavigationManager sharedInstance] enterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    [[MainNavigationManager sharedInstance] enterForeground];
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[MainNavigationManager sharedInstance] terminate];
}

#pragma mark - Private methods

- (void)setup {

    [[DatasourceManager sharedInstance] sync];

    // Initialize AES Storage for user data
    [[NSUserDefaults standardUserDefaults] setAESKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];

    // Image cache
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory
                                                            diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];

    [[SDImageCache sharedImageCache] cleanDisk];

    // Add a custom read-only cache path
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CachePathImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];

    // Enable network indicator
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

@end
