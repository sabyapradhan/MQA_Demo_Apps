//
//  NSDictionary+RO.m
//  IBMMobileAppBuilder
//

#import "NSDictionary+RO.h"
#import "NSDate+RO.h"

@implementation NSDictionary (RO)

- (NSString *)ro_stringForKey:(id)key {
    
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSString class]]) {

        return object;
    
    } else if ([object isKindOfClass:[NSNumber class]]) {
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        return [formatter stringFromNumber:object];
    
    }
    
    return nil;
}

- (NSNumber *)ro_numberForKey:(id)key {
    
    return [self ro_numberForKey:key format:nil];
}

- (NSNumber *)ro_numberForKey:(id)key format:(NSNumberFormatter *)format {
    
    NSNumber *number = nil;
    
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]]) {
        
        number = object;
        
    } else if ([object isKindOfClass:[NSString class]]) {
        
        object = [object stringByReplacingOccurrencesOfString:@"," withString:@"."];
        
        if (format == nil) {
            format = [NSNumberFormatter new];
            [format setNumberStyle:NSNumberFormatterDecimalStyle];
        }
        number = [format numberFromString:object];
    }
    
    return number;
}

- (double)ro_doubleForKey:(id)key {
    
    NSNumber *number = [self ro_numberForKey:key format:nil];
    
    if (number) {
        
        double doble = [number doubleValue];
        return doble;
        
    }
    
    return 0;
}

- (NSDate *)ro_dateForKey:(id)key {
    
    return [self ro_dateForKey:key format:nil];
}

- (NSDate *)ro_dateForKey:(id)key format:(NSString *)format {
    
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSDate class]]) {
        
        return object;
        
    } else if ([object isKindOfClass:[NSString class]]) {
    
        if (format) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:format];
            
            NSDate *date = [dateFormatter dateFromString:object];
            
            return date;
            
        } else {
        
            return [NSDate dateWithValue:object];
            
        }
    }
    
    return nil;
}

@end
