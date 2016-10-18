//
//  ROFilterBehavior.m
//  IBMMobileAppBuilder
//

#import "ROFilterBehavior.h"
#import "ROFilterViewController.h"
#import "NSBundle+RO.h"
#import "UIImage+RO.h"
#import "ROTableViewController.h"
#import "ROCollectionViewController.h"
#import "ROOptionsFilter.h"
#import "RODataLoader.h"
#import "UIViewController+RO.h"

@interface ROFilterBehavior () <ROFilterDelegate>

@property (nonatomic, strong) ROFilterViewController *filterController;

- (void)openFilter;

@end

@implementation ROFilterBehavior

- (instancetype)initWithViewController:(UIViewController<RODataDelegate> *)viewController filterControllerClass:(Class)filterControllerClass {
    
    self = [super init];
    if (self) {
        
        _viewController = viewController;
        _filterControllerClass = filterControllerClass;
    }
    return self;
}

+ (instancetype)behaviorViewController:(UIViewController<RODataDelegate> *)viewController filterControllerClass:(Class)filterControllerClass {
    
    return [[self alloc] initWithViewController:viewController filterControllerClass:filterControllerClass];
}

- (void)viewDidLoad {
    
    UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage ro_imageNamed:@"filter"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(openFilter)];
    
    [self.viewController ro_addBottomBarButton:filterBarButtonItem
                                      animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.viewController.navigationController setToolbarHidden:NO
                                                      animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self.viewController.navigationController setToolbarHidden:YES
                                                      animated:animated];
}

- (ROFilterViewController *)filterController {
    
    if (!_filterController) {
        
        if (_filterControllerClass) {
            
            _filterController = [_filterControllerClass new];
            
        } else {
            
            _filterController = [ROFilterViewController form];
        }
        _filterController.dataLoader = self.viewController.dataLoader;
        _filterController.formDelegate = self;
    }
    return _filterController;
}

- (void)openFilter {
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.filterController];
    [self.viewController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Filter / Form delegate

- (void)formSubmitted {
    
    ROOptionsFilter *optionsFilter = [[self.viewController dataLoader] optionsFilter];
    optionsFilter.searchText = nil;
    optionsFilter.filters = self.filterController.filters;
    [[self.viewController dataLoader] setOptionsFilter:optionsFilter];
    [self.viewController loadData];
}

@end
