//
//  RONumberFilter.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFilter.h"

@interface RONumberFilter : NSObject <ROFilter>

@property (nonatomic, strong) NSString *fieldName;

@property (nonatomic, strong) NSNumber *fieldValue;

- (instancetype)initWithFieldName:(NSString *)fieldName value:(NSNumber *)value;

+ (instancetype)filterWithFieldName:(NSString *)fieldName value:(NSNumber *)value;

@end
