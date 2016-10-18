//
//  RONearFilter.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFilter.h"
#import <CoreLocation/CoreLocation.h>

@interface RONearFilter : NSObject <ROFilter>

@property (nonatomic, strong) NSString *fieldName;

@property (nonatomic, assign) CLLocationCoordinate2D coord;

@property (nonatomic, strong) NSArray *fieldValue;

- (instancetype)initWithFieldName:(NSString *)fieldName coord:(CLLocationCoordinate2D)coord;

+ (instancetype)filterWithFieldName:(NSString *)fieldName coord:(CLLocationCoordinate2D)coord;

@end
