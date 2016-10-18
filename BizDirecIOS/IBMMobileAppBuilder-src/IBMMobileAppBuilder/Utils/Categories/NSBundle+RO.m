//
//  NSBundle+RO.m
//  IBMMobileAppBuilder
//

#import "NSBundle+RO.h"

@implementation NSBundle (RO)

+ (NSBundle*)ro_resourcesBundle
{
    static dispatch_once_t onceToken;
    static NSBundle *bundle = nil;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"IBMMobileAppBuilderResources" withExtension:@"bundle"]];
    });
    return bundle;
}

@end
