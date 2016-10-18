//
//  UIImageView+RO.m
//  IBMMobileAppBuilder
//

#import "UIImageView+RO.h"
#import "UIImage+RO.h"
#import "NSString+RO.h"
#import "UIColor+RO.h"

@implementation UIImageView (RO)

- (void)ro_setImage:(NSString *)imageString backgroundColor:(UIColor *)backgroundColor imageError:(UIImage *)imageError
{
    if (![imageString isUrl]) {
        
        UIImage *image = [UIImage ro_imageNamed:imageString];
        if (!image) {
            image = imageError;
        }
        [self setImage:image];
        
    } else {
        
        [self ro_setImageWithUrlString:imageString backgroundColor:backgroundColor imageError:imageError];
        
    }
}

- (void)ro_setImage:(NSString *)imageString imageError:(UIImage *)imageError
{
    [self ro_setImage:imageString backgroundColor:self.superview.backgroundColor imageError:imageError];
}

- (void)ro_setImageWithUrlString:(NSString *)urlString backgroundColor:(UIColor *)backgroundColor imageError:(UIImage *)imageError
{
    __weak typeof(self) weakImageView = self;
    
    [self ro_setImageWithUrlString:urlString backgroundColor:backgroundColor completeBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error) {
            [weakImageView setImage:imageError];
        }
        
    }];
}

- (void)ro_setImageWithUrlString:(NSString *)urlString backgroundColor:(UIColor *)backgroundColor completeBlock:(SDWebImageCompletionBlock)completeBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhite;
    
    if (!backgroundColor) {
        backgroundColor = self.superview.backgroundColor;
    }
    
    if ([backgroundColor ro_lightStyle]) {
        indicatorStyle = UIActivityIndicatorViewStyleGray;
    }
    
    [self setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (completeBlock) {
            
            completeBlock(image, error, cacheType, imageURL);
        }
        
    } usingActivityIndicatorStyle:indicatorStyle];
}

- (void)ro_setImageWithUrlString:(NSString *)urlString imageError:(UIImage *)imageError
{
    [self ro_setImageWithUrlString:urlString backgroundColor:self.superview.backgroundColor imageError:imageError];
}

- (void)ro_setImageWithUrlString:(NSString *)urlString
{
    [self ro_setImageWithUrlString:urlString imageError:nil];
}

- (void)ro_updateContentMode
{
    if (self.image) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        /*
         CGSize imageSize = self.image.size;
         CGSize imageViewSize = self.frame.size;
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        if (imageSize.width > imageViewSize.width || imageSize.height > imageViewSize.height) {
        
            self.contentMode = UIViewContentModeScaleAspectFit;
            
        }
         */
    }
}

- (void)ro_setTintColor:(UIColor *)tintColor
{
    UIImage *image = self.image;
    if (image) {
        self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    [self setTintColor:tintColor];    
}

@end
