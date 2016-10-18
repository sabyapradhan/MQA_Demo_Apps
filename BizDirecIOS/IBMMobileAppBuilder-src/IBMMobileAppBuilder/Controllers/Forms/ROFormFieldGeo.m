//
//  ROFormFieldGeo.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldGeo.h"
#import "ROGeoFieldTableViewCell.h"
#import "RORestGeoPoint.h"
#import "NSNumber+RO.h"
#import "NSDecimalNumber+RO.h"
#import "NSString+RO.h"
#import <CoreLocation/CoreLocation.h>

static NSString *const kGeoFieldIdentifier     = @"geoFieldIdentifier";

@interface ROFormFieldGeo () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *latString;

@property (nonatomic, strong) NSString *lngString;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ROFormFieldGeo

- (instancetype)initWithLabel:(NSString *)label name:(NSString *)name required:(BOOL)required {
    
    self = [super init];
    if (self) {
        _label = label;
        _name = name;
        _required = required;
    }
    return self;
}

+ (instancetype)fieldWithLabel:(NSString *)label name:(NSString *)name required:(BOOL)required {
    
    return [[self alloc] initWithLabel:label name:name required:required];
}

- (void)dealloc {
    
    if (_label) {
        _label = nil;
    }
    if (_name) {
        _name = nil;
    }
    if (_value) {
        _value = nil;
    }
    if (_latString) {
        _latString = nil;
    }
    if (_lngString) {
        _lngString = nil;
    }
    if (_placeHolder) {
        _placeHolder = nil;
    }
    if (_latitudeField) {
        _latitudeField = nil;
    }
    if (_latitudeField) {
        _longitudeField = nil;
    }
    if (_locationManager) {
        _locationManager = nil;
    }
}

- (id)value {
    
    if (_latString && _lngString) {
        RORestGeoPoint *geoPoint = [RORestGeoPoint new];
        geoPoint.coordinates = @[
                                 [NSDecimalNumber ro_decimalNumberWithString:_lngString],
                                 [NSDecimalNumber ro_decimalNumberWithString:_latString]
                                 ];
        _value = geoPoint;
    }
    return _value;
}

- (id)jsonValue {
    
    if (self.value) {
        if ([self.value respondsToSelector:@selector(jsonValue)]) {
            return [self.value jsonValue];
        }
    }
    return [[RORestGeoPoint new] jsonValue];
}

- (UITextField *)latitudeField {
    
    return self.cell ? self.cell.latitudeField : nil;
}

- (UITextField *)longitudeField {
    
    return self.cell ? self.cell.longitudeField : nil;
}

- (ROGeoFieldTableViewCell *)cell {
    
    if (!_cell) {
        _cell = [self fieldCell];
    }
    return _cell;
}

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return _locationManager;
}

- (ROGeoFieldTableViewCell *)fieldCell {
    
    ROGeoFieldTableViewCell *cell = [[ROGeoFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                   reuseIdentifier:kGeoFieldIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.latitudeField.autocorrectionType = UITextAutocorrectionTypeNo;
    cell.latitudeField.delegate = self;
    cell.latitudeField.returnKeyType = UIReturnKeyDefault;
    self.latitudeField = cell.latitudeField;
    
    cell.longitudeField.autocorrectionType = UITextAutocorrectionTypeNo;
    cell.longitudeField.delegate = self;
    cell.longitudeField.returnKeyType = UIReturnKeyDefault;
    self.longitudeField = cell.longitudeField;
    
    [cell.locationButton addTarget:self action:@selector(currentLocation) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (BOOL)valid {
    
    BOOL isValid = YES;
    self.cell.errorLabel.text = nil;
    if (self.value && _latString && _lngString) {
        
        NSScanner *latScanner = [NSScanner scannerWithString:_latString];
        BOOL latIsNumeric = [latScanner scanDouble:NULL] && [latScanner isAtEnd];
        isValid = latIsNumeric;
        if (!latIsNumeric) {
            self.cell.errorLabel.text = NSLocalizedString(@"Invalid latitude: is not number", nil);
        } else {
            double lat = [[NSDecimalNumber ro_decimalNumberWithString:_latString] doubleValue];
            if (lat < -90 || lat > 90) {
                isValid = NO;
                self.cell.errorLabel.text = NSLocalizedString(@"Invalid latitude: out of range", nil);
            } else {
                NSScanner *lngScanner = [NSScanner scannerWithString:_lngString];
                BOOL lngIsNumeric = [lngScanner scanDouble:NULL] && [lngScanner isAtEnd];
                isValid = lngIsNumeric;
                if (!lngIsNumeric) {
                    self.cell.errorLabel.text = NSLocalizedString(@"Invalid longitude: is not number", nil);
                } else {
                    double lng = [[NSDecimalNumber ro_decimalNumberWithString:_lngString] doubleValue];
                    if (lng < -180 || lng > 180) {
                        isValid = NO;
                        self.cell.errorLabel.text = NSLocalizedString(@"Invalid longitude: out of range", nil);
                    } else if ([self.value isKindOfClass:[RORestGeoPoint class]]) {
                        
                        RORestGeoPoint *geoPoint = (RORestGeoPoint *)self.value;
                        if ([geoPoint.coordinates count] != 2) {
                            NSLog(@"Geo not complete");
                        }
                    } else {
                        NSLog(@"Invalid type");
                    }
                }
            }
        }
        
    } else if (self.required) {
        self.cell.errorLabel.text = NSLocalizedString(@"Required", nil);
        isValid = NO;
    }
    return isValid;
}

- (void)reset {
    
    self.value = nil;
    self.latString = nil;
    self.lngString = nil;
    self.latitudeField.text = nil;
    self.longitudeField.text = nil;
    self.cell.errorLabel.text = nil;
}

- (NSString *)latString {
    
    if (!_latString || (_latString && [[_latString ro_trim] length] == 0)) {
        if ([self.value respondsToSelector:@selector(latitude)]) {
            double lat = [self.value latitude];
            if (lat != 0.0) {
                _latString = [NSString stringWithFormat:@"%.8lf", lat];
            }
        }
    }
    return _latString;
}

- (NSString *)lngString {
    
    if (!_lngString || (_lngString && [[_lngString ro_trim] length] == 0)) {
        if ([self.value respondsToSelector:@selector(longitude)]) {
            double lng = [self.value longitude];
            if (lng != 0.0) {
                _lngString = [NSString stringWithFormat:@"%.8lf", lng];
            }
        }
    }
    return _lngString;
}

- (void)currentLocation {
    
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                         message:NSLocalizedString(@"Failed to Get Your Location", nil)
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSString *lng = [NSString stringWithFormat:@"%.8lf", currentLocation.coordinate.longitude];
        NSString *lat = [NSString stringWithFormat:@"%.8lf", currentLocation.coordinate.latitude];
        
        [self reset];
        
        self.latString = lat;
        self.latitudeField.text = lat;
        
        self.lngString = lng;
        self.longitudeField.text = lng;
    }
}

#pragma mark - Text field

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.latitudeField) {
        
        self.latString = self.latitudeField.text;
        
    } else if (textField == self.longitudeField) {
        
        self.lngString = self.longitudeField.text;
        
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (textField == self.latitudeField) {
        
        self.latString = nil;
        
    } else if (textField == self.longitudeField) {
        
        self.lngString = nil;
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UI

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ROGeoFieldTableViewCell *cell = self.cell;
    cell.label.text = self.label;
    cell.latitudeField.placeholder = NSLocalizedString(@"Latitude", nil);
    cell.latitudeField.text = self.latString;
    cell.latitudeField.tag = indexPath.row;
    
    cell.longitudeField.placeholder = NSLocalizedString(@"Longitude", nil);
    cell.longitudeField.text = self.lngString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.latitudeField becomeFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 66.0f;
}

@end
