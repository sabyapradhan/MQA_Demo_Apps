//
//  ROAnnotation.m
//  IBMMobileAppBuilder
//

#import "ROAnnotation.h"
#import "RORestGeoPoint.h"

@implementation ROAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    return self;
}

- (id)initWithItem:(id)item geoPoint:(RORestGeoPoint *)geoPoint title:(NSString *)title subtitle:(NSString *)subtitle {

    self = [self initWithItem:item geoPoint:geoPoint];
    if (self) {
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

+ (id)annotationWithItem:(id)item geoPoint:(RORestGeoPoint *)geoPoint title:(NSString *)title subtitle:(NSString *)subtitle {

    return [[self alloc] initWithItem:item geoPoint:geoPoint title:title subtitle:subtitle];
}

- (id)initWithItem:(id)item geoPoint:(RORestGeoPoint *)geoPoint {
    
    self = [self init];
    if (self) {
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [geoPoint latitude];
        coordinate.longitude = [geoPoint longitude];
        
        _coordinate = coordinate;
        _item = item;
    }
    return self;
}

+ (id)annotationWithItem:(id)item geoPoint:(RORestGeoPoint *)geoPoint {
    
    return [[self alloc] initWithItem:item geoPoint:geoPoint];
}

- (BOOL)isEqualToAnnotation:(ROAnnotation *)annotation {
    
    return [self.title isEqualToString:annotation.title] &&
        [self.subtitle isEqualToString:annotation.subtitle] &&
        self.coordinate.latitude == annotation.coordinate.latitude &&
        self.coordinate.longitude == annotation.coordinate.longitude;
}

@end
