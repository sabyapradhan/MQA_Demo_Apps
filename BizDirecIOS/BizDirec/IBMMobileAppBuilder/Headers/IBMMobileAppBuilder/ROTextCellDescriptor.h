//
//  ROTextCellDescriptor.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROCellDescriptor.h"
#import "ROAction.h"

@class ROTextStyle;

@interface ROTextCellDescriptor : NSObject <ROCellDescriptor>

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSObject<ROAction> *action;

@property (nonatomic, strong) ROTextStyle *textStyle;

- (instancetype)initWithText:(NSString *)text action:(NSObject<ROAction> *)action;

+ (instancetype)text:(NSString *)text action:(NSObject<ROAction> *)action;

- (instancetype)initWithText:(NSString *)text action:(NSObject<ROAction> *)action textStyle:(ROTextStyle *)textStyle;

+ (instancetype)text:(NSString *)text action:(NSObject<ROAction> *)action textStyle:(ROTextStyle *)textStyle;

- (void)configureCell:(UITableViewCell *)cell;

@end
