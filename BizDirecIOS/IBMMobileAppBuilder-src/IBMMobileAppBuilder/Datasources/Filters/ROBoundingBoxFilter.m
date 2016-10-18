//
//  ROBoundingBoxFilter.m
//  IBMMobileAppBuilder
//

#import "ROBoundingBoxFilter.h"

@implementation ROBoundingBoxFilter

- (instancetype)initWithFieldName:(NSString *)fieldName neCoord:(CLLocationCoordinate2D)neCoord swCoord:(CLLocationCoordinate2D)swCoord {

    self = [super init];
    if (self) {
        _fieldName = fieldName;
        _neCoord = neCoord;
        _swCoord = swCoord;
    }
    return self;
}

+ (instancetype)filterWithFieldName:(NSString *)fieldName neCoord:(CLLocationCoordinate2D)neCoord swCoord:(CLLocationCoordinate2D)swCoord {

    return [[self alloc] initWithFieldName:fieldName neCoord:neCoord swCoord:swCoord];
}

- (NSArray *)fieldValue {

    return @[
             @[@(_neCoord.longitude), @(_neCoord.latitude)],
             @[@(_swCoord.longitude), @(_swCoord.latitude)]
             ];
}

- (NSString *)getQueryString {
    
    NSLog(@"\nBoundingBox QUERY:\n\"%@\":{\"$geoWithin\":{\"$box\":[[%f,%f],[%f,%f]]}}\n", _fieldName, _swCoord.longitude, _swCoord.latitude, _neCoord.longitude, _neCoord.latitude);
    
    return [NSString stringWithFormat:@"\"%@\":{\"$geoWithin\":{\"$box\":[[%f,%f],[%f,%f]]}}", _fieldName, _swCoord.longitude, _swCoord.latitude, _neCoord.longitude, _neCoord.latitude];
}

- (BOOL)applyFilter:(NSObject *)fieldValue {

    return _fieldName != nil;
}

@end
