//
//  ROShareBehavior.m
//  IBMMobileAppBuilder
//

#import "ROShareBehavior.h"
#import "ROCustomTableViewController.h"
#import "ROCellDescriptor.h"
#import "ROHeaderCellDescriptor.h"
#import "ROTextCellDescriptor.h"
#import "ROUtils.h"
#import "SVProgressHUD.h"
#import "UIViewController+RO.h"

@interface ROShareBehavior ()

@property (nonatomic, strong) ROCustomTableViewController *customTableViewController;

@property (nonatomic, strong) NSMutableArray *objectsToShare;

@property (nonatomic, strong) UIBarButtonItem *shareItem;

- (void)share;

@end

@implementation ROShareBehavior

- (instancetype)initWithViewController:(UIViewController *)viewController {
    
    self = [super init];
    if (self) {
        
        _viewController = viewController;
    }
    return self;
}

+ (instancetype)behaviorViewController:(UIViewController *)viewController {
    
    return [[self alloc] initWithViewController:viewController];
}

- (ROCustomTableViewController *)customTableViewController {
    
    if (!_customTableViewController) {
        
        if ([self.viewController isKindOfClass:[ROCustomTableViewController class]]) {
            
            _customTableViewController = (ROCustomTableViewController *)self.viewController;
        }
    }
    return _customTableViewController;
}

- (NSMutableArray *)objectsToShare {
    
    if (!_objectsToShare) {
        
        _objectsToShare = [NSMutableArray new];
        for (NSObject<ROCellDescriptor> *cellDescriptor in self.customTableViewController.items) {
            
            if (![cellDescriptor isEmpty]){
                
                if ([cellDescriptor isKindOfClass:[ROHeaderCellDescriptor class]]) {
                    
                    ROHeaderCellDescriptor *headerCellDescriptor = (ROHeaderCellDescriptor *)cellDescriptor;
                    if (headerCellDescriptor.text) {
                        
                        [_objectsToShare addObject:headerCellDescriptor.text];
                    }
                    
                } else if ([cellDescriptor isKindOfClass:[ROTextCellDescriptor class]]) {
                    
                    ROTextCellDescriptor *textCellDescriptor = (ROTextCellDescriptor *)cellDescriptor;
                    if (textCellDescriptor.text) {
                        
                        [_objectsToShare addObject:textCellDescriptor.text];
                    }
                }
            }
        }
    }
    return _objectsToShare;
}

- (void)viewDidLoad {

    self.shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                   target:self
                                                                   action:@selector(share)];

    [self.viewController ro_addBottomBarButton:self.shareItem
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

- (void)share {
    
    if ([self.objectsToShare count] != 0) {
    
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:self.objectsToShare
                                                                                         applicationActivities:nil];
        
        if ( [activityController respondsToSelector:@selector(popoverPresentationController)] ) {
            // iOS8
            activityController.popoverPresentationController.barButtonItem = self.shareItem;
            activityController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        
        // Present the controller
        [self.viewController presentViewController:activityController animated:YES completion:nil];
        
        [[[ROUtils sharedInstance] analytics] logAction:@"share"
                                                 target:[self.objectsToShare componentsJoinedByString:@"\n"]];
    } else {
    
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"No items to share", nil)];
    }
}

@end
