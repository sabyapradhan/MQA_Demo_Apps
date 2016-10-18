//
//  ROFormFieldBoolNullable.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFormFieldDelegate.h"

@interface ROFormFieldTristateBool : NSObject <ROFormFieldDelegate>

@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) id value;

@property (nonatomic, strong) UITableViewCell *cell;

- (instancetype)initWithLabel:(NSString *)label
                         name:(NSString *)name;

+ (instancetype)fieldWithLabel:(NSString *)label
                          name:(NSString *)name;

- (NSString *)fieldValue;

- (UITableViewCell *)fieldCell;

@end
