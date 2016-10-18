//
//  RODeleteItemBehavior.m
//  IBMMobileAppBuilder
//

#import "RODeleteItemBehavior.h"
#import "ROError.h"
#import "ROCRUDServiceDelegate.h"
#import "SVProgressHUD.h"
#import "RODataLoader.h"
#import "RODataDelegate.h"
#import "ROUtils.h"
#import "ROModel.h"
#import "RODataItemDelegate.h"
#import "UIViewController+RO.h"
#import "ROSynchronize.h"

@interface RODeleteItemBehavior ()

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) NSObject<RODatasource> *datasource;

@property (nonatomic, weak) id<ROCRUDServiceDelegate> crudService;

- (void)removeButtonAction:(id)sender;

- (void)deleteItem;

- (void)backToList;

@end

@implementation RODeleteItemBehavior

- (instancetype)initWithViewController:(UIViewController<RODataDelegate, RODataItemDelegate> *)viewController {
    
    self = [super init];
    if (self) {
        
        _viewController = viewController;
    }
    return self;
}

+ (instancetype)behaviorViewController:(UIViewController<RODataDelegate, RODataItemDelegate> *)viewController {
    
    return [[self alloc] initWithViewController:viewController];
}

- (void)viewDidLoad {
    
    if (self.crudService) {
        
        UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                      target:self
                                                                                      action:@selector(removeButtonAction:)];
        
        [self.viewController ro_addBottomBarButton:removeButton
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

#pragma mark - <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        [self deleteItem];
    }
}

#pragma mark - Private methods

- (NSObject<RODatasource> *)datasource {
    
    if (!_datasource) {
        
        _datasource = [[self.viewController dataLoader] datasource];
    }
    return _datasource;
}

- (id<ROCRUDServiceDelegate>)crudService {
    
    if (!_crudService && [self.datasource conformsToProtocol:@protocol(ROCRUDServiceDelegate)]) {
        
        _crudService = (id<ROCRUDServiceDelegate>)self.datasource;
    }
    return _crudService;
}

- (NSString *)identifier {
    
    if (!_identifier && [[self.viewController dataItem] conformsToProtocol:@protocol(ROModelDelegate)]) {
        
        id <ROModelDelegate> item = (id<ROModelDelegate>)[self.viewController dataItem];
        _identifier = [item identifier];
    }
    return _identifier;
}

- (void)removeButtonAction:(id)sender {
    
    if (self.identifier) {
    
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                   destructiveButtonTitle:NSLocalizedString(@"Delete item", nil)
                                                        otherButtonTitles: nil];
        
        [actionSheet showInView:self.viewController.view];
    
    } else {
    
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"No item to remove", nil)];
    }
}

- (void)deleteItem {
    
    [SVProgressHUD show];
    
    __weak typeof(self) weakSelf = self;
    
    [self.crudService deleteItemWithIdentifier:self.identifier successBlock:^(id response) {
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Item removed", nil)];
        
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
           
            [weakSelf backToList];
        });
        
    } failureBlock:^(ROError *error) {
        
        [SVProgressHUD dismiss];
        
        [error show];
        
    }];
}

- (void)backToList {
    
    if ([self.datasource conformsToProtocol:@protocol(ROSynchronize)]) {
        
        [(NSObject<ROSynchronize> *)self.datasource setSynchronized:NO];
    }
    
    UINavigationController *navigationController = self.viewController.navigationController;
    [navigationController popViewControllerAnimated:YES];
    
    UIViewController <RODataDelegate> *topViewController = (UIViewController<RODataDelegate> *)[navigationController topViewController];
    if (topViewController) {
        
        [topViewController loadData];
    }
}

@end
