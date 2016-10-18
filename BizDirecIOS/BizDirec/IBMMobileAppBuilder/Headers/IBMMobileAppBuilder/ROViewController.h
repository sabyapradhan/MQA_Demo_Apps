//
//  ROViewController.h
//  IBMMobileAppBuilder
//

#import <UIKit/UIKit.h>
#import "RODataLoader.h"

typedef NS_ENUM(NSInteger, ROLayoutType)
{
    /** Web view layout */
    ROLayoutWeb = 0,
    /** Detail view layout */
    ROLayoutDetailVertical,
    /** Custom view layout */
    ROLayoutCustom,
    /** Table view layout with title and description */
    ROLayoutListTitleDescription,
    /** Table view layout with title, description below each other and image on the left */
    ROLayoutListPhotoTitleDescription,
    /** Table view layout title and image on same row and description below */
    ROLayoutListPhotoTitleBottomDescription,
    /** Collection view layout with image */
    ROLayoutAlbum,
    /** Table view layout with title */
    ROLayoutMenuTitle,
    /** Table view layout with title and image on same row */
    ROLayoutMenuIconTitle,
    /** Collection view layout with image and title below each other */
    ROLayoutMenuMosaic,
    /** Chart pie view layout*/
    ROLayoutChartPie,
    /** Chart bars view layout*/
    ROLayoutChartBars,
    /** Chart lines view layout*/
    ROLayoutChartLines
};

@class ROError;

/**
 Generic ui view controller
 */
@interface ROViewController : UIViewController

/**
 Data loader
 */
@property (nonatomic, strong) NSObject<RODataLoader> *dataLoader;

/**
 All behaviors
 */
@property (nonatomic, strong) NSMutableArray *behaviors;

/**
 Style of cells
 */
@property (nonatomic, assign) ROLayoutType layoutType;

/**
 Further setup after viewDidLoad is done
 */
- (void)configureView;

@end
