
//  ROEditRowsBehavior.m
//  IBMMobileAppBuilder
//

#import "ROEditRowsBehavior.h"
#import "ROStyle.h"
#import "RORestClient.h"
#import "ROCRUDServiceDelegate.h"
#import "SVProgressHUD.h"
#import "ROError.h"
#import "ROTableViewController.h"
#import "RODataLoader.h"
#import "ROUtils.h"
#import "ROModel.h"
#import "ROTableViewController.h"
#import "UIViewController+RO.h"
#import "ROSynchronize.h"

@interface ROEditRowsBehavior () <UIActionSheetDelegate>

@property (nonatomic, strong) UIBarButtonItem *cancelItem;
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, strong) UIBarButtonItem *prevLeftBB;
@property (nonatomic, strong) NSMutableDictionary *selectedItems;
@property (nonatomic, strong) RORestClient *restClient;
@property (nonatomic, strong) NSMutableArray *arrayIds;
@property (nonatomic, weak) id<ROCRUDServiceDelegate> crudService;
@property (nonatomic, strong) NSObject<RODatasource> *datasource;

@end

@implementation ROEditRowsBehavior

- (instancetype)initWithViewController:(ROTableViewController<RODataDelegate, UITableViewDataSource, UITableViewDelegate> *)viewController {
    
    self = [super init];
    
    if (self) {
        
        _viewController = viewController;
    }
    
    return self;
}

+ (instancetype)behaviorViewController:(ROTableViewController<RODataDelegate, UITableViewDataSource, UITableViewDelegate> *)viewController {
    
    return [[self alloc] initWithViewController:viewController];
}

- (NSObject<RODatasource> *)datasource {
    
    if (!_datasource) {
        
        _datasource = [[self.viewController dataLoader] datasource];
    }
    return _datasource;
}

- (id<ROCRUDServiceDelegate>)crudService {
    
    if (!_crudService && [[[self.viewController dataLoader] datasource] conformsToProtocol:@protocol(ROCRUDServiceDelegate)]) {
        
        _crudService = (id<ROCRUDServiceDelegate>)[[self.viewController dataLoader] datasource];
    }
    return _crudService;
}

- (void)viewDidLoad {

    if (self.crudService) {
    
        _editItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil)
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(tapEdit)];
        
        [self.viewController ro_addRightBarButtonItem:_editItem];
        
        _cancelItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(cancelEdit)];

    }
}

#pragma mark - Private methods

- (void)tapEdit {
    
    if (_viewController.tableView.editing) {
        
        if ([_selectedItems count]) {
            
            _arrayIds = [[NSMutableArray alloc] init];
            
            NSArray *allKeys = [_selectedItems allKeys];
            
            for (NSString *key in allKeys) {
                
                id<ROModelDelegate> item = [_selectedItems valueForKey:key];
                if ([item identifier]) {
                    
                    [_arrayIds addObject:[item identifier]];
                }
            }
            
            NSString *deleteMsg = nil;
            if ([_selectedItems count] > 1) {
                
                deleteMsg = NSLocalizedString(@"Delete items", nil);
                
            } else {
                
                deleteMsg = NSLocalizedString(@"Delete item", nil);
            }
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                       destructiveButtonTitle:deleteMsg
                                                            otherButtonTitles: nil];
        
            [actionSheet showInView:_viewController.view];
        }
    
    } else {
        
        _selectedItems = [[NSMutableDictionary alloc] init];
        
        [self.viewController ro_hideBottomToolbarAnimated:YES];

        [_viewController.tableView setDataSource:self];
        [_viewController.tableView setDelegate:self];
        
        if (_viewController.navigationItem.leftBarButtonItem) {
            
            _prevLeftBB = [[UIBarButtonItem alloc] init];
            _prevLeftBB = _viewController.navigationItem.leftBarButtonItem;
        }
        
        [_viewController.tableView setAllowsMultipleSelectionDuringEditing:YES];
        [_viewController.tableView setEditing:YES animated:YES];
        [_editItem setTitle:NSLocalizedString(@"Remove", nil)];
        [_editItem setEnabled:NO];
        [_viewController.navigationItem setLeftBarButtonItem:_cancelItem];
    }
}

- (void)cancelEdit {

    [self.viewController ro_showBottomToolbarAnimated:YES];

    _selectedItems = [[NSMutableDictionary alloc] init];
    
    [_viewController.tableView setDataSource:_viewController];
    [_viewController.tableView setDelegate:_viewController];
    
    [_viewController.tableView setAllowsMultipleSelectionDuringEditing:NO];
    [_viewController.tableView setEditing:NO animated:YES];
    [_editItem setTitle:NSLocalizedString(@"Edit", nil)];
    [_editItem setEnabled:YES];
    
    if (_prevLeftBB) {
        
        [_viewController.navigationItem setLeftBarButtonItem:_prevLeftBB];
    }
    else {
        
        [_viewController.navigationItem setLeftBarButtonItem:nil];
    }
}

- (void)deleteItems:(NSArray *)arrayIds {
    
    if ([self.datasource conformsToProtocol:@protocol(ROSynchronize)]) {
        
        [(NSObject<ROSynchronize> *)self.datasource setSynchronized:NO];
    }
    
    [SVProgressHUD show];
    
    [_crudService deleteItemsWithIdentifiers:arrayIds successBlock:^(id response) {
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Items removed", nil)];

        [_viewController loadData];
        [_viewController.tableView setContentOffset:CGPointZero animated:YES];
        
        [self cancelEdit];
        
    } failureBlock:^(ROError *error) {
        
        [SVProgressHUD dismiss];
        
        [error show];
        
        [self cancelEdit];
    }];
}

#pragma mark - UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        [self deleteItems:_arrayIds];
    }
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [_viewController tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([_selectedItems valueForKey:[indexPath description]]) {

        [[_viewController tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_viewController.items count];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![_selectedItems count]) {
        
        [_editItem setEnabled:YES];
    }
    
    [_selectedItems setObject:[_viewController.items objectAtIndex:indexPath.row] forKey:[indexPath description]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_selectedItems removeObjectForKey:[indexPath description]];
    
    if (![_selectedItems count]) {
        
        [_editItem setEnabled:NO];
    }
}

@end
