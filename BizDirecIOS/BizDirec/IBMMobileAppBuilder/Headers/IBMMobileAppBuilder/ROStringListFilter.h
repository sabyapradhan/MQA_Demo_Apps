//
//  StringListFilter.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFilter.h"

/**
 * String list filter
 */
@interface ROStringListFilter : NSObject  <ROFilter>

@property (nonatomic, strong) NSString *fieldName;

@property (nonatomic, strong) NSArray *fieldValue;

+ (ROStringListFilter *)create:(NSString *)fieldName values:(NSMutableArray *)values;

@end