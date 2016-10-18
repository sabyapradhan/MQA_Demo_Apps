//
//  ROMapViewController.h
//  IBMMobileAppBuilder
//

#import "ROViewController.h"
#import "ROMapViewDelegate.h"
#import <MapKit/MapKit.h>

@class ROBoundingBoxFilter;

@interface ROMapViewController : ROViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (assign) BOOL userLocationLoaded;

@property (nonatomic, strong) NSMutableDictionary *annotations;

@property (nonatomic, strong) ROBoundingBoxFilter *boundingBoxFilter;

@property (nonatomic, strong) NSString *locationFieldName;

@property (nonatomic, assign) id <ROMapViewDelegate> mapViewDelegate;

@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)loadMapView;

- (void)showUserLocation:(MKUserLocation *)userLocation;

- (void)showCoordinate:(CLLocationCoordinate2D)coord animated:(BOOL)animate;

- (void)addAnnotation:(id <MKAnnotation>)annotation;

- (void)removeAnnotations;

- (NSString *)annotationKey:(id<MKAnnotation>)annotation;

- (ROBoundingBoxFilter *)boundingBoxFilterWithFieldName:(NSString *)fieldName;

- (void)setBoundingBoxFilterWithFieldName:(NSString *)fieldName;

- (void)removeBoundingBoxFilter;

@end
