//
//  CategoriesViewController.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "CategoriesViewController.h"
#import "DatasourceManager.h"
#import "ROUtils.h"
#import "RORefreshBehavior.h"
#import "UIImageView+RO.h"
#import "ROTableViewCell.h"
#import "RestaurantsViewController.h"
#import "LegalServicesViewController.h"
#import "HealthClubsViewController.h"
#import "CarDealersViewController.h"
#import "RONavigationAction.h"
#import "ROStyle.h"
#import "ROItemCell.h"

@interface CategoriesViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation CategoriesViewController

static NSString * const kReuseIdentifier = @"Cell";

- (instancetype)init {

    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [[[ROUtils sharedInstance] analytics] log:@"Categories"];

    self.title = NSLocalizedString(@"Categories", nil);
    self.items = @[                       
                       [[ROItemCell alloc] initWithText1:@"AUTO"
                                         atImageResource:@"AUTO951.png"
                                                atAction:[[RONavigationAction alloc] initWithRootViewController:self destinationValue:[CarDealersViewController class]]],
                       [[ROItemCell alloc] initWithText1:@"GYMS"
                                         atImageResource:@"GYMS477.png"
                                                atAction:[[RONavigationAction alloc] initWithRootViewController:self destinationValue:[HealthClubsViewController class]]],
                       [[ROItemCell alloc] initWithText1:@"LAWYERS"
                                         atImageResource:@"LAWYERS790.png"
                                                atAction:[[RONavigationAction alloc] initWithRootViewController:self destinationValue:[LegalServicesViewController class]]],
                       [[ROItemCell alloc] initWithText1:@"RESTAURANTS"
                                         atImageResource:@"RESTAURANTS484.png"
                                                atAction:[[RONavigationAction alloc] initWithRootViewController:self destinationValue:[RestaurantsViewController class]]]
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
    [cell.photoImageView ro_setImage:item.imageResource imageError:[[ROStyle sharedInstance] noPhotoImage]];
    if (item.action && [item.action canDoAction]) {

        cell.userInteractionEnabled = YES;

    } else {

        cell.userInteractionEnabled = NO;
    }
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ROTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (cell == nil) {
        
        cell = [[ROTableViewCell alloc] initWithROStyle:ROTableViewCellStylePhotoTitle
                                        reuseIdentifier:kReuseIdentifier]; 
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
    if (item.action && [item.action canDoAction]) {
    
        [item.action doAction];
    }
}

@end
