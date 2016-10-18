//
//  ROStringFilter.m
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROStringListFilter.h"
#import "NSNumber+RO.h"

@implementation ROStringListFilter

+ (ROStringListFilter *)create:(NSString *)fieldName values:(NSMutableArray *)values {
    
    ROStringListFilter *theFilter = [[ROStringListFilter alloc] initWith:fieldName andValues:values];
    return theFilter;
}

- initWith:(NSString *)fieldName andValues:(NSMutableArray *)values {
    
    self = [super init];
    if(self){
        _fieldName = fieldName;
        _fieldValue = values;
    }
    return self;
}

- (BOOL)applyFilter:(NSObject *)value {
    
    if (_fieldValue == nil || _fieldValue.count == 0){
        return YES;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        
        value = [(NSNumber *)value ro_stringValue];
    }
    
    for (NSString *filter in _fieldValue) {
        if ([[filter description] compare:[value description]] == NSOrderedSame)
            return YES;
    }
    
    return NO;
}

- (NSString *)getQueryString {
    
    if(_fieldValue == nil || _fieldValue.count == 0)
        return nil;
    
    NSMutableString *res = [NSMutableString stringWithString:@"\""];
    [res appendString:_fieldName];
    [res appendString:@"\":{\"$in\":[\""];
    [res appendString:[_fieldValue componentsJoinedByString:@"\",\""]];
    
    return [res stringByAppendingString:@"\"]}"];
}

@end