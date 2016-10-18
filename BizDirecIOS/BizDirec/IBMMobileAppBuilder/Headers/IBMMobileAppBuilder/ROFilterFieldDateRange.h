//
//  ROFormFieldRange.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFilterField.h"

@class ROFilterViewController;

@interface ROFilterFieldDateRange : NSObject <ROFilterField>

@property (nonatomic, strong) NSString *fieldLabel;
@property (nonatomic, strong) NSString *fieldName;
@property (nonatomic, assign) BOOL required;

@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic,strong) NSString *minLabel;
@property (nonatomic,strong) NSDate *minDate;
@property (nonatomic,strong) NSString *maxLabel;
@property (nonatomic,strong) NSDate *maxDate;

@property (nonatomic) id value;

@property (nonatomic, strong) ROFilterViewController *formController;

- (instancetype)initWithFieldLabel:(NSString *)fieldLabel
                         fieldName:(NSString *)fieldName
                    formController:(ROFilterViewController *)formController;

+ (instancetype)fieldLabel:(NSString *)fieldLabel
                 fieldName:(NSString *)fieldName
            formController:(ROFilterViewController *)formController;

@end
