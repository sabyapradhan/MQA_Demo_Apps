//
//  NSString+RO.m
//  IBMMobileAppBuilder
//

#import "NSString+RO.h"
#import "NSDate+RO.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (RO)

- (NSString *)stringValue{
    return self;
}

- (BOOL)ro_isEqualToStringCI:(NSString *)aString
{
    return ([self caseInsensitiveCompare:aString] == NSOrderedSame);
}

- (NSString *)ro_trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)ro_containsHtml {
    NSString *t1 = [[self ro_cleanLineBreak] ro_stringByStrippingHTML];
    return ([[self ro_cleanLineBreak] length] != [t1 length]);
}

- (NSString *)ro_decodingHtml {
    NSString *text = [[self ro_removeHtmlElementsByTag:@"iframe"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    text = [text ro_removeHtmlElementsByTag:@"video"];
    return [[text ro_stringByStrippingHTML] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"];
}

- (NSString *)ro_removeHtmlElementsByTag:(NSString *)tag
{
    NSRange r;
    NSString *s = self;
    while ((r = [s rangeOfString:[NSString stringWithFormat:@"<%@[^>]+>", tag] options:NSRegularExpressionSearch]).location != NSNotFound) {
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    }
    while ((r = [s rangeOfString:[NSString stringWithFormat:@"<[^>]+%@>", tag] options:NSRegularExpressionSearch]).location != NSNotFound) {
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    }
    s = [s ro_removeHtmlElementsEmptyByTag:@"p"];
    s = [s ro_removeHtmlElementsEmptyByTag:@"div"];
    return s;
}

- (NSString *)ro_replaceHtmlElementsByTag:(NSString *)tag withString:(NSString *)string
{
    NSRange r;
    NSString *s = self;
    while ((r = [s rangeOfString:[NSString stringWithFormat:@"<%@[^>]+>", tag] options:NSRegularExpressionSearch]).location != NSNotFound) {
        s = [s stringByReplacingCharactersInRange:r withString:string];
    }
    return s;
}

- (NSString *)ro_removeHtmlElementsEmptyByTag:(NSString *)tag
{
    return [self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@></%@>", tag, tag] withString:@""];
}

- (BOOL)ro_containsLineBreak
{
    NSString *lineBreak = @"\n";
    NSString *text = [self stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    NSRange searchResult = [text rangeOfString:lineBreak];
    return (searchResult.location != NSNotFound);
}

- (NSString *)ro_cleanLineBreak
{
    return [[[self ro_trim] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

+ (NSString *)ro_stringByObject:(id)object
{
    NSString *string = [NSString new];
    if (object) {
        if ([object isKindOfClass:[NSString class]]) {
            string = object;
        } else if ([object isKindOfClass:[NSNumber class]]) {
            NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            string = [numberFormatter stringFromNumber:object];
        } else if ([object isKindOfClass:[NSDate class]]) {
            NSDate *date = (NSDate *)object;
            string = [date stringValue];
        } else {
            [string description];
        }
    }
    return string;
}

- (CGRect)ro_rectByFont:(UIFont *)font
{
    if (font) {
        NSDictionary *attributes = @{NSFontAttributeName: font};
        return [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attributes
                                  context:nil];
    }
    return CGRectZero;
}

- (CGFloat)ro_heightByFont:(UIFont *)font atWidth:(CGFloat)width
{
    if (font) {
        NSDictionary *attributes = @{NSFontAttributeName: font};
        return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attributes
                                  context:nil].size.height;
    }
    return 0.0f;
}

- (NSString *)ro_truncate:(NSUInteger)limit
{
    NSString *value = self;
    if ([value length] > limit && [value length] > 6) {
        value = [[value substringToIndex:limit-3] stringByAppendingString:@"..."];
    }
    return value;
}

- (NSString *)ro_stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSString *)ro_cleanHtmlTags
{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData: [self dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:@{
                                                                                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                           documentAttributes:nil
                                                                        error:nil];
    return [attrString string];
}

- (NSString *)ro_firstImgUrl
{
    NSString *url = @"";
    NSScanner *theScanner = [NSScanner scannerWithString:self];
    // find start of IMG tag
    [theScanner scanUpToString:@"<img" intoString:nil];
    if (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"src" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&url];
    }
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)isUrl
{
    if (!self)
    {
        return NO;
    }
    
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    
    NSRange urlStringRange = NSMakeRange(0, [self length]);
    NSMatchingOptions matchingOptions = 0;
    
    if (1 != [linkDetector numberOfMatchesInString:self
                                           options:matchingOptions
                                             range:urlStringRange]) {
        return NO;
    }
    
    NSTextCheckingResult *checkingResult = [linkDetector firstMatchInString:self
                                                                    options:matchingOptions
                                                                      range:urlStringRange];
    
    return checkingResult.resultType == NSTextCheckingTypeLink && NSEqualRanges(checkingResult.range, urlStringRange);
}

- (NSString *)ro_md5
{
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
