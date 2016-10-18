//
//  ROTableViewCell.h
//  IBMMobileAppBuilder
//

#import <UIKit/UIKit.h>

/**
 Table view cell style options
 */
typedef NS_ENUM(NSInteger, ROTableViewCellStyle)
{
    /** Cell with title */
    ROTableViewCellStyleTitle = 111,
    /** Cell with title and image on same row */
    ROTableViewCellStylePhotoTitle,
    /** Cell with title and description below each other */
    ROTableViewCellStyleTitleDescription,
    /** Cell with title, description  below each other and image on the left */
    ROTableViewCellStylePhotoTitleDescription,
    /** Cell with title and image on same row and description below */
    ROTableViewCellStylePhotoTitleBottomDescription,
    /** Cell with text */
    ROTableViewCellStyleDetailText,
    /** Cell with image */
    ROTableViewCellStyleDetailImage,
    /** Cell with header text */
    ROTableViewCellStyleDetailHeader
};

/**
 Generic table view cell.
 */
@interface ROTableViewCell : UITableViewCell

/**
 Image view
 */
@property (nonatomic, strong) UIImageView *photoImageView;

/**
 Title label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 Detail label
 */
@property (nonatomic, strong) UILabel *detailLabel;

/**
 Cell style
 */
@property (nonatomic, assign, readonly) ROTableViewCellStyle cellStyle;

/**
 Constructor with style and identifier
 @param style Cell style
 @param style Cell identifier
 @return Class instance
 */
- (instancetype)initWithROStyle:(ROTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/**
 Add all subviews
 */
- (void)setup;

/**
 Configure all constraints
 */
- (void)setupConstraints;

@end
