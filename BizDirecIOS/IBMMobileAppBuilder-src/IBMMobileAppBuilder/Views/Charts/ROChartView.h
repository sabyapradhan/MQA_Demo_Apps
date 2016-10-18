//
//  ROChart.h
//  IBMMobileAppBuilder
//

#import <UIKit/UIKit.h>
#import "ROChartSerie.h"

/**
 Chart type options
 */
typedef NS_ENUM(NSInteger, ROChartType) {
    /** Lines chart */
    ROChartTypeLine,
    /** Bars chart */
    ROChartTypeBar,
    /** Pie chart */
    ROChartTypePie
};

@interface ROChartView : UIView

/**
 Chart type
 */
@property (nonatomic, assign) ROChartType chartType;

/**
 X axis chart serie
 */
@property (nonatomic, strong) ROChartSerie *xAxis;

/**
 Chart series
 */
@property (nonatomic, strong) NSMutableArray *series;

/**
 Text and lines color
 */
@property (nonatomic, strong) UIColor *foregroundColor;

/**
 Font name
 */
@property (nonatomic, strong) NSString *fontName;

/**
 Font size
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 Remove and draw the chart
 */
- (void)drawChart;

/**
 Change the serie of pie chart
 */
- (void)selectPieChartSerieAtIndex:(int)index;

@end