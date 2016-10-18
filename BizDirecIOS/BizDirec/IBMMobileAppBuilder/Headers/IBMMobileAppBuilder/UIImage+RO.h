//
//  UIImage+RO.h
//  IBMMobileAppBuilder
//

#import <UIKit/UIKit.h>

/**
 Helper to UIImage
 */
@interface UIImage (RO)

/**
 @param name Image name
 @return Image
 */
+ (UIImage*)ro_imageNamed:(NSString*)name;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)ro_fixRotation:(UIImage *)image;

@end
