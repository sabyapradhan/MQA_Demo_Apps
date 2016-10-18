//
//  ROFormFieldSelectionMultiple.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFilterField.h"
#import "RODatasource.h"

@class ROFilterViewController;

@interface ROFilterFieldSelection : NSObject <ROFilterField>

@property (nonatomic, strong) NSString *fieldLabel;

@property (nonatomic, strong) NSString *fieldName;

@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) NSArray *options;

@property (nonatomic, strong) NSMutableArray *optionsSelected;

@property (nonatomic, assign) BOOL single;

@property (nonatomic, strong) ROFilterViewController *formController;

@property (nonatomic, strong) id<RODatasource> datasource;

@property (nonatomic, assign) BOOL required;

- (instancetype)initWithFieldLabel:(NSString *)fieldLabel
                         fieldName:(NSString *)fieldName
                    formController:(ROFilterViewController *)formController
                            single:(BOOL)single;

+ (instancetype)fieldLabel:(NSString *)fieldLabel
                 fieldName:(NSString *)fieldName
            formController:(ROFilterViewController *)formController
                            single:(BOOL)single;

@end
