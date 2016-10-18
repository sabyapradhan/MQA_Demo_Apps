//
//  RODetailViewController.h
//  IBMMobileAppBuilder
//

#import "ROViewController.h"
#import "RODataDelegate.h"
#import "RODataItemDelegate.h"

@protocol ROCustomTableViewDelegate <NSObject>

- (void)setDataItem:(NSObject *)dataItem;

- (void)configureWithDataItem:(NSObject *)dataItem;

@end

@interface ROCustomTableViewController : ROViewController <RODataDelegate, RODataItemDelegate, UITableViewDataSource, UITableViewDelegate>

/**
 *  Table view
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  Table view style
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

/**
 *  Items to load
 */
@property (nonatomic, strong) NSArray *items;

/**
 Custom object to show
 */
@property (nonatomic, strong) NSObject *dataItem;

/**
 ROCustomTableViewDelegate
 */
@property (nonatomic, weak) id<ROCustomTableViewDelegate> customTableViewDelegate;

@end
