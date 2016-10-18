//
//  NSNumber+RO.m
//  IBMMobileAppBuilder
//

#import "NSNumber+RO.h"

@implementation NSNumber (RO)

- (NSString *)ro_stringValue {
        
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:20];
    [formatter setDecimalSeparator:@"."];
    [formatter setUsesGroupingSeparator:NO];
    return [formatter stringFromNumber:self];
}

- (NSString *)ro_boolStringValue {
    
    if ([self boolValue]) {
        
        return NSLocalizedString(@"YES", nil);
        
    } else {
        
        return NSLocalizedString(@"NO", nil);
    }
}

@end
