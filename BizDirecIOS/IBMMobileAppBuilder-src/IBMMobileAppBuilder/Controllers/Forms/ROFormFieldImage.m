//
//  ROFormFieldImage.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldImage.h"
#import "ROStyle.h"
#import "UIImageView+RO.h"
#import "UIImage+RO.h"
#import "ROViewController.h"

static NSString *const kImageCellIdentifier = @"imageCellIdentifier";

@interface ROFormFieldImage () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *table;

- (void)resetImage;

@end

@implementation ROFormFieldImage

- (instancetype)initWithLabel:(NSString *)label name:(NSString *)name viewController:(UIViewController *)viewController required:(BOOL)required
{
    self = [super init];
    if (self) {
        _label = label;
        _name = name;
        _required = required;
        _viewController = viewController;
    }
    return self;
}

+ (instancetype)fieldWithLabel:(NSString *)label name:(NSString *)name viewController:(UIViewController *)viewController required:(BOOL)required
{
    return [[self alloc] initWithLabel:label name:name viewController:viewController required:required];
}

- (instancetype)initWithLabel:(NSString *)label name:(NSString *)name viewController:(UIViewController *)viewController url:(NSString *)url required:(BOOL)required
{
    self = [super init];
    if (self) {
        _label = label;
        _name = name;
        _required = required;
        _viewController = viewController;
        _urlBasePhoto = url;
    }
    return self;
}

+ (instancetype)fieldWithLabel:(NSString *)label name:(NSString *)name viewController:(UIViewController *)viewController url:(NSString *)url required:(BOOL)required
{
    return [[self alloc] initWithLabel:label name:name viewController:viewController url:url required:required];
}

#pragma mark - Private Methods
#pragma mark -

- (ROImageCrudTableViewCell *)cell
{
    if (!_cell) {
        _cell = [self fieldCell];
    }
    return _cell;
}

- (ROImageCrudTableViewCell *)fieldCell {
    
    ROImageCrudTableViewCell *cell = [[ROImageCrudTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kImageCellIdentifier];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)removeImage {

    [self resetImage];
    _value = [NSNull null];
}

- (void)takePhoto {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {

        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = YES;
        controller.delegate = self;

        [_viewController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)choosePhotoCameraRoll {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = YES;
        controller.delegate = self;
        
        [_viewController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)dealloc
{
    if (_label) {
        _label = nil;
    }
    if (_name) {
        _name = nil;
    }
    if (_value) {
        _value = nil;
    }
    if (_theNewImage) {
        _theNewImage = nil;
    }
    if (_urlBasePhoto) {
        _urlBasePhoto = nil;
    }
}

- (void)resetImage {

    UIImage *image = [UIImage ro_imageNamed:@"noImage"];
    [_cell.photoImageView setImage:image];
    [_cell.photoImageView ro_setTintColor:[[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.6f]];
}

#pragma mark - ROFormFieldDelegate Methods
#pragma mark -

- (id)jsonValue {
    
    if (_theNewImage) {
        
        NSData *data = UIImageJPEGRepresentation(_theNewImage, 0.95);
        
        return data;
    }
    else {
        
        return _value;
    }
    return [NSNull null];
}

- (BOOL)valid {
    
    BOOL isValid = YES;
    _cell.errorLabel.text = nil;

    if (_required) {
        
        if (_value == nil && _theNewImage == nil) {
            
            isValid = NO;
        }
    }
    
    if (!isValid) {
        _cell.errorLabel.text = NSLocalizedString(@"Required", nil);
    }
    
    return isValid;
}

- (void)reset {
    
    _value = nil;
    _theNewImage = nil;
    _cell.errorLabel.text = nil;
    [self resetImage];
}

#pragma mark - UI
#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _table = tableView;
    
    ROImageCrudTableViewCell *cell = [self cell];
    
    if (!_theNewImage) {
        
        if (_value) {
            
            if (_urlBasePhoto) {
    
                [cell.photoImageView ro_setImage:[NSString stringWithFormat:_urlBasePhoto, _value]
                                      imageError:[[ROStyle sharedInstance] noPhotoImage]];
                
            } else if ([self.viewController isKindOfClass:[ROViewController class]]) {
            
                ROViewController *viewController = (ROViewController *)self.viewController;
                
                [cell.photoImageView ro_setImage:[viewController.dataLoader.datasource imagePath:_value]
                                      imageError:[[ROStyle sharedInstance] noPhotoImage]];
            } else {

                [cell.photoImageView ro_setImage:_value
                                      imageError:[[ROStyle sharedInstance] noPhotoImage]];
            }
    
        }
        else {
            
            [self resetImage];
        }
    }
    else {
        
        [cell.photoImageView setImage:_theNewImage];
    }
    
    [cell.label setText:_name];
    cell.label.font = [[[ROStyle sharedInstance] font] fontWithSize:[[[ROStyle sharedInstance] fontSizeSmall] floatValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *removeButtonTitle = nil;
    if (_value) {
        removeButtonTitle = NSLocalizedString(@"Delete", nil);
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:removeButtonTitle
                                                    otherButtonTitles:NSLocalizedString(@"Take a picture", nil), NSLocalizedString(@"Camera roll", nil), nil];
    [actionSheet showInView:tableView.superview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.0f;
}

#pragma mark - UIActionSheetDelegate Methods
#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (_value) {
        switch (buttonIndex) {
                
            case 0:
                [self removeImage];
                break;
                
            case 1:
                [self takePhoto];
                break;
                
            case 2:
                [self choosePhotoCameraRoll];
                break;
                
            default:
                break;
        }
        
    } else {
        
        switch (buttonIndex) {
                
            case 0:
                [self takePhoto];
                break;
                
            case 1:
                [self choosePhotoCameraRoll];
                break;
                
            default:
                break;
        }
    }
    

}

#pragma mark - UIImagePickerControllerDelegate methods
#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *imageCamera = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _theNewImage = [UIImage ro_fixRotation:imageCamera];
    
    [_table reloadData];
        
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
 
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
