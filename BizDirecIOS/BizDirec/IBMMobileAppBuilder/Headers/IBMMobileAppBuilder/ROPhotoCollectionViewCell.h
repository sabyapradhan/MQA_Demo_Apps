//
//  ROPhotoCollectionViewCell.h
//  IBMMobileAppBuilder
//

#import <UIKit/UIKit.h>

@interface ROPhotoCollectionViewCell : UICollectionViewCell

/**
 Image view
 */
@property (nonatomic, strong) UIImageView *photoImageView;

/**
 Selected image view
 */
@property (nonatomic, strong) UIImageView *selectedImageView;

/**
 Add all subviews
 */
- (void)setup;

/**
 Configure all constraints
 */
- (void)setupConstraints;

@end
