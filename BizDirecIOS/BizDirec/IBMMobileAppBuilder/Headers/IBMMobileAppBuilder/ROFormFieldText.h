//
//  ROFormFieldText.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFormFieldDelegate.h"

@class ROTextFieldTableViewCell;

@interface ROFormFieldText : NSObject <ROFormFieldDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) id value;

@property (nonatomic, assign) BOOL required;

@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) NSString *placeHolder;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) ROTextFieldTableViewCell *cell;

- (instancetype)initWithLabel:(NSString *)label
                         name:(NSString *)name
                     required:(BOOL)required;

+ (instancetype)fieldWithLabel:(NSString *)label
                          name:(NSString *)name
                      required:(BOOL)required;

- (NSString *)fieldValue;

- (ROTextFieldTableViewCell *)fieldCell;

@end
