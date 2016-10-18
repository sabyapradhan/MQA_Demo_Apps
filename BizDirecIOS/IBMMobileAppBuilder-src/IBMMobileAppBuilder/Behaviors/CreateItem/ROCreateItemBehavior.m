//
//  ROCreateBehavior.m
//  IBMMobileAppBuilder
//

#import "ROCreateItemBehavior.h"
#import "ROCRUDTableViewController.h"
#import "RODataLoader.h"
#import "RODataDelegate.h"
#import "UIViewController+RO.h"
#import "ROSynchronize.h"

@interface ROCreateItemBehavior () <ROCreateItemDelegate>

@property (nonatomic, strong) NSObject<RODatasource> *datasource;

@property (nonatomic, strong) ROCRUDTableViewController *crudViewController;

- (void)addButtonAction:(id)sender;

@end

@implementation ROCreateItemBehavior

- (instancetype)initWithViewController:(UIViewController<RODataDelegate> *)viewController crudControllerClass:(__unsafe_unretained Class)crudControllerClass {
    
    self = [super init];
    if (self) {
        
        _viewController = viewController;
        _crudControllerClass = crudControllerClass;
    }
    return self;
}

+ (instancetype)behaviorViewController:(UIViewController<RODataDelegate> *)viewController crudControllerClass:(__unsafe_unretained Class)crudControllerClass {
    
    return [[self alloc] initWithViewController:viewController crudControllerClass:crudControllerClass];
}

#pragma mark - <ROBehavior>

- (void)viewDidLoad {
    
    if ([self.datasource conformsToProtocol:@protocol(ROCRUDServiceDelegate)]) {
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addButtonAction:)];
        
        [self.viewController ro_addBottomBarButton:addButton
                                          animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.viewController.navigationController setToolbarHidden:NO
                                                      animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self.viewController.navigationController setToolbarHidden:YES
                                                      animated:animated];
}

#pragma mark - <ROCreateItemDelegate>

- (void)created {
    
    for (id<ROFormFieldDelegate> field in self.crudViewController.fields) {
        
        [field reset];
    }
    
    if ([self.datasource conformsToProtocol:@protocol(ROSynchronize)]) {
    
        [(NSObject<ROSynchronize> *)self.datasource setSynchronized:NO];
    }
    
    [self.viewController loadData];
    [self.crudViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Private methods

- (NSObject<RODatasource> *)datasource {

    if (!_datasource) {
    
        _datasource = [[self.viewController dataLoader] datasource];
    }
    return _datasource;
}

- (ROCRUDTableViewController *)crudViewController {
    
    if (!_crudViewController) {
        
        if (_crudControllerClass) {
            
            _crudViewController = [_crudControllerClass new];
            
        } else {
            
            _crudViewController = [ROCRUDTableViewController new];
        }
        _crudViewController.dataLoader = self.viewController.dataLoader;
        _crudViewController.createDelegate = self;
    }
    return _crudViewController;
}

- (void)addButtonAction:(id)sender {
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.crudViewController];
    
    [self.viewController presentViewController:navController animated:YES completion:^{
        
    }];
}

@end
