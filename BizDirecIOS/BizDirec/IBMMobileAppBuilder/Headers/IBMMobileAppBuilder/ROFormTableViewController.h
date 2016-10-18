//
//  ROFormTableViewController.h
//  IBMMobileAppBuilder
//

#import "ROViewController.h"
#import "ROFormFieldDelegate.h"

@interface ROFormTableViewController : ROViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) NSMutableArray *fields;

@property (nonatomic, strong) UIToolbar *keyboardToolbar;

@property (nonatomic, strong) NSMutableArray *responders;

@property (nonatomic, strong) NSMutableDictionary *hiddenValues;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (void)configureFormView;

- (void)keyboardWillShow:(NSNotification *)notification;

- (void)keyboardWillHide:(NSNotification *)notification;

- (BOOL)validate;

- (NSMutableDictionary *)jsonValues;

- (id<ROFormFieldDelegate>)fieldAtIndexPath:(NSIndexPath *)indexPath;

@end
