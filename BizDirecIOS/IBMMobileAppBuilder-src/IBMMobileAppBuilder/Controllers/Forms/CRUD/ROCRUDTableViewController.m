//
//  ROCRUDTableViewController.m
//  IBMMobileAppBuilder
//

#import "ROCRUDTableViewController.h"
#import "ROStyle.h"
#import "ROFormFieldButton.h"
#import "ROError.h"
#import "SVProgressHUD.h"

@interface ROCRUDTableViewController ()

@end

@implementation ROCRUDTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([self.dataLoader.datasource conformsToProtocol:@protocol(ROCRUDServiceDelegate)]) {
        self.crudService = (id<ROCRUDServiceDelegate>)self.dataLoader.datasource;
    }
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                      target:self
                                                                                      action:@selector(cancelButtonAction:)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    UIBarButtonItem *submitButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                      target:self
                                                                                      action:@selector(saveButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = submitButtonItem;
    
    if ([self showDeleteButton]) {
        
        ROFormFieldButton *deleteButton = [ROFormFieldButton fieldWithLabel:NSLocalizedString(@"Delete", nil) tapBlock:^(id sender) {
            
            [self deleteButtonAction:sender];
            
        }];
        
        self.buttons = [NSMutableArray arrayWithObject:deleteButton];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.formDataDelegate && self.dataItem) {
        [self.formDataDelegate loadFormData:self.dataItem];
        [self.tableView reloadData];
    }
}

- (BOOL)showDeleteButton {
    
    return ([self isEditMode] && self.deleteDelegate);
}

- (BOOL)isEditMode {
    
    return self.dataItem != nil;
}

#pragma mark - UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        [self deleteItem];
    }
}

#pragma mark - Form actions

- (void)cancelButtonAction:(id)sender {
    
    for (id<ROFormFieldDelegate> field in self.fields) {
        [field reset];
    }
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)deleteButtonAction:(id)sender {
    
    [self confirmDelete];
}

- (void)saveButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([self validate]) {
        [self saveItem];
    }
}

- (void)confirmDelete {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"Delete item", nil)
                                                    otherButtonTitles: nil];
    
    [actionSheet showInView:self.view];
}

- (void)deleteItem {
    
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD show];
    
    [self.crudService deleteItemWithIdentifier:self.identifier successBlock:^(id response) {
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Item deleted", nil)];
        
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            
            if (weakSelf.deleteDelegate) {
                [weakSelf.deleteDelegate deleted];
            }
        });
        
    } failureBlock:^(ROError *error) {
        
        [SVProgressHUD dismiss];
        
        [error show];
        
    }];
}

- (void)saveItem {
    
    if ([self isEditMode]) {
        
        [self updateItem];
        
    } else {
        
        [self createItem];
        
    }
}

- (void)updateItem {
    
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD show];
    
    [self.crudService updateItemWithIdentifier:self.identifier params:[self jsonValues] successBlock:^(id response) {
        
        [SVProgressHUD showSuccessWithStatus:nil];
        
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            
            if (weakSelf.updateDelegate) {
                [weakSelf.updateDelegate updated];
            }
        });
        
    } failureBlock:^(ROError *error) {

        [SVProgressHUD dismiss];
        
        [error show];
    }];
}

- (void)createItem {
    
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD show];
    
    [self.crudService createItemWithParams:[self jsonValues] successBlock:^(id response) {
        
        [SVProgressHUD showSuccessWithStatus:nil];
        
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            
            if (weakSelf.createDelegate) {
                [weakSelf.createDelegate created];
            }
        });
        
    } failureBlock:^(ROError *error) {
        
        [SVProgressHUD dismiss];
        
        [error show];
    }];
}

@end
