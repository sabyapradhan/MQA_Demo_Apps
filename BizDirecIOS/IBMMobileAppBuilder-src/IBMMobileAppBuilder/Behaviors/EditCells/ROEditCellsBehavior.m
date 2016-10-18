//
//  ROEditCellsBehavior.m
//  IBMMobileAppBuilder
//

#import "ROEditCellsBehavior.h"
#import "ROStyle.h"
#import "UIImage+RO.h"
#import "ROCRUDServiceDelegate.h"
#import "SVProgressHUD.h"
#import "ROError.h"
#import "RODataLoader.h"
#import "ROUtils.h"
#import "ROModel.h"
#import "RODataDelegate.h"
#import "ROCollectionViewController.h"
#import "UIViewController+RO.h"
#import "ROSynchronize.h"

@interface ROEditCellsBehavior () <UIActionSheetDelegate>

@property (nonatomic, strong) UIBarButtonItem *cancelItem;
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, strong) UIBarButtonItem *prevLeftBB;
@property (nonatomic, strong) NSMutableDictionary *selectedItems;
@property (nonatomic, strong) NSMutableArray *selectedIndexes;
@property (nonatomic, strong) UIImageView *checkmark;
@property (nonatomic, strong) NSMutableArray *arrayIds;
@property (nonatomic, weak) id<ROCRUDServiceDelegate> crudService;
@property (nonatomic, strong) NSObject<RODatasource> *datasource;

@end

@implementation ROEditCellsBehavior

- (instancetype)initWithViewController:(ROCollectionViewController<RODataDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> *)viewController {
    
    self = [super init];
    
    if (self) {
        
        _viewController = viewController;
    }
    
    return self;
}

+ (instancetype)behaviorViewController:(ROCollectionViewController<RODataDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> *)viewController {
    
    return [[self alloc] initWithViewController:viewController];
}

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
    
    if (_viewController.collectionView.allowsMultipleSelection) {
        
        _arrayIds = [[NSMutableArray alloc] init];
        
        if ([_selectedItems count]) {
            
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
                                                            otherButtonTitles:nil];
            
            [actionSheet showInView:_viewController.view];
        }
    
    } else {
        
        _selectedItems = [[NSMutableDictionary alloc] init];
        _selectedIndexes = [[NSMutableArray alloc] init];
        
        [self.viewController ro_hideBottomToolbarAnimated:YES];

        [_viewController.collectionView setDataSource:self];
        [_viewController.collectionView setDelegate:self];
        
        [_viewController.collectionView setAllowsMultipleSelection:YES];
        
        if (_viewController.navigationItem.leftBarButtonItem) {
            
            _prevLeftBB = [[UIBarButtonItem alloc] init];
            _prevLeftBB = _viewController.navigationItem.leftBarButtonItem;
        }
        
        [_editItem setTitle:NSLocalizedString(@"Remove", nil)];
        [_editItem setEnabled:NO];
        [_viewController.navigationItem setLeftBarButtonItem:_cancelItem];
    }
}

- (void)cancelEdit {
    
    _selectedItems = [[NSMutableDictionary alloc] init];
    _selectedIndexes = [[NSMutableArray alloc] init];

    for (int i = 0; i < [_viewController.items count]; i++) {
        
        UICollectionViewCell *cell = [_viewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        [cell setSelected:NO];
    }
    
    [self exitEditMode];
}

- (void)deleteItems:(NSArray *)arrayIds {
    
    if ([self.datasource conformsToProtocol:@protocol(ROSynchronize)]) {
        
        [(NSObject<ROSynchronize> *)self.datasource setSynchronized:NO];
    }
    
    [SVProgressHUD show];
    
    [_crudService deleteItemsWithIdentifiers:arrayIds successBlock:^(id response) {
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Items removed", nil)];
        
        [_viewController loadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self cancelEdit];
            
        });
        
    } failureBlock:^(ROError *error) {
        
        [SVProgressHUD dismiss];

        [error show];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self cancelEdit];
            
        });
    }];
}

- (void)exitEditMode {
    
    [self.viewController ro_showBottomToolbarAnimated:YES];

    [_viewController.collectionView setAllowsMultipleSelection:NO];
    
    [_editItem setTitle:NSLocalizedString(@"Edit", nil)];
    [_editItem setEnabled:YES];
    
    if (_prevLeftBB) {
        
        [_viewController.navigationItem setLeftBarButtonItem:_prevLeftBB];
    
    } else {
        
        [_viewController.navigationItem setLeftBarButtonItem:nil];
    }
    
    [_viewController.collectionView setDataSource:_viewController];
    [_viewController.collectionView setDelegate:_viewController];
}

- (NSInteger)collectionNumCols {
    
    return [_viewController numberOfColumns];
}

#pragma mark - UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        [self deleteItems:_arrayIds];
    }
}

#pragma mark - UICollectionViewLayoutDelegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_viewController collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return [_viewController collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [_viewController collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_viewController.collectionView performBatchUpdates:nil completion:nil];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return [_viewController collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
}

#pragma mark - UICollectionViewDataSource methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [_viewController collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if ([_selectedIndexes containsObject:indexPath]) {
        
        [cell setSelected:YES];
        [_viewController.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    else {
        
        [cell setSelected:NO];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_viewController.items count];
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [_selectedItems setObject:[_viewController.items objectAtIndex:indexPath.row] forKey:[indexPath description]];
    [_selectedIndexes addObject:indexPath];
    
    if ([_selectedItems count] == 1) {
        
        [_editItem setEnabled:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [_selectedItems removeObjectForKey:[indexPath description]];
    [_selectedIndexes removeObject:indexPath];
    [_viewController.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    if (![_selectedItems count]) {
        
        [_editItem setEnabled:NO];
    }
    
}

@end
