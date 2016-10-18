//
//  ROMapViewDelegate.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol ROMapViewDelegate <NSObject>

- (id <MKAnnotation>)annotationWithItem:(id)item;

@optional

- (void)calloutTapped:(MKAnnotationView *)view;

@end
