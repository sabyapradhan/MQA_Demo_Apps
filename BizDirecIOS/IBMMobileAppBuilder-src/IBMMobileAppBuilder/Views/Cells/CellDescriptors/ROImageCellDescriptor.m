//
//  ROImageCellDescriptor.m
//  IBMMobileAppBuilder
//

#import "ROImageCellDescriptor.h"
#import "ROTableViewCell.h"
#import "UITableViewCell+RO.h"
#import "UIImageView+RO.h"
#import "ROStyle.h"
#import "NSString+RO.h"
#import "UIImage+RO.h"

static NSString *const kCellIdentifier = @"detailImageCellIdentifier";

@interface ROImageCellDescriptor ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation ROImageCellDescriptor

- (instancetype)initWithImageString:(NSString *)imageString action:(NSObject<ROAction> *)action {
    
    self = [super self];
    if (self) {
        self.imageString = imageString;
        self.action = action;
        
        if (![self.imageString isUrl]) {
            
            self.image = [UIImage ro_imageNamed:self.imageString];
        }
    }
    return self;
}

+ (instancetype)imageString:(NSString *)imageString action:(NSObject<ROAction> *)action {
    
    return [[self alloc] initWithImageString:imageString action:action];
}

- (void)dealloc {
    
    [self receiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ROTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        
        cell = [[ROTableViewCell alloc] initWithROStyle:ROTableViewCellStyleDetailImage
                                        reuseIdentifier:kCellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];  // Adding this fixes the issue for iPad
    [cell ro_configureSelectedView];
    
    if (self.image) {
        
        cell.photoImageView.image = self.image;
    
    } else {
        
        [cell.photoImageView ro_setImageWithUrlString:self.imageString
                                       backgroundColor:[[ROStyle sharedInstance] backgroundColor]
                                         completeBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             
                                             dispatch_main_sync_safe(^{
                                             
                                                 if (image) {
                                                     
                                                     [[SDImageCache sharedImageCache] storeImage:image
                                                                                          forKey:[imageURL absoluteString]
                                                                                          toDisk:YES];
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         [tableView reloadData];
                                                         
                                                     });
                                                 }
                                                 
                                             });
                                         }];
    }
    
    [self configureCell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.action && [self.action canDoAction]) {
        
        [self.action doAction];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0.0f;
    if (self.image) {
        
        static ROTableViewCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            sizingCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        });
        [self configureCell:sizingCell];
        if (self.image.size.width > CGRectGetWidth(tableView.bounds)) {
            
            float ratio = self.image.size.width / self.image.size.height;
            CGSize newSize = CGSizeMake(CGRectGetWidth(tableView.bounds), CGRectGetWidth(tableView.bounds) / ratio);
            height = newSize.height;
            
        } else {
            
            height = self.image.size.height;
        }
    }
    return height;
}

- (BOOL)isEmpty {
    
    if (![self.imageString isUrl]) {
        
        if (self.image == nil) {
            
            return YES;
        }
    }
    
    return NO;
}

- (void)receiveMemoryWarning {
    
    if (_image) {
        
        _image = nil;
    }
    [[SDImageCache sharedImageCache] removeImageForKey:self.imageString];
}

- (UIImage *)image {
    
    if (!_image) {
        
        _image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageString];
    }
    return _image;
}

- (void)configureCell:(ROTableViewCell *)cell {
    
    cell.userInteractionEnabled = NO;
    for (UIView *view in cell.photoImageView.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]]) {
            
            [view removeFromSuperview];
        }
    }
    if (self.action && [self.action canDoAction]) {
        
        cell.userInteractionEnabled = YES;
        
        if (cell.photoImageView.image) {
            
            UIImage *icon = [self.action actionIcon];
            if (icon) {
                
                UIImageView *actionImageView = [[UIImageView alloc] initWithImage:icon];
                actionImageView.center = cell.photoImageView.center;
                [actionImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [cell.photoImageView addSubview:actionImageView];
                NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                                   constraintWithItem:actionImageView
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:cell.photoImageView
                                                   attribute:NSLayoutAttributeCenterX
                                                   multiplier:1.0
                                                   constant:0];
                
                NSLayoutConstraint *myConstraint2 =[NSLayoutConstraint
                                                    constraintWithItem:actionImageView
                                                    attribute:NSLayoutAttributeCenterY
                                                    relatedBy:NSLayoutRelationEqual
                                                    toItem:cell.photoImageView
                                                    attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                    constant:0];
                
                [cell.photoImageView addConstraint:myConstraint];
                [cell.photoImageView addConstraint:myConstraint2];
            }
        }
    }
}

@end
