//
//  NSDecimalNumber+RO.m
//  IBMMobileAppBuilder
//

#import "NSDecimalNumber+RO.h"

@implementation NSDecimalNumber (RO)

+ (NSDecimalNumber *)ro_decimalNumberWithString:(NSString *)numberValue
{
    if (numberValue) {
        NSString *value = [numberValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
        return [NSDecimalNumber decimalNumberWithString:value];
    }
    return [NSDecimalNumber decimalNumberWithString:numberValue];
}

@end
