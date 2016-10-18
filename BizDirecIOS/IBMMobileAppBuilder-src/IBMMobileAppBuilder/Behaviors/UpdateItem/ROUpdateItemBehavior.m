//
//  ROUpdateItemBehavior.m
//  IBMMobileAppBuilder
//

#import "ROUpdateItemBehavior.h"
#import "ROCustomTableViewController.h"
#import "ROCRUDTableViewController.h"
#import "RODataLoader.h"
#import "RODataDelegate.h"
#import "UIViewController+RO.h"
#import "ROSynchronize.h"

@interface ROUpdateItemBehavior () <ROUpdateItemDelegate>

@property (nonatomic, strong) ROCRUDTableViewController *crudViewController;

@property (nonatomic, strong) NSObject<RODatasource> *datasource;

- (void)editButtonAction:(id)sender;

@end

@implementation ROUpdateItemBehavior

- (instancetype)initWithViewController:(UIViewController<RODataDelegate> *)viewController crudControllerClass:(__unsafe_unretained Class)crudControllerClass {
    
    self = [super init];
    if (self) {
        
        _viewController = viewController;
        _crudControllerClass = crudControllerClass;
    }
    return self;
}

+ (instancetype)behaviorViewController:(UIViewController<RODataDelegate> *)viewController crudControllerClass:(__unsafe_unretained Class)crudControllerClass {
    
    return [[self alloc] initWithViewController:viewController
                            crudControllerClass:crudControllerClass];
}

- (void)viewDidLoad {
    
    if ([self.datasource conformsToProtocol:@protocol(ROCRUDServiceDelegate)]) {
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                    target:self
                                                                                    action:@selector(editButtonAction:)];
        [self.viewController ro_addRightBarButtonItem:editButton];
    }
}

#pragma mark - Update delegate

- (void)updated {
    
    if ([self.datasource conformsToProtocol:@protocol(ROSynchronize)]) {
        
        [(NSObject<ROSynchronize> *)self.datasource setSynchronized:NO];
    }
    
    for (id<ROFormFieldDelegate> field in self.crudViewController.fields) {
        
        [field setValue:nil];
    }
    
    UINavigationController *navigationController = self.viewController.navigationController;
    [navigationController popViewControllerAnimated:YES];
    
    UIViewController <RODataDelegate> *topViewController = (UIViewController<RODataDelegate> *)[navigationController topViewController];
    if (topViewController) {
        
        [topViewController loadData];
    }
    
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
        _crudViewController.updateDelegate = self;
    }
    return _crudViewController;
}

- (void)editButtonAction:(id)sender {
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.crudViewController];
    
    ROCustomTableViewController *customViewController = (ROCustomTableViewController *)self.viewController;
    
    self.crudViewController.dataItem = customViewController.dataItem;
    
    [self.viewController presentViewController:navController animated:YES completion:^{
        
    }];
}

@end
