//
//  RONearFilter.m
//  IBMMobileAppBuilder
//

#import "RONearFilter.h"

@implementation RONearFilter

- (instancetype)initWithFieldName:(NSString *)fieldName coord:(CLLocationCoordinate2D)coord {

    self = [super init];
    if (self) {
        _fieldName = fieldName;
        _coord = coord;
    }
    return self;
}

+ (instancetype)filterWithFieldName:(NSString *)fieldName coord:(CLLocationCoordinate2D)coord {

    return [[self alloc] initWithFieldName:fieldName coord:coord];
}

- (NSArray *)fieldValue {

    return @[@(_coord.longitude), @(_coord.latitude)];
}

- (NSString *)getQueryString {

    NSString *query = [NSString stringWithFormat:@"\"%@\":{\"$near\":{\"$geometry\":{\"type\":\"Point\",\"coordinates\":[%f,%f]}}}", _fieldName, _coord.longitude, _coord.latitude];
    
    NSLog(@"\nNear QUERY: %@\n", query);
    
    return query;
}

- (BOOL)applyFilter:(NSObject *)fieldValue {

    return _fieldName != nil;
}

@end