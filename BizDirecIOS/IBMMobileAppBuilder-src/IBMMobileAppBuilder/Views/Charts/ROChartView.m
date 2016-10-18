//
//  ROChart.m
//  IBMMobileAppBuilder
//

#import "ROChartView.h"
#import <CorePlot/ios/CorePlot-CocoaTouch.h>
#import <Colours/Colours.h>
#import "NSString+RO.h"
#import "NSDecimalNumber+RO.h"
#import "ROStyle.h"

@interface ROChartView () <CPTPlotDataSource>

@property (nonatomic, strong) CPTGraphHostingView *hostView;

@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat paddingBottom;

@property (nonatomic, strong) ROChartSerie *pieChartSerie;
@property (nonatomic, strong) NSMutableDictionary *chartValues;

- (BOOL)isLandscape;
- (BOOL)isRotationLabels;
- (CPTMutableTextStyle *)chartTextStyle;
- (CPTMutableLineStyle *)chartLineStyleAtWidth:(CGFloat)width atAlphaComponent:(CGFloat)alpha atColor:(UIColor *)color;
- (CPTMutableLineStyle *)chartLineStyleAtWidth:(CGFloat)width atAlphaComponent:(CGFloat)alpha;
- (CPTMutableLineStyle *)chartLineStyleAtWidth:(CGFloat)width atColor:(UIColor *)color;
- (CPTMutableLineStyle *)chartLineStyleAtWidth:(CGFloat)width;
- (NSNumber *)tickLocationAtindex:(int)index;

- (void)configureHost;
- (void)configureGraph;
- (void)configureAxes;
- (void)configurePlots;
- (void)configureLegend;
- (void)configureBarChart;
- (void)configureLineChart;
- (void)configurePieChart;

@end

@implementation ROChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
        self.clipsToBounds = YES;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        _padding = 10.0f;
        _paddingBottom = 10.0f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawChart];
}

- (UIColor *)foregroundColor {
    if (!_foregroundColor) {
        _foregroundColor = [UIColor darkGrayColor];
    }
    return _foregroundColor;
}

- (NSString *)fontName {
    if (!_fontName) {
        _fontName = @"HelveticaNeue";
    }
    return _fontName;
}

- (CGFloat)fontSize {
    if (_fontSize == 0) {
        _fontSize = 10.0f;
    }
    return _fontSize;
}

- (NSMutableArray *)series {
    if (!_series) {
        _series = [NSMutableArray new];
    }
    return _series;
}

- (NSMutableDictionary *)chartValues
{
    if (!_chartValues) {
        _chartValues = [NSMutableDictionary new];
    }
    return _chartValues;
}

- (ROChartSerie *)pieChartSerie
{
    if (!_pieChartSerie) {
        _pieChartSerie = [self.series objectAtIndex:0];
    }
    return _pieChartSerie;
}

- (BOOL)isLandscape {
    return (self.bounds.size.width / self.bounds.size.height) > 1;
}

- (BOOL)isRotationLabels
{
    return [self.xAxis.values count] > 5;
}

- (void)selectPieChartSerieAtIndex:(int)index
{
    if (index >= [self.series count]) {
        index = 0;
    }
    _pieChartSerie = [self.series objectAtIndex:index];
}

#pragma mark - Chart behavior

- (void)drawChart {
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    if ([self.series count] != 0) {
        _barWidth = 1.0f / ([self.series count] + 1);
        [self configureHost];
        [self configureGraph];
        [self configurePlots];
        [self configureAxes];
        [self configureLegend];
    }
}

- (void)configureHost
{
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.bounds];
    self.hostView.allowPinchScaling = YES;
    self.hostView.collapsesLayers = YES;
    self.hostView.clipsToBounds = YES;
    [self addSubview:self.hostView];
}

- (void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView.hostedGraph = graph;
    // 2 - Configure the graph
    graph.borderLineStyle = nil;
    graph.fill = [[CPTFill alloc] initWithColor:[CPTColor clearColor]];
    graph.paddingBottom = _padding;
    graph.paddingLeft = _padding;
    graph.paddingTop = _padding;
    graph.paddingRight = _padding;
}

- (void)configureAxes {
    CPTGraph *graph = self.hostView.hostedGraph;
    if (_chartType != ROChartTypePie) {
        // 1 - Configure styles
        CPTMutableTextStyle *textStyle = [self chartTextStyle];
        CPTMutableLineStyle *axisLineStyle = [self chartLineStyleAtWidth:0.5f];
        CPTMutableLineStyle *majorGridLineStyle = [self chartLineStyleAtWidth:0.1f atAlphaComponent:0.75f];
        // 2 - Get the graph's axis set
        CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
        // 3 - Configure the x-axis
        axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
        axisSet.xAxis.axisLineStyle = axisLineStyle;
        if (self.xAxis.label) {
            _paddingBottom = _padding * 2;
            axisSet.xAxis.title = self.xAxis.label;
            axisSet.xAxis.titleTextStyle = [self chartTextStyle];
            axisSet.xAxis.titleOffset = _paddingBottom;
            if ([self isRotationLabels]) {
                axisSet.xAxis.titleOffset += 30.0f;
            }
        }
        // 4 - Configure the y-axis
        axisSet.yAxis.axisLineStyle = axisLineStyle;
        axisSet.yAxis.minorTickLineStyle = axisLineStyle;
        axisSet.yAxis.majorTickLineStyle = axisLineStyle;
        axisSet.yAxis.minorTickLabelTextStyle = textStyle;
        axisSet.yAxis.labelTextStyle = textStyle;
        axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
        axisSet.yAxis.minorTicksPerInterval = 4;
        axisSet.yAxis.preferredNumberOfMajorTicks = 8;
        axisSet.yAxis.majorGridLineStyle = majorGridLineStyle;
        if (_chartType == ROChartTypeLine) {
            axisSet.xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
        }
        // 5 - Configure x labels
        NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[self.xAxis.values count]];
        CGFloat rotation = 0.0f;
        if ([self isRotationLabels]) {
            rotation = -M_PI_4;
        }
        NSUInteger n = [self.xAxis.values count];
        for (int i=0; i!=n; i++) {
            NSString *value = [NSString ro_stringByObject:[self.xAxis.values objectAtIndex:i]];
            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc]
                                      initWithText:[value ro_truncate:9]
                                      textStyle:textStyle];
            newLabel.tickLocation = [self tickLocationAtindex:i];
            newLabel.offset = 2.0;
            newLabel.rotation = rotation;
            [customLabels addObject:newLabel];
        }
        axisSet.xAxis.axisLabels =  [NSSet setWithArray:customLabels];
        // 6 - Configure plot space
        [graph.defaultPlotSpace scaleToFitPlots:[graph allPlots] forCoordinate:CPTCoordinateY];
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
        CGFloat xMin = 0.0f;
        CGFloat xMax = [self.xAxis.values count];
        double yMin = plotSpace.yRange.minLimitDouble - (plotSpace.yRange.minLimitDouble * 0.5f);
        if (yMin < 0) {
            yMin = 0;
        }
        double yMax = (plotSpace.yRange.maxLimitDouble - yMin) * 1.05f;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:xMin]
                                                        length:[NSNumber numberWithFloat:xMax]];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:yMin]
                                                        length:[NSNumber numberWithFloat:yMax]];
        
    } else {
        graph.axisSet = nil;
    }
}

- (NSNumber *)tickLocationAtindex:(int)index
{
    NSNumber *tickLocation = nil;
    switch (self.chartType) {
        case ROChartTypeBar:
            tickLocation = [NSNumber numberWithDouble:( ( _barWidth + (_barWidth * [self.series count]) ) / 2 ) + index];
            break;
        case ROChartTypeLine:
            tickLocation = [NSNumber numberWithFloat:index + 0.5f];
            break;
        default:
            tickLocation = [NSNumber numberWithInt:index];
            break;
    }
    return tickLocation;
}

- (void)configurePlots
{
    switch (self.chartType) {
        case ROChartTypeBar:
            [self configureBarChart];
            break;
        case ROChartTypeLine:
            [self configureLineChart];
            break;
        case ROChartTypePie:
            [self configurePieChart];
            break;
        default:
            break;
    }
}

- (void)configureBarChart
{
    // 1 - Set up line style
    CPTMutableLineStyle *barLineStyle = [self chartLineStyleAtWidth:0.2f atAlphaComponent:0.2f];
    // 2 - Add plots to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    CGFloat barX = _barWidth;
    for (ROChartSerie *chartSerie in self.series) {
        [self.chartValues setObject:chartSerie.values forKey:chartSerie.label];
        CPTBarPlot *plot = [CPTBarPlot new];
        plot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[chartSerie.color CGColor]]];
        plot.identifier = chartSerie.label;
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = [NSNumber numberWithFloat:_barWidth];
        plot.barOffset = [NSNumber numberWithFloat:barX];
        plot.lineStyle = barLineStyle;
        plot.labelRotation = M_PI_2;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        barX += _barWidth;
    }
}

- (void)configureLineChart
{
    CPTGraph *graph = self.hostView.hostedGraph;
    for (ROChartSerie *chartSerie in self.series) {
        [self.chartValues setObject:chartSerie.values forKey:chartSerie.label];
        CPTScatterPlot *plot = [CPTScatterPlot new];
        plot.dataSource = self;
        plot.delegate = self;
        plot.identifier = chartSerie.label;
        plot.dataLineStyle = [self chartLineStyleAtWidth:1.0f atColor:chartSerie.color];
        plot.labelRotation = M_PI_2;
        CPTPlotSymbol *symbol = [CPTPlotSymbol ellipsePlotSymbol];
        symbol.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[chartSerie.color CGColor]]];
        symbol.lineStyle = plot.dataLineStyle;
        symbol.size = CGSizeMake(5.0f, 5.0f);
        plot.plotSymbol = symbol;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
    }
}

- (void)configurePieChart
{
    [self.chartValues setObject:self.pieChartSerie.values forKey:self.pieChartSerie.label];
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create chart
    CGFloat radius = self.hostView.bounds.size.height / 2;
    if (![self isLandscape]) {
        radius = self.hostView.bounds.size.width / 2;
    }
    radius -= (_padding * 4);
    CPTPieChart *pieChart = [CPTPieChart new];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = radius;
    pieChart.identifier = self.pieChartSerie.label;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    pieChart.borderLineStyle = [self chartLineStyleAtWidth:0.2f atAlphaComponent:0.5f];
    pieChart.labelOffset = - radius / 2;
    pieChart.labelRotationRelativeToRadius = NO;
    CPTMutableShadow *labelShadow = [CPTMutableShadow shadow];
    labelShadow.shadowOffset = CGSizeMake(1,1);
    labelShadow.shadowBlurRadius = 1.0f;
    labelShadow.shadowColor = [CPTColor colorWithCGColor:[self.foregroundColor CGColor]];
    pieChart.labelShadow = labelShadow;
    // 3 - Add chart to graph
    [graph addPlot:pieChart];
}

- (void)configureLegend
{
    // 1 - Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    // 3 - Configure legen
    theLegend.numberOfColumns = [self.series count] > 4 ? 4 : [self.series count];
    theLegend.textStyle = [self chartTextStyle];
    // 4 - Add legend to graph
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorBottomLeft;
    // 5 - Configure graph padding
    CGFloat paddingLeft = 35.0f;
    UIFont *font = [UIFont fontWithName:self.fontName size:self.fontSize];
    if (font) {
        CPTXYPlotSpace *ps = (CPTXYPlotSpace *)graph.defaultPlotSpace;
        double yMaxValue = ps.yRange.endDouble;
        CGRect rect = [[NSString stringWithFormat: @"%.1f", yMaxValue] ro_rectByFont:font];
        paddingLeft = rect.size.width + (_padding * 2);
    }
    CGFloat paddingRotation = [self isRotationLabels] ? 25.0f : 0.0f;
    graph.paddingBottom = _paddingBottom + (([self.series count] / theLegend.numberOfColumns) * 50) + paddingRotation;
    graph.paddingLeft = paddingLeft;
    graph.paddingTop = _padding;
    graph.paddingRight = _padding;
    CGFloat legendWidth = 0.0f;
    if (font) {
        for (ROChartSerie *chartSerie in self.series) {
            CGRect rect = [chartSerie.label ro_rectByFont:font];
            legendWidth += rect.size.width + (graph.legend.swatchSize.width * 2);
        }
    } else {
        for (NSNumber *width in graph.legend.columnWidthsThatFit) {
            legendWidth += [width floatValue];
        }
    }
    if (_chartType == ROChartTypePie) {
        graph.paddingLeft = _padding;
        graph.legend.numberOfColumns = 3;
        if (![self isLandscape]) {
            graph.legendAnchor = CPTRectAnchorBottomLeft;
            graph.paddingRight = _padding;
            graph.paddingBottom = floor([self.pieChartSerie.values count] / graph.legend.numberOfColumns) * 25.0f;
            CPTPieChart *pieChart = (CPTPieChart *)[graph plotAtIndex:0];
            CGFloat height = pieChart.pieRadius * 2;
            CGFloat diff = self.hostView.bounds.size.height - (height + graph.paddingBottom);
            if (diff < 0) {
                pieChart.pieRadius += diff - (_padding * 2);
            }
        } else {
            graph.legend.numberOfColumns = 2;
            graph.legendAnchor = CPTRectAnchorRight;
            graph.paddingBottom = _padding;
            graph.paddingRight = 220.0f + (_padding * 2);
        }
    } else {
        if ([self isRotationLabels]) {
            graph.paddingRight += 10.0f;
        }
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.hostView.frame.size.width, 30.0f)];
        if ([[ROStyle sharedInstance] useStyleLightForColor:[[ROStyle sharedInstance] backgroundColor]]) {
            scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        } else {
            scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        }
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.clipsToBounds = YES;
        scrollView.userInteractionEnabled = YES;
        scrollView.contentSize = CGSizeMake(legendWidth, 30.0f);
        [scrollView.layer addSublayer:self.hostView.hostedGraph.legend];
        [self.hostView addSubview:scrollView];
    }
}

- (CPTMutableTextStyle *)chartTextStyle
{
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = self.fontName;
    textStyle.fontSize = self.fontSize;
    textStyle.color = [CPTColor colorWithCGColor:[self.foregroundColor CGColor]];
    return textStyle;
}

- (CPTMutableLineStyle *)chartLineStyleAtWidth:(CGFloat)width atAlphaComponent:(CGFloat)alpha atColor:(UIColor *)color
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = width;
    lineStyle.lineColor = [[CPTColor colorWithCGColor:[color CGColor]] colorWithAlphaComponent:alpha];
    return lineStyle;
}

- (CPTMutableLineStyle *)chartLineStyleAtWidth:(CGFloat)width atAlphaComponent:(CGFloat)alpha
{
    return [self chartLineStyleAtWidth:width atAlphaComponent:alpha atColor:self.foregroundColor];
}

- (CPTMutableLineStyle *)chartLineStyleAtWidth:(CGFloat)width atColor:(UIColor *)color
{
    return [self chartLineStyleAtWidth:width atAlphaComponent:1.0f atColor:color];
}

- (CPTMutableLineStyle *)chartLineStyleAtWidth:(CGFloat)width
{
    return [self chartLineStyleAtWidth:width atColor:self.foregroundColor];
}

#pragma mark - CPTPlotDataSource methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [[self.chartValues objectForKey:plot.identifier] count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    switch (_chartType) {
        case ROChartTypePie: {
            if (fieldEnum == CPTPieChartFieldSliceWidth) {
                NSArray *values = [self.chartValues objectForKey:plot.identifier];
                if (index < [values count]) {
                    return [values objectAtIndex:index];
                }
            }
            break;
        }
        case ROChartTypeLine: {
            NSArray *values = [self.chartValues objectForKey:plot.identifier];
            if (index < [values count]) {
                if (fieldEnum == CPTScatterPlotFieldY) {
                    return [values objectAtIndex:index];
                } else if (fieldEnum == CPTScatterPlotFieldX) {
                    return [NSDecimalNumber numberWithFloat:index + 0.5f];
                }
            }
            break;
        }
        case ROChartTypeBar: {
            NSArray *values = [self.chartValues objectForKey:plot.identifier];
            if (index < [values count]) {
                if (fieldEnum == CPTBarPlotFieldBarTip) {
                    return [values objectAtIndex:index];
                }
            }
            break;
        }
        default:
            break;
    }
    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    if (_chartType != ROChartTypePie) {
        //TODO: Other chart type
        return nil;
    }
    // 1 - Define label text style
    static CPTMutableTextStyle *textStyle = nil;
    if (!textStyle) {
        textStyle = [self chartTextStyle];
    }
    if (_chartType != ROChartTypePie) {
        textStyle.color = [CPTColor colorWithCGColor:[self.foregroundColor CGColor]];
    } else {
        textStyle.color = [CPTColor colorWithCGColor:[self.backgroundColor CGColor]];
    }
    // 2 - Calculate total value
    NSArray *values = [self.chartValues objectForKey:plot.identifier];
    NSDecimalNumber *total = [NSDecimalNumber zero];
    for (id value in values) {
        NSString *valueString = [NSString ro_stringByObject:value];
        NSDecimalNumber *decimal = [NSDecimalNumber ro_decimalNumberWithString:valueString];
        if (decimal == [NSDecimalNumber notANumber]) {
            decimal = [NSDecimalNumber zero];
        }
        total = [total decimalNumberByAdding:decimal];
    }
    NSString *valueString = [NSString ro_stringByObject:[values objectAtIndex:index]];
    return [[CPTTextLayer alloc] initWithText:valueString style:textStyle];
}

- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    if (index < [_xAxis.values count]) {
        NSString *label = [NSString ro_stringByObject:[_xAxis.values objectAtIndex:index]];
        return [label ro_truncate:12];
    }
    return @"N/A";
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    if (index >= [[ROChartView colors] count]) {
        index = index % [[ROChartView colors] count];
    }
    NSString *colorHexString = [[ROChartView colors] objectAtIndex:index];
    UIColor *color = [UIColor colorFromHexString:colorHexString];
    return [[CPTFill alloc] initWithColor:[CPTColor colorWithCGColor:color.CGColor]];
}

+ (NSArray *)colors
{
    static NSArray *_colors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _colors = @[@"17B9ED",
                    @"1992B8",
                    @"31D755",
                    @"EDE66D",
                    @"F4C745",
                    @"E88E38",
                    @"EA4C26",
                    @"FC6CBC",
                    @"E94A86",
                    @"C230D8",
                    @"9A1CF5",
                    @"733BC7",
                    @"8551F3",
                    @"5E4FDE",
                    @"4A3DBD",
                    @"173791",
                    @"32769A",
                    @"30A198",
                    @"26BBAF",
                    @"379B7D",
                    @"7DB324",
                    @"A0D743",
                    @"A3A153",
                    @"B69042",
                    @"EFAC57",
                    @"EF5E57",
                    @"FC8599",
                    @"DD6C6C",
                    @"4D5EFF",
                    @"24DDEB"
                    ];
    });
    return _colors;
}

@end