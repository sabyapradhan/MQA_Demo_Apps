//
//  HealthClubsDetailViewController.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "HealthClubsDetailViewController.h"
#import "DatasourceManager.h"
#import "ROUtils.h"
#import "ROShareBehavior.h"
#import "ROMapSearchAction.h"
#import "ROPhoneAction.h"
#import "ROTextStyle.h"
#import "ROImageCellDescriptor.h"
#import "ROTextCellDescriptor.h"
#import "ROHeaderCellDescriptor.h"
#import "ROOptionsFilter.h"
#import "ROSingleDataLoader.h"
#import "GymsScreen1DSItem.h"
#import "GymsScreen1DS.h"

@interface HealthClubsDetailViewController ()

@property (nonatomic, strong) ROOptionsFilter *optionsFilter;

@end

@implementation HealthClubsDetailViewController

- (instancetype)init {

    self = [super init];
    if (self) {

        self.dataLoader = [[ROSingleDataLoader alloc] initWithDatasource:[[DatasourceManager sharedInstance] gymsScreen1DS]
                                                           optionsFilter:self.optionsFilter];
    
        [self.behaviors addObject:[ROShareBehavior behaviorViewController:self]];
        
    }
    return self;
}

#pragma mark - Properties init

- (ROOptionsFilter *)optionsFilter {

    if (!_optionsFilter) {
        _optionsFilter = [ROOptionsFilter new];
    }
    return _optionsFilter;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [[[ROUtils sharedInstance] analytics] logPage:@"HealthClubsDetail"];

    self.title = NSLocalizedString(@"", nil);
    
    self.customTableViewDelegate = self;

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }

    [self updateViewConstraints];

    [self loadData];
}

#pragma mark - ROCustomTableViewDelegate

- (void)configureWithDataItem:(GymsScreen1DSItem *)item {
    self.items = @[
                   [ROTextCellDescriptor text:item.name action:nil textStyle:[ROTextStyle style:ROFontSizeStyleLarge bold:YES italic:NO textAligment:NSTextAlignmentLeft]],
                   [ROTextCellDescriptor text:item.descriptionProp action:nil textStyle:[ROTextStyle style:ROFontSizeStyleMedium bold:NO italic:NO textAligment:NSTextAlignmentLeft]],
                   [ROHeaderCellDescriptor text:@"Phone"],
                   [ROTextCellDescriptor text:item.phone action:[[ROPhoneAction alloc] initWithValue:item.phone] textStyle:[ROTextStyle style:ROFontSizeStyleSmall bold:NO italic:NO textAligment:NSTextAlignmentLeft]],
                   [ROHeaderCellDescriptor text:@"Address"],
                   [ROTextCellDescriptor text:item.address action:[[ROMapSearchAction alloc] initWithValue:[item.location stringValue]] textStyle:[ROTextStyle style:ROFontSizeStyleSmall bold:NO italic:NO textAligment:NSTextAlignmentLeft]]
                  ];
}

@end
