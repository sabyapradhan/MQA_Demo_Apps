//
//  ROMapViewController.m
//  IBMMobileAppBuilder
//

#import "ROMapViewController.h"
#import "ROBoundingBoxFilter.h"
#import "RONearFilter.h"
#import "ROOptionsFilter.h"
#import "ROBehavior.h"
#import "UIViewController+RO.h"

@interface ROMapViewController ()

@end

@implementation ROMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.locationManager.delegate = self;
    
    self.annotations = [NSMutableDictionary new];
    
    [self loadMapView];

    MKUserTrackingBarButtonItem *trackButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    
    [self ro_addBottomBarButton:trackButton
                       animated:NO];
    
    for (NSObject<ROBehavior> *behavior in self.behaviors) {
        
        [behavior viewDidLoad];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    for (id<ROBehavior> behavior in self.behaviors) {
        
        if ([behavior respondsToSelector:@selector(viewDidAppear:)]) {
            
            [behavior viewDidAppear:animated];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    for (id<ROBehavior> behavior in self.behaviors) {
        
        if ([behavior respondsToSelector:@selector(viewDidDisappear:)]) {
            
            [behavior viewDidDisappear:animated];
        }
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CLLocationManager *)locationManager {

    if (!_locationManager) {
        
        _locationManager = [CLLocationManager new];
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            
            [_locationManager requestWhenInUseAuthorization];
        }
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            
            [_locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}

- (MKMapView *)mapView {

    if (!_mapView) {
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MKUserTrackingModeNone];
    }
    return _mapView;
}

- (void)loadMapView {

    [self.view addSubview:self.mapView];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_mapView);
    
    // align tableView from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mapView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    // align tableView from the top and bottom
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mapView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
}

- (void)showUserLocation:(MKUserLocation *)userLocation {
    
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    
    [self showCoordinate:location animated:NO];
}

- (void)showCoordinate:(CLLocationCoordinate2D)coord animated:(BOOL)animate {

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    region.span = span;
    region.center = coord;
    [self.mapView setRegion:region animated:animate];
}

- (void)addAnnotation:(id<MKAnnotation>)annotation {

    if (annotation) {
        
        NSString *key = [self annotationKey:annotation];
        if ([self.annotations objectForKey:key] == nil) {
            
            [self.annotations setObject:annotation forKey:key];
            [self.mapView addAnnotation:annotation];
        }
    }
}

- (void)removeAnnotations {
    
    [self.annotations removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (NSString *)annotationKey:(id<MKAnnotation>)annotation {

    CLLocationCoordinate2D coord = [annotation coordinate];
    return [NSString stringWithFormat:@"%f, %f", coord.latitude, coord.longitude];
}

- (ROBoundingBoxFilter *)boundingBoxFilterWithFieldName:(NSString *)fieldName {

    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint neMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), mRect.origin.y);
    MKMapPoint swMapPoint = MKMapPointMake(mRect.origin.x, MKMapRectGetMaxY(mRect));
    CLLocationCoordinate2D neCoord = MKCoordinateForMapPoint(neMapPoint);
    CLLocationCoordinate2D swCoord = MKCoordinateForMapPoint(swMapPoint);
#ifdef DEBUG
    NSLog(@"\nbottomLeft: [%f,%f]\nupperRight: [%f,%f]\n", swCoord.longitude, swCoord.latitude, neCoord.longitude, neCoord.latitude);
#endif
    return [ROBoundingBoxFilter filterWithFieldName:fieldName neCoord:neCoord swCoord:swCoord];
}

- (void)setBoundingBoxFilterWithFieldName:(NSString *)fieldName {

    [self removeBoundingBoxFilter];
    self.boundingBoxFilter = [self boundingBoxFilterWithFieldName:fieldName];
    [self.dataLoader.optionsFilter.filters addObject:self.boundingBoxFilter];
}

- (void)removeBoundingBoxFilter {
    
    if (self.boundingBoxFilter) {
        
        [self.dataLoader.optionsFilter.filters removeObject:self.boundingBoxFilter];
    }
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    [manager stopUpdatingLocation];
    
    self.userLocationLoaded = YES;
    
    CLLocation *location = [locations lastObject];
    
    NSLog(@"didUpdateLocations: %@", location);
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = location.coordinate.latitude;
    coordinate.longitude = location.coordinate.longitude;
    
    [self showCoordinate:coordinate animated:NO];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Location manager error: %@", error.localizedDescription);
    self.userLocationLoaded = NO;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
    
        case kCLAuthorizationStatusDenied: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location services not authorized", nil)
                                                            message:NSLocalizedString(@"This app needs you to authorize locations services to work.", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                                  otherButtonTitles:nil];
            [alert show];
            
            break;
        }
        default:
            NSLog(@"Location auth status: %d", status);
            break;
    }
}

@end
