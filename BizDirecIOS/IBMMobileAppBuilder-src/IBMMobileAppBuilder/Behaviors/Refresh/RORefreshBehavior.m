//
//  RORefreshBehavior.m
//  IBMMobileAppBuilder
//

#import "RORefreshBehavior.h"
#import "ROStyle.h"
#import "SVProgressHUD.h"
#import "SVPullToRefresh.h"
#import "ROPagination.h"
#import "RODataLoader.h"
#import "ROUtils.h"
#import "RODataDelegate.h"
#import "ROSynchronize.h"

@interface RORefreshBehavior ()

@property (nonatomic, strong) NSObject *datasource;

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)refreshData;
- (void)refreshDataScroll;

@end

@implementation RORefreshBehavior

- (instancetype)initWithViewController:(UIViewController<RODataDelegate> *)viewController {
    
    self = [super init];
    if (self) {
        
        _viewController = viewController;
    }
    return self;
}

+ (instancetype)behaviorViewController:(UIViewController<RODataDelegate> *)viewController {
    
    return [[self alloc] initWithViewController:viewController];
}

#pragma mark - Properties init

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        for (id subview in self.viewController.view.subviews) {
            
            if ([subview isKindOfClass:[UIScrollView class]]) {
                
                _scrollView = (UIScrollView *)subview;
                break;
            }
        }
    }
    return _scrollView;
}

- (UIRefreshControl *)refreshControl {
    
    if (!_refreshControl) {
        
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.tintColor = [[ROStyle sharedInstance] foregroundColor];
    }
    return _refreshControl;
}

- (NSObject *)datasource {

    if (!_datasource) {
    
        _datasource = [[self.viewController dataLoader] datasource];
    }
    return _datasource;
}

#pragma mark - <ROBehavior>

- (void)viewDidLoad {
    
    if (self.datasource) {
        
        if (self.scrollView) {
            
            [self.refreshControl addTarget:self action:@selector(refreshDataScroll) forControlEvents:UIControlEventValueChanged];
            [self.scrollView addSubview:self.refreshControl];
            
        } else {
            
            self.viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
        }
    }
}

- (void)refreshData {
    
    if ([self.datasource conformsToProtocol:@protocol(ROSynchronize)]) {
    
        [(NSObject<ROSynchronize>*)self.datasource setSynchronized:NO];
    }
    
    NSString *datasourceName = NSStringFromClass([self.datasource class]);
    [[[ROUtils sharedInstance] analytics] logAction:@"refresh"
                                             target:nil
                                     datasourceName:datasourceName];
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [self.viewController.dataLoader refreshDataSuccessBlock:^(id dataObject) {
        
        [SVProgressHUD dismiss];
        [weakSelf.viewController loadDataSuccess:dataObject];
        
    } failureBlock:^(ROError *error) {
        
        [SVProgressHUD dismiss];
        [weakSelf.viewController loadDataError:error];
        
    }];
}

- (void)refreshDataScroll {
    
    if ([self.datasource conformsToProtocol:@protocol(ROSynchronize)]) {
        
        [(NSObject<ROSynchronize>*)self.datasource setSynchronized:NO];
    }
    
    NSString *datasourceName = NSStringFromClass([self.datasource class]);
    [[[ROUtils sharedInstance] analytics] logAction:@"refresh"
                                             target:nil
                                     datasourceName:datasourceName];
    
    if ([self.viewController.dataLoader.datasource conformsToProtocol:@protocol(ROPagination)]) {
        
        self.scrollView.showsInfiniteScrolling = YES;
    }
    __weak typeof (self) weakSelf = self;
    [self.viewController.dataLoader refreshDataSuccessBlock:^(id dataObject) {
        
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.viewController loadDataSuccess:dataObject];
        
    } failureBlock:^(ROError *error) {
        
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.viewController loadDataError:error];
        
    }];
}

@end
