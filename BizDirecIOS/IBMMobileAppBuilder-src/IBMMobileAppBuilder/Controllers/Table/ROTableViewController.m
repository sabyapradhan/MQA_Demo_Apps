//
//  ROTableViewController_.m
//  IBMMobileAppBuilder
//

#import "ROTableViewController.h"
#import "SVPullToRefresh.h"
#import "ROStyle.h"
#import "UIColor+RO.h"
#import "SVProgressHUD.h"
#import "ROError.h"
#import "UIView+RO.h"
#import "ROBehavior.h"
#import "ROPagination.h"

@interface ROTableViewController ()

@property (nonatomic, assign) BOOL didUpdateConstraints;

@property (nonatomic, strong) NSMutableArray *mainConstraints;

@end

@implementation ROTableViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    self = [super init];
    if (self) {
        
        _tableViewStyle = style;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.dataLoader.datasource) {
        
        if ([self.dataLoader.datasource conformsToProtocol:@protocol(ROPagination)]) {
        
            __weak typeof(self) weakSelf = self;
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                
                [weakSelf loadMore];
            }];
        }
        UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhite;
        if ([[[ROStyle sharedInstance] backgroundColor] ro_lightStyle]) {
            
            indicatorStyle = UIActivityIndicatorViewStyleGray;
        }
        [self.tableView.infiniteScrollingView setActivityIndicatorViewStyle:indicatorStyle];
    }
    
    for (NSObject<ROBehavior> *behavior in self.behaviors) {
        
        [behavior viewDidLoad];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    for (id<ROBehavior> behavior in self.behaviors) {
        
        if ([behavior respondsToSelector:@selector(viewDidAppear:)]) {
            
            [behavior viewDidAppear:animated];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    for (id<ROBehavior> behavior in self.behaviors) {
        
        if ([behavior respondsToSelector:@selector(viewDidDisappear:)]) {
            
            [behavior viewDidDisappear:animated];
        }
    }
}

- (void)dealloc {
    
    if (_tableView) {
        
        if (_tableView.superview) {
            
            [_tableView removeFromSuperview];
        }
        _tableView = nil;
    }
}

- (void)updateViewConstraints {
    
    if (!_didUpdateConstraints) {
        
        [self setupConstraints];
        _didUpdateConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - Properties initialization

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
        _tableView.userInteractionEnabled = YES;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tintColor = [[ROStyle sharedInstance] accentColor];
        _tableView.separatorColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.5f];
    }
    return _tableView;
}

- (NSMutableArray *)mainConstraints {

    if (!_mainConstraints) {
    
        _mainConstraints = [NSMutableArray new];
    }
    return _mainConstraints;
}

#pragma mark - Public methods

- (void)setupConstraints {
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view removeConstraints:self.mainConstraints];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_tableView);
    
    // align tableView from the left and right
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:viewsBindings]];
    
    // align tableView from the top and bottom
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:viewsBindings]];
    [self.view addConstraints:self.mainConstraints];
}

- (void)loadMore {
    
    __weak typeof(self) weakSelf = self;
    [self.dataLoader loadDataSuccessBlock:^(NSArray *items) {
        
        if ([weakSelf.items count] < [items count]) {
            
            weakSelf.tableView.showsInfiniteScrolling = YES;
            
        } else {
            
            weakSelf.tableView.showsInfiniteScrolling = NO;
            UIToolbar *toolbar = [weakSelf.view ro_toolbarBottom];
            if (toolbar) {
                
                UIEdgeInsets insets = self.tableView.contentInset;
                insets.bottom += CGRectGetHeight(toolbar.frame);
                self.tableView.contentInset = insets;
            }
        }
        if (weakSelf.tableView.infiniteScrollingView) {
            
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }
        [weakSelf loadDataSuccess:items];
        
    } failureBlock:^(ROError *error) {
        
        if (weakSelf.tableView.infiniteScrollingView) {
            
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }
        [weakSelf loadDataError:error];
        
    }];
}

#pragma mark - <RODataDelegate>

- (void)loadData {
    
    if (self.dataLoader.datasource) {

        [SVProgressHUD show];
        
        __weak typeof(self) weakSelf = self;
        [self.dataLoader refreshDataSuccessBlock:^(NSArray *items) {
            
            [SVProgressHUD dismiss];
            
            weakSelf.tableView.showsInfiniteScrolling = YES;
 
            [weakSelf loadDataSuccess:items];
            
        } failureBlock:^(ROError *error) {

            [SVProgressHUD dismiss];
            
            [weakSelf loadDataError:error];
            
        }];
    }
}

- (void)loadDataSuccess:(NSArray *)items {
    
    self.items = items;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    for (NSObject<ROBehavior> *behavior in self.behaviors) {
        
        if ([behavior respondsToSelector:@selector(onDataSuccess:)]) {
            
            [behavior onDataSuccess:items];
        }
    }
}

- (void)loadDataError:(ROError *)error {
    
    [error show];
}

@end
