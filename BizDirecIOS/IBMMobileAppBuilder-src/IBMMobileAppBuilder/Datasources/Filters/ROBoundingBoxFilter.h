//
//  ROBoundingBoxFilter.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFilter.h"
#import <MapKit/MapKit.h>

@interface ROBoundingBoxFilter : NSObject <ROFilter>

@property (nonatomic, strong) NSString *fieldName;

@property (nonatomic, strong) NSArray *fieldValue;

@property (nonatomic, assign) CLLocationCoordinate2D neCoord;

@property (nonatomic, assign) CLLocationCoordinate2D swCoord;

- (instancetype)initWithFieldName:(NSString *)fieldName neCoord:(CLLocationCoordinate2D)neCoord swCoord:(CLLocationCoordinate2D)swCoord;

+ (instancetype)filterWithFieldName:(NSString *)fieldName neCoord:(CLLocationCoordinate2D)neCoord swCoord:(CLLocationCoordinate2D)swCoord;

@end