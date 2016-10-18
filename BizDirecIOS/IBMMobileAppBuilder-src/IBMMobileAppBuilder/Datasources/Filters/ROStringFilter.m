//
//  ROStringFilter.m
//  IBMMobileAppBuilder
//

#import "ROStringFilter.h"
#import "NSNumber+RO.h"

@implementation ROStringFilter

- (instancetype)initWithFieldName:(NSString *)fieldName value:(NSString *)value {

    self = [super init];
    if (self) {
        _fieldName = fieldName;
        _fieldValue = value;
    }
    return self;
}

+ (instancetype)filterWithFieldName:(NSString *)fieldName value:(NSString *)value {
    
    return [[self alloc] initWithFieldName:fieldName value:value];
}

- (NSString *)getQueryString {

    return [NSString stringWithFormat:@"\"%@\":{\"$regex\":\"%@\",\"$options\":\"i\"}", _fieldName, _fieldValue];
}

- (BOOL)applyFilter:(NSObject *)fieldValue {
    
    if (_fieldValue == nil) {
        return YES;
    }
    
    NSString *fieldValueString;
    
    if ([fieldValue isKindOfClass:[NSNumber class]]) {
        
        fieldValueString = [(NSNumber *)fieldValue ro_stringValue];
    
    } else {
    
        fieldValueString = [fieldValue description];
    }
    
    if ([fieldValueString rangeOfString:_fieldValue options:NSCaseInsensitiveSearch].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

@end
