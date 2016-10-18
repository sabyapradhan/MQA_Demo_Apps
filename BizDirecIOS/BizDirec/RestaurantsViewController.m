//
//  RestaurantsViewController.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "RestaurantsViewController.h"
#import "DatasourceManager.h"
#import "ROUtils.h"
#import "RORefreshBehavior.h"
#import "RestaurantsDetailViewController.h"
#import "UILabel+RO.h"
#import "ROTextStyle.h"
#import "ROSearchBehavior.h"
#import "UIImageView+RO.h"
#import "ROStyle.h"
#import "RONavigationAction.h"
#import "ROListDataLoader.h"
#import "ROOptionsFilter.h"
#import "ROTableViewCell.h"
#import "RestaurantsDSItem.h"
#import "RestaurantsDS.h"
#import "UIImage+RO.h"

@interface RestaurantsViewController ()

@property (nonatomic, strong) ROOptionsFilter *optionsFilter;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation RestaurantsViewController

static NSString * const kReuseIdentifier = @"Cell";

- (instancetype)init {

    self = [super init];
    if (self) {

        self.dataLoader = [[ROListDataLoader alloc] initWithDatasource:[[DatasourceManager sharedInstance] restaurantsDS]
                                                         optionsFilter:self.optionsFilter];

        [self.behaviors addObject:[ROSearchBehavior behaviorViewController:self]];
        
        [self.behaviors addObject:[RORefreshBehavior behaviorViewController:self]];
        
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [[[ROUtils sharedInstance] analytics] logPage:@"Restaurants"];

    self.title = NSLocalizedString(@"Restaurants", nil);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }

    [self updateViewConstraints];

    [self loadData];
}

#pragma mark - Properties init

- (ROOptionsFilter *)optionsFilter {

    if (!_optionsFilter) {

        _optionsFilter = [ROOptionsFilter new];
        
    }
    return _optionsFilter;
}

#pragma mark - Data delegate

- (void)loadData {

    [super loadData];
}

- (void)loadDataSuccess:(id)dataObject {

    [super loadDataSuccess:dataObject];
}

- (void)loadDataError:(ROError *)error {

    [super loadDataError:error];
}

#pragma mark - Private methods

- (void)configureCell:(ROTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    RestaurantsDSItem *item = self.items[(NSUInteger)indexPath.row];
    [cell.photoImageView ro_setImage:[self.dataLoader.datasource imagePath:item.picture] imageError:[[ROStyle sharedInstance] noPhotoImage]];
    cell.titleLabel.text = item.name;
    cell.detailLabel.text = item.rating;
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ROTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (cell == nil) {
        
        cell = [[ROTableViewCell alloc] initWithROStyle:ROTableViewCellStylePhotoTitleDescription
                                        reuseIdentifier:kReuseIdentifier];

        [cell.titleLabel ro_style:[ROTextStyle style:ROFontSizeStyleSmall
                                                bold:YES
                                              italic:NO
                                        textAligment:NSTextAlignmentLeft]];

        [cell.detailLabel ro_style:[ROTextStyle style:ROFontSizeStyleMedium
                                                bold:NO
                                              italic:NO
                                        textAligment:NSTextAlignmentLeft
                                           textColor:@"#f67e00"]];
    
        // You can customize the accessory icon ...
        UIImage *accessoryImage = [[UIImage ro_imageNamed:@"arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:accessoryImage];
        
        accessoryImageView.tintColor = [[ROStyle sharedInstance] accentColor];
        
        cell.accessoryView = accessoryImageView;
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
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RestaurantsDSItem *item = self.items[(NSUInteger)indexPath.row];
    RestaurantsDetailViewController *destinationViewController = [RestaurantsDetailViewController new];
    destinationViewController.dataItem = item;
    [self.navigationController pushViewController:destinationViewController
                                         animated:YES];
}

@end
