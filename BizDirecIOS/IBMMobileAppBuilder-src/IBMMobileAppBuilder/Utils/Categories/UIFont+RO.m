//
//  UIFont+RO.m
//  IBMMobileAppBuilder
//

#import "UIFont+RO.h"

@implementation UIFont (RO)

+ (UIFont *)ro_fontWithFamilyName:(NSString *)familyName size:(CGFloat)fontSize bold:(BOOL)isBold italic:(BOOL)isItalic
{
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:
                                         @{
                                           UIFontDescriptorFamilyAttribute : familyName,
                                           UIFontDescriptorFaceAttribute : (isBold && isItalic ? @"Bold Italic" : (isBold ? @"Bold" : (isItalic ? @"Italic" : @"Regular")))
                                           }];
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
    
    if (font == nil) {
        
        UIFontDescriptorSymbolicTraits traits = 0;
        if (isBold)   traits |= UIFontDescriptorTraitBold;
        if (isItalic) traits |= UIFontDescriptorTraitItalic;
        
        UIFontDescriptor *fontDescriptorDefault = [[UIFont systemFontOfSize:fontSize].fontDescriptor fontDescriptorWithSymbolicTraits:traits];
        
        font = [UIFont fontWithDescriptor:fontDescriptorDefault size:0.0];
    }
    
    return font;
}

@end
