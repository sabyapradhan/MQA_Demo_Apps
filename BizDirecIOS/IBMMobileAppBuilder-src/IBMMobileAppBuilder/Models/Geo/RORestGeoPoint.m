//
//  RORestGeoPoint.m
//  IBMMobileAppBuilder
//

#import "RORestGeoPoint.h"
#import "NSDictionary+RO.h"

static NSString *const kType        = @"type";
static NSString *const kCoordinates = @"coordinates";

static NSString *const kTypeDefault = @"Point";

@implementation RORestGeoPoint

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    
    self.type = [dictionary ro_stringForKey:kType];
    NSArray *coord = [dictionary objectForKey:kCoordinates];
    if (coord && [coord count] != 0) {
        self.coordinates = coord;
    }
}

- (NSString *)type {
    
    if (!_type) {
        _type = kTypeDefault;
    }
    return _type;
}

- (NSArray *)coordinates {
    
    if (!_coordinates) {
        _coordinates = @[@0, @0];
    }
    return _coordinates;
}

- (NSDictionary *)jsonValue {
    
    return [self dictionaryWithValuesForKeys:@[@"type", @"coordinates"]];
}

- (double)latitude {
    
    if (self.coordinates && [self.coordinates count] > 1) {
        NSNumber *res = [self.coordinates objectAtIndex:1];
        return [res doubleValue];
    }
    
    return 0;
}

- (double)longitude {
    
    if (self.coordinates && [self.coordinates count] > 0) {
        NSNumber *res = [self.coordinates objectAtIndex:0];
        return [res doubleValue];
    }
    
    return 0;
}

- (NSString *)stringValue {

    double lat = [self latitude];
    double lng = [self longitude];
    if (lat != 0.0 && lng != 0.0) {
        return [NSString stringWithFormat:@"%.8lf, %.8lf", [self latitude], [self longitude]];
    }
    return @"";
}

@end
