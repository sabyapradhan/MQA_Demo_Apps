//
//  ROCollectionViewController.h
//  IBMMobileAppBuilder
//

#import "ROViewController.h"
#import "RODataDelegate.h"

@interface ROCollectionViewController : ROViewController <RODataDelegate>

/**
 Collection view
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 Flow layout
 */
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/**
 *  Items to load
 */
@property (nonatomic, strong) NSArray *items;

/**
 Number of columns
 */
@property (nonatomic, assign) NSInteger numberOfColumns;

/**
 Load data on pagination
 */
- (void)loadMore;

/**
 Configure constraints
 */
- (void)setupConstraints;

@end
