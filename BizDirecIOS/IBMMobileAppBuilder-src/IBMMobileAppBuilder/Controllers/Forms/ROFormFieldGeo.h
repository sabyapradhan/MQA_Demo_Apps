//
//  ROFormFieldGeo.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFormFieldDelegate.h"

@class ROGeoFieldTableViewCell;

@interface ROFormFieldGeo : NSObject <ROFormFieldDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) id value;

@property (nonatomic, assign) BOOL required;

@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) NSString *placeHolder;

@property (nonatomic, strong) UITextField *latitudeField;

@property (nonatomic, strong) UITextField *longitudeField;

@property (nonatomic, strong) ROGeoFieldTableViewCell *cell;

- (instancetype)initWithLabel:(NSString *)label
                         name:(NSString *)name
                     required:(BOOL)required;

+ (instancetype)fieldWithLabel:(NSString *)label
                          name:(NSString *)name
                      required:(BOOL)required;

- (ROGeoFieldTableViewCell *)fieldCell;

- (void)currentLocation;

@end
