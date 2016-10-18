//
//  ROTextStyle.m
//  IBMMobileAppBuilder
//

#import "ROTextStyle.h"
#import "ROStyle.h"
#import "Colours.h"

@implementation ROTextStyle

- (instancetype)initWithFontSizeStyle:(ROFontSizeStyle)fontSizeStyle bold:(BOOL)isBold italic:(BOOL)isItalic textAligment:(NSTextAlignment)textAligment textColor:(id)textColor
{
    self = [super init];
    if (self) {
        self.fontSizeStyle = fontSizeStyle;
        self.bold = isBold;
        self.italic = isItalic;
        self.textAligment = textAligment;
        self.textColor = textColor ? : [[ROStyle sharedInstance] foregroundColor];
    }
    return self;
}

+ (instancetype)style:(ROFontSizeStyle)fontSizeStyle bold:(BOOL)isBold italic:(BOOL)isItalic textAligment:(NSTextAlignment)textAligment textColor:(id)textColor
{
    return [[self alloc] initWithFontSizeStyle:fontSizeStyle bold:isBold italic:isItalic textAligment:textAligment textColor:textColor];
}

- (instancetype)initWithFontSizeStyle:(ROFontSizeStyle)fontSizeStyle bold:(BOOL)isBold italic:(BOOL)isItalic textAligment:(NSTextAlignment)textAligment
{
    return [self initWithFontSizeStyle:fontSizeStyle bold:isBold italic:isItalic textAligment:textAligment textColor:nil];
}

+ (instancetype)style:(ROFontSizeStyle)fontSizeStyle bold:(BOOL)isBold italic:(BOOL)isItalic textAligment:(NSTextAlignment)textAligment
{
    return [[self alloc] initWithFontSizeStyle:fontSizeStyle bold:isBold italic:isItalic textAligment:textAligment];
}

- (UIFont *)font
{
    NSNumber *fontSize = nil;
    switch (self.fontSizeStyle) {
        case ROFontSizeStyleSmall:
            fontSize = [[ROStyle sharedInstance] fontSizeSmall];
            break;
        case ROFontSizeStyleLarge:
            fontSize = [[ROStyle sharedInstance] fontSizeLarge];
            break;
        default:
            fontSize = [[ROStyle sharedInstance] fontSize];
            break;
    }
    UIFont *font = [[ROStyle sharedInstance] fontWithSize:[fontSize floatValue]
                                                     bold:self.bold
                                                   italic:self.italic];
    
    return font;
}

- (void)setTextColor:(id)textColor
{
    if ([textColor isKindOfClass:[UIColor class]]) {
        _textColor = (UIColor *)textColor;
    } else if ([textColor isKindOfClass:[NSString class]]) {
        _textColor = [UIColor colorFromHexString:textColor];
    }
}

@end
