//
//  ROStyles.m
//  IBMMobileAppBuilder
//

#import "ROStyle.h"
#import "Colours.h"
#import "UIImage+RO.h"
#import "UIFont+RO.h"
#import "SVProgressHUD.h"

static NSString *const kStyleFileName           = @"Style";

static NSString *const kFontFamily              = @"HelveticaNeue";

static NSString *const kFontSize                = @"15";
static NSString *const kFontSizeSmall           = @"13";
static NSString *const kFontSizeLarge           = @"18";

static NSString *const kTableViewCellHeightMin  = @"44";

@implementation ROStyle

+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    
    self = [super initWithPlistName:self.fileName];
    if (self) {

    }
    return self;
}

- (void)apply {
    
    // UINavigationBar
    [[UINavigationBar appearance] setBarTintColor:self.applicationBarBackgroundColor];
    [[UINavigationBar appearance] setTintColor:self.applicationBarTextColor];
    
    NSDictionary *navTextAttributes = @{
                                        NSForegroundColorAttributeName: self.applicationBarTextColor,
                                        NSFontAttributeName : [self fontWithSize:[self.fontSizeSmall floatValue]]
                                        };
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:navTextAttributes
                                                                                            forState:UIControlStateNormal];
    
    NSDictionary *navTextDisabledAttributes = @{
                                        NSForegroundColorAttributeName: [UIColor grayColor],
                                        NSFontAttributeName : [self fontWithSize:[self.fontSizeSmall floatValue]]
                                        };
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:navTextDisabledAttributes
                                                                                            forState:UIControlStateDisabled];

    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName: self.applicationBarTextColor,
                                     NSFontAttributeName : [self font]
                                     };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];

    // UIToolbar
    
    [[UIToolbar appearance] setBarTintColor:self.applicationBarBackgroundColor];
    [[UIToolbar appearance] setTintColor:self.applicationBarTextColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTitleTextAttributes:navTextAttributes
                                                                                      forState:UIControlStateNormal];
    
    
    // UISearch
    
    NSDictionary *searchButtonTextAttributes = @{
                                        NSForegroundColorAttributeName: self.applicationBarTextColor,
                                        NSFontAttributeName : [self fontWithSize:[self.fontSize floatValue]]
                                        };
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:searchButtonTextAttributes
                                                                                        forState:UIControlStateNormal];
    
    // UIButton
    
    [UIButton appearance].titleLabel.font = self.font;
    
    // UIWindow
    
    [[UIWindow appearance] setBackgroundColor:self.backgroundColor];
    
    // UITableView
    
    [[UITableView appearance] setSeparatorColor:self.accentColor];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[self.foregroundColor colorWithAlphaComponent:0.8f]];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:self.font];
    
    [[UITableView appearance] setTintColor:self.accentColor];
    
    // UISwitch
    
    [[UISwitch appearance] setOnTintColor:self.applicationBarBackgroundColor];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (NSString *)fileName {
    
    if (!_fileName) {
        _fileName = kStyleFileName;
    }
    return _fileName;
}

- (void)setAccentColor:(id)accentColor {
    
    if (accentColor) {
        if ([accentColor isKindOfClass:[UIColor class]]) {
            _accentColor = accentColor;
        } else if ([accentColor isKindOfClass:[NSString class]]) {
            UIColor *color = [UIColor colorFromHexString:accentColor];
            _accentColor = color;
        }
    }
}

- (void)setBackgroundColor:(id)backgroundColor {
    
    if (backgroundColor) {
        if ([backgroundColor isKindOfClass:[UIColor class]]) {
            _backgroundColor = backgroundColor;
        } else if ([backgroundColor isKindOfClass:[NSString class]]) {
            UIColor *color = [UIColor colorFromHexString:backgroundColor];
            _backgroundColor = color;
        }
    }
}

- (void)setForegroundColor:(id)foregroundColor {
    
    if (foregroundColor) {
        if ([foregroundColor isKindOfClass:[UIColor class]]) {
            _foregroundColor = foregroundColor;
        } else if ([foregroundColor isKindOfClass:[NSString class]]) {
            UIColor *color = [UIColor colorFromHexString:foregroundColor];
            _foregroundColor = color;
        }
    }
}

- (void)setApplicationBarBackgroundColor:(id)applicationBarBackgroundColor {
    
    if (applicationBarBackgroundColor) {
        if ([applicationBarBackgroundColor isKindOfClass:[UIColor class]]) {
            _applicationBarBackgroundColor = applicationBarBackgroundColor;
        } else if ([applicationBarBackgroundColor isKindOfClass:[NSString class]]) {
            UIColor *color = [UIColor colorFromHexString:applicationBarBackgroundColor];
            _applicationBarBackgroundColor = color;
        }
    }
}

- (void)setApplicationBarTextColor:(id)applicationBarTextColor {
    
    if (applicationBarTextColor) {
        if ([applicationBarTextColor isKindOfClass:[UIColor class]]) {
            _applicationBarTextColor = applicationBarTextColor;
        } else if ([applicationBarTextColor isKindOfClass:[NSString class]]) {
            UIColor *color = [UIColor colorFromHexString:applicationBarTextColor];
            _applicationBarTextColor = color;
        }
    }
}

- (void)setBackgroundImage:(id)backgroundImage {
    
    if ([backgroundImage isKindOfClass:[UIImage class]]) {
        _backgroundImage = backgroundImage;
    } else if ([backgroundImage isKindOfClass:[NSString class]]) {
        UIImage *image = [UIImage ro_imageNamed:backgroundImage];
        _backgroundImage = image;
    }
}

- (void)setPlaceHolderImage:(id)placeHolderImage {
    
    if ([placeHolderImage isKindOfClass:[UIImage class]]) {
        _placeHolderImage = placeHolderImage;
    } else if ([placeHolderImage isKindOfClass:[NSString class]]) {
        UIImage *image = [UIImage ro_imageNamed:placeHolderImage];
        if (!image) {
            image = [UIImage ro_imageNamed:@"PlaceHolder"];
        }
        _placeHolderImage = image;
    }
}

- (void)setNoPhotoImage:(id)noPhotoImage {
    
    if ([noPhotoImage isKindOfClass:[UIImage class]]) {
        _noPhotoImage = noPhotoImage;
    } else if ([noPhotoImage isKindOfClass:[NSString class]]) {
        UIImage *image = [UIImage ro_imageNamed:noPhotoImage];
        if (!image) {
            image = [UIImage ro_imageNamed:@"NoPhoto"];
        }
        _noPhotoImage = image;
    }
}

- (void)processLabel:(UILabel *)label {
    
    label.textColor = self.foregroundColor;
    label.font = [self font];
}

- (NSString *)fontName {
    
    if (!_fontName) {
        _fontName = [[self font] fontName];
    }
    return _fontName;
}

- (NSString *)fontFamily {
    
    if (!_fontFamily) {
        _fontFamily = kFontFamily;
    }
    return _fontFamily;
}

- (NSNumber *)fontSize {
    
    if (!_fontSize) {
        _fontSize = [NSNumber numberWithFloat:[kFontSize floatValue]];
    }
    return _fontSize;
}

- (NSNumber *)fontSizeSmall {
    
    if (!_fontSizeSmall) {
        _fontSizeSmall = [NSNumber numberWithFloat:[kFontSizeSmall floatValue]];
    }
    return _fontSizeSmall;
}

- (NSNumber *)fontSizeLarge {
    
    if (!_fontSizeLarge) {
        _fontSizeLarge = [NSNumber numberWithFloat:[kFontSizeLarge floatValue]];
    }
    return _fontSizeLarge;
}

- (NSNumber *)tableViewCellHeightMin {
    
    if (!_tableViewCellHeightMin) {
        _tableViewCellHeightMin = [NSNumber numberWithFloat:[kTableViewCellHeightMin floatValue]];
    }
    return _tableViewCellHeightMin;
}

- (UIFont *)font {
    
    return [self fontWithSize:[self.fontSize floatValue]];
}

- (UIFont *)fontWithSize:(CGFloat)fontSize {
    
    return [self fontWithSize:fontSize bold:NO italic:NO];
}

- (UIFont *)fontWithSize:(CGFloat)fontSize bold:(BOOL)isBold italic:(BOOL)isItalic {
    
    return [UIFont ro_fontWithFamilyName:self.fontFamily size:fontSize bold:isBold italic:isItalic];
}

- (BOOL)useStyleLightForColor:(UIColor *)contrastingColor {
    
    BOOL useLight = NO;
    UIColor *color = [contrastingColor blackOrWhiteContrastingColor];
    CGFloat distance = [color distanceFromColor:[UIColor blackColor]];
    if (!isnan(distance)) {
        if (distance != 0.0f) {
            useLight = YES;
        }
    }
    return useLight;
}

- (UIColor *)selectedColor {

    return [self.accentColor colorWithAlphaComponent:0.1f];
}

@end
