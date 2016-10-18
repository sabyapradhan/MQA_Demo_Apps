//
//  ROAnnotation.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class RORestGeoPoint;

@interface ROAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic) id item;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate;

- (id)initWithItem:(id)item geoPoint:(RORestGeoPoint *)geoPoint title:(NSString *)title subtitle:(NSString *)subtitle;

+ (id)annotationWithItem:(id)item geoPoint:(RORestGeoPoint *)geoPoint title:(NSString *)title subtitle:(NSString *)subtitle;

- (id)initWithItem:(id)item geoPoint:(RORestGeoPoint *)geoPoint;

+ (id)annotationWithItem:(id)item geoPoint:(RORestGeoPoint *)geoPoint;

- (BOOL)isEqualToAnnotation:(ROAnnotation *)annotation;

@end
