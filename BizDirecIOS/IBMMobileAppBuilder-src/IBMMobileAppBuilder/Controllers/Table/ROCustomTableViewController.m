//
//  RODetailViewController.m
//  IBMMobileAppBuilder
//

#import "ROCustomTableViewController.h"
#import "ROStyle.h"
#import "ROCellDescriptor.h"
#import "SVProgressHUD.h"
#import "ROError.h"
#import "ROBehavior.h"

@interface ROCustomTableViewController ()

@end

@implementation ROCustomTableViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_tableView);
    
    // align tableView from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    // align tableView from the top and bottom
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    for (NSObject<ROCellDescriptor> *cellDescriptor in self.items) {
        
        [cellDescriptor receiveMemoryWarning];
    }
}

- (void)dealloc {
    
    if (_tableView) {
        
        if (_tableView.superview) {
            
            [_tableView removeFromSuperview];
        }
        _tableView = nil;
    }
    if (_customTableViewDelegate) {
        
        _customTableViewDelegate = nil;
    }
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.userInteractionEnabled = YES;
        _tableView.tintColor = [[ROStyle sharedInstance] accentColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
    }
    return _tableView;
}

- (void)loadData {
    
    if (self.dataItem) {
        
        [self loadDataSuccess:self.dataItem];
        
    } else if (self.dataLoader.datasource) {
        
        [SVProgressHUD show];
        
        __weak typeof(self) weakSelf = self;
        [self.dataLoader refreshDataSuccessBlock:^(NSObject *dataItem) {

            [SVProgressHUD dismiss];
            
            [weakSelf loadDataSuccess:dataItem];
            
        } failureBlock:^(ROError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                
            });
            [weakSelf loadDataError:error];
            
        }];
    }
}

- (void)loadDataSuccess:(NSObject *)dataItem {
    
    self.dataItem = dataItem;
    
    [self.customTableViewDelegate configureWithDataItem:self.dataItem];
    
    NSMutableArray *items = [NSMutableArray new];
    for (NSObject<ROCellDescriptor> *cellDescriptor in self.items) {
        
        if (![cellDescriptor isEmpty]) {
            
            [items addObject:cellDescriptor];
        }
    }
    self.items = [NSArray arrayWithArray:items];
    
    dispatch_async(dispatch_get_main_queue(),^{
        
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

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject<ROCellDescriptor> *cellDescriptor = self.items[indexPath.row];
    return [cellDescriptor tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.items count];
}

#pragma mark - <UITableViewDataDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSObject<ROCellDescriptor> *cellDescriptor = self.items[indexPath.row];
    if ([cellDescriptor respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        
        return [cellDescriptor tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject<ROCellDescriptor> *cellDescriptor = self.items[indexPath.row];
    if ([cellDescriptor respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [cellDescriptor tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
