//
//  ROCollectionViewController.m
//  IBMMobileAppBuilder
//

#import "ROCollectionViewController.h"
#import "ROPhotoCollectionViewCell.h"
#import "ROPhotoTitleCollectionViewCell.h"
#import "RODataLoader.h"
#import "SVProgressHUD.h"
#import "SVPullToRefresh.h"
#import "ROStyle.h"
#import "UIColor+RO.h"
#import "UIView+RO.h"
#import "ROError.h"
#import "ROBehavior.h"
#import "ROPagination.h"

@interface ROCollectionViewController ()

@property (nonatomic, assign) BOOL didUpdateConstraints;

@end

@implementation ROCollectionViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.numberOfColumns = 3;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    if (self.dataLoader.datasource) {
        
        if ([self.dataLoader.datasource conformsToProtocol:@protocol(ROPagination)]) {
        
            __weak typeof(self) weakSelf = self;
            [self.collectionView addInfiniteScrollingWithActionHandler:^{
                
                [weakSelf loadMore];
                
            }];
        }
        UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhite;
        if ([[[ROStyle sharedInstance] backgroundColor] ro_lightStyle]) {
            
            indicatorStyle = UIActivityIndicatorViewStyleGray;
        }
        [self.collectionView.infiniteScrollingView setActivityIndicatorViewStyle:indicatorStyle];
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

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    if (_collectionView) {
        
        if (_collectionView.superview) {
            
            [_collectionView removeFromSuperview];
        }
        _collectionView = nil;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (void)updateViewConstraints {
    
    if (!_didUpdateConstraints) {
        
        [self setupConstraints];
        _didUpdateConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - Properties initialization

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.backgroundView = nil;
        _collectionView.tintColor = [[ROStyle sharedInstance] accentColor];
        _collectionView.userInteractionEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

#pragma mark - Public methods

- (void)setupConstraints {
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_collectionView);
    
    // align tableView from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    // align tableView from the top and bottom
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
}


#pragma mark - Load data

- (void)loadData {
    
    if (self.dataLoader.datasource) {
        
        [SVProgressHUD show];

        __weak typeof(self) weakSelf = self;
        [self.dataLoader refreshDataSuccessBlock:^(NSArray *items) {
            
            [SVProgressHUD dismiss];
            
            weakSelf.collectionView.showsInfiniteScrolling = YES;
            
            [weakSelf loadDataSuccess:items];
            
        } failureBlock:^(ROError *error) {
            
            [SVProgressHUD dismiss];
               
            [weakSelf loadDataError:error];
            
        }];
    }
}

- (void)loadMore {
    
    __weak typeof(self) weakSelf = self;
    [self.dataLoader loadDataSuccessBlock:^(NSArray *items) {
        
        if ([weakSelf.items count] < [items count]) {
            
            weakSelf.collectionView.showsInfiniteScrolling = YES;
            
        } else {
            
            weakSelf.collectionView.showsInfiniteScrolling = NO;
            
            UIToolbar *toolbar = [weakSelf.view ro_toolbarBottom];
            if (toolbar) {
                
                UIEdgeInsets insets = self.collectionView.contentInset;
                insets.bottom += CGRectGetHeight(toolbar.frame);
                self.collectionView.contentInset = insets;
            }
        }
        if (weakSelf.collectionView.infiniteScrollingView) {
            
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        }
        [weakSelf loadDataSuccess:items];
        
    } failureBlock:^(ROError *error) {
        
        if (weakSelf.collectionView.infiniteScrollingView) {
            
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        }
        [weakSelf loadDataError:error];
        
    }];
}

- (void)loadDataSuccess:(NSArray *)items {
    
    self.items = items;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
        
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
