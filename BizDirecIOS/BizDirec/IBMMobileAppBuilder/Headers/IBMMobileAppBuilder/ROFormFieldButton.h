//
//  ROFormFieldButton.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFormFieldDelegate.h"

typedef void(^ROFormFieldButtonTap)(id sender);

@interface ROFormFieldButton : NSObject <ROFormFieldDelegate>

@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) NSString *name;

@property (nonatomic) id value;

@property (copy, nonatomic) ROFormFieldButtonTap tapBlock;

- (instancetype)initWithLabel:(NSString *)label tapBlock:(ROFormFieldButtonTap)tapBlock;

+ (instancetype)fieldWithLabel:(NSString *)label tapBlock:(ROFormFieldButtonTap)tapBlock;

@end
