//
//  ROFormViewController.h
//  IBMMobileAppBuilder
//

#import "ROViewController.h"
#import "ROModel.h"

@class ROItemCell;

@protocol ROFilterDelegate <NSObject>

- (void)formSubmitted;

@end

@interface ROFilterViewController : ROViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) UIButton *submitButton;

@property (nonatomic, strong) NSArray *fields;

@property (nonatomic, strong) NSMutableArray *filters;

@property (nonatomic, weak) id<ROFilterDelegate> formDelegate;

+ (instancetype)form;

/**
 Configure constraints
 */
- (void)setupConstraints;

- (IBAction)submitButtonAction:(id)sender;

- (void)close;

- (void)cancel;

- (void)submit;

- (void)reset;

@end
