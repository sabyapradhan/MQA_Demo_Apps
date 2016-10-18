//
//  MainMenuViewController.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "CategoriesViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "RONavigationAction.h"
#import "ROTableViewCell.h"
#import "UILabel+RO.h"
#import "ROTextStyle.h"
#import "ROStyle.h"
#import "ROItemCell.h"
#import "MainMenuViewController.h"

@interface MainMenuViewController ()

- (void)configureCell:(ROTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MainMenuViewController

static NSString * const kReuseIdentifier = @"Cell";

- (instancetype)init {

    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    UIViewController *rootViewController = self.slidingViewController ? self.slidingViewController : self;

    self.items = @[
                   
                   [[ROItemCell alloc] initWithText1:@"Categories"
                                            atAction:[[RONavigationAction alloc] initWithRootViewController:rootViewController destinationValue:[CategoriesViewController class]]]
                  ];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {

        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {

        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }

    [self updateViewConstraints];    
}

#pragma mark - Private methods

- (void)configureCell:(ROTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    ROItemCell *item = self.items[(NSUInteger)indexPath.row];
    cell.titleLabel.text = item.text1;
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ROTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (cell == nil) {

        cell = [[ROTableViewCell alloc] initWithROStyle:ROTableViewCellStyleTitle
                                        reuseIdentifier:kReuseIdentifier];
                                        
        [cell.titleLabel ro_style:[ROTextStyle style:ROFontSizeStyleSmall
                                                bold:NO
                                              italic:NO
                                        textAligment:NSTextAlignmentLeft]];                                        
    }
    cell.backgroundColor = [UIColor clearColor];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.items count];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {

        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {

        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ROItemCell *item = self.items[(NSUInteger)indexPath.row];
    [item.action doAction];
}

@end
