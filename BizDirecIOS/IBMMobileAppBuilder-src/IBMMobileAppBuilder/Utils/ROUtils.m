//
//  ROUtils.m
//  IBMMobileAppBuilder
//


#import "ROUtils.h"

@implementation ROUtils

+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

@end
