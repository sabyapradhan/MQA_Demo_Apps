//
//  ROChartViewController.h
//  IBMMobileAppBuilder
//

#import "ROViewController.h"
#import "ROChartView.h"
#import "RODataDelegate.h"

@protocol ROChartViewDelegate <NSObject>

/**
 *  Configure serie at index
 *
 *  @param index Index
 */
- (void)configureSeriesAtIndex:(NSInteger)index;

@end

@interface ROChartViewController : ROViewController <RODataDelegate>

/**
 Chart view
 */
@property (nonatomic, strong) ROChartView *chartView;

/**
 Chart type
 */
@property (nonatomic, assign) ROChartType chartType;

/**
 Chart x axis
 */
@property (nonatomic, strong) ROChartSerie *xAxis;

/**
 Chart serie 1
 */
@property (nonatomic, strong) ROChartSerie *serie1;

/**
 Chart serie 2
 */
@property (nonatomic, strong) ROChartSerie *serie2;

/**
 Chart serie 3
 */
@property (nonatomic, strong) ROChartSerie *serie3;

/**
 Chart serie 4
 */
@property (nonatomic, strong) ROChartSerie *serie4;

/**
 *  Items to load
 */
@property (nonatomic, strong) NSArray *items;

/**
 ROChartViewDelegate
 */
@property (nonatomic, weak) id<ROChartViewDelegate> chartViewDelegate;

@end
