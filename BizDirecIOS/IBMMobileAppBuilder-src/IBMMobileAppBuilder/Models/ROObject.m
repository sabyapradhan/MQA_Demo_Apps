//
//  ROObject.m
//  IBMMobileAppBuilder
//

#import "ROObject.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration.h"
#import "ROUtils.h"

@implementation ROObject

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        if (attributes) {
            NSMutableDictionary *attr = [[NSMutableDictionary alloc] initWithDictionary:attributes];
            if ([attr objectForKey:@"id"]) {
                [attr setObject:[attr objectForKey:@"id"] forKey:@"objectId"];
                [attr removeObjectForKey:@"id"];
            }
            @try {
                [self setValuesForKeysWithDictionary:attr];
            }
            @catch (NSException *exception) {
                
                [[[ROUtils sharedInstance] logger] name:NSStringFromClass([self class])
                                                    log:exception.name
                                                  level:ROLoggerLevelError
                                               metadata:exception.userInfo];
            }
            @finally {
                return self;
            }    
        }
    }
    return self;
}

- (id)initWithPlistName:(NSString *)plistName
{
    NSDictionary *attributes = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:plistName ofType:@"plist"]];
    return [self initWithAttributes:attributes];
}

- (id)initWithDefaultResource {
    self = [self initWithPlistName:NSStringFromClass([self class])];
    if (self) {
        
    }
    return self;
}

+ (id)objectWithAttributes:(NSDictionary *)attributes
{
    if (attributes) {
        NSMutableDictionary *attr = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        if ([attr objectForKey:@"id"]) {
            // Fix id name property
            [attr setObject:[attr objectForKey:@"id"] forKey:@"objectId"];
            [attr removeObjectForKey:@"id"];
        }
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        config.datePattern = @"yyyy-MM-dd'T'HH:mm:ssZ";
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[self class] andConfiguration:config];
        return [parser parseDictionary:attr];
    } else {
        return nil;
    }
}

@end
