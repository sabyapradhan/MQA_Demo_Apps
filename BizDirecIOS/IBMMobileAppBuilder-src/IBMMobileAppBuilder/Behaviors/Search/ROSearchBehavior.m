//
//  ROSearchBehavior.m
//  IBMMobileAppBuilder
//

#import "ROSearchBehavior.h"
#import "ROStyle.h"
#import "NSString+RO.h"
#import "ROOptionsFilter.h"
#import "RODataLoader.h"
#import "ROUtils.h"
#import "RODataDelegate.h"

@interface ROSearchBehavior ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ROSearchBehavior

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

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.tintColor = [[ROStyle sharedInstance] applicationBarTextColor];
        _searchBar.barTintColor = [[ROStyle sharedInstance] applicationBarBackgroundColor];
        
        // Hide clear button
        NSArray *subviews = _searchBar.subviews.count == 1 ? [_searchBar.subviews.firstObject subviews] : _searchBar.subviews;
        for (id view in subviews) {
            
            if ([view isKindOfClass:[UITextField class]]) {
                
                UITextField *textField = (UITextField *)view;
                textField.clearButtonMode = UITextFieldViewModeNever;
                break;
            }
        }
    }
    return _searchBar;
}

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

- (void)viewDidLoad {
    
    if (self.scrollView) {
        
        self.searchBar.delegate = self;
        
        [self.viewController.view addSubview:self.searchBar];
        
        NSDictionary *viewsBindings = @{
                                        @"searchBar" : self.searchBar,
                                        };
        
        // align tableView from the left and right
        [self.viewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|"
                                                                                         options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                         metrics:nil
                                                                                           views:viewsBindings]];
        
        // align tableView from the top
        [self.viewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[searchBar(==44)]"
                                                                                         options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                         metrics:nil
                                                                                           views:viewsBindings]];
        
        UIEdgeInsets dataViewInsets = self.scrollView.contentInset;
        dataViewInsets.top += 44.0f;
        [self.scrollView setContentInset:dataViewInsets];
    }
}

#pragma mark - Search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    if (!searchBar.showsCancelButton) {
        
        [searchBar setShowsCancelButton:YES animated:YES];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    if (searchBar.showsCancelButton) {
        
        [searchBar setShowsCancelButton:NO animated:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (searchBar.text && [[searchBar.text ro_trim] length] != 0) {
    
        [self search:searchBar.text];
        
    } else {
        
        [self search:nil];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = nil;
    [self search:nil];
}

- (void)search:(NSString *)searchText {
    
    [self.viewController.view endEditing:YES];
    ROOptionsFilter *optionsFilter = [[self.viewController dataLoader] optionsFilter];
    optionsFilter.searchText = searchText;
    [[self.viewController dataLoader] setOptionsFilter:optionsFilter];
    [self.viewController loadData];
    
    if (searchText) {
        
        NSString *datasourceName = NSStringFromClass([[[self.viewController dataLoader] datasource] class]);
        [[[ROUtils sharedInstance] analytics] logAction:@"search"
                                                 target:searchText
                                         datasourceName:datasourceName];
    }
}

@end
