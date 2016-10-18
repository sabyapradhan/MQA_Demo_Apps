//
//  ROChartSerie.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@interface ROChartSerie : NSObject

/**
 Chart serie identifier
 */
@property (nonatomic, strong) NSString *identifier;

/**
 Chart serie label
 */
@property (nonatomic, strong) NSString *label;

/**
 Chart serie color
 */
@property (nonatomic, strong) UIColor *color;

/**
 Values of chart serie
 */
@property (nonatomic, strong) NSMutableArray *values;

/**
 Constructor with label
 @param label Chart serie label
 @return Class instance
 */
- (instancetype)initWithLabel:(NSString *)label;

/**
 Constructor with label and color
 @param label Chart serie label
 @param color Chart serie color
 @return Class instance
 */
- (instancetype)initWithLabel:(NSString *)label atColor:(UIColor *)color;

/**
 Constructor with label and color (hex string)
 @param label Chart serie label
 @param color Chart serie color (hex string)
 @return Class instance
 */
- (instancetype)initWithLabel:(NSString *)label atColorHexString:(NSString *)colorHexString;

@end
