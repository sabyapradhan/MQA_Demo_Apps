//
//  NSString+RO.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Helper to NSString
 */
@interface NSString (RO)

/**
 * return self
 */
- (NSString *)stringValue;

/**
 Compare with case insensitive
 @param aString String to compare
 @return Yes if it is true, otherwise NO
 */
- (BOOL)ro_isEqualToStringCI:(NSString *)aString;

/**
 Delete white spaces
 @return trim
 */
- (NSString *)ro_trim;

/**
 Check if string contains html tags
 @return YES if contains hmtl tags
 */
- (BOOL) ro_containsHtml;

/**
 Decoding html tags
 @return Strnig with html tags decoded
 */
- (NSString *)ro_decodingHtml;

/**
 Check if string contains line breaks
 @return YES if contains line breaks
 */
- (BOOL)ro_containsLineBreak;

/**
 Clean line break
 @return Clean string without line break
 */
- (NSString *)ro_cleanLineBreak;

/**
 Return string of object
 @param object Generic object
 @return Object string representation
 */
+ (NSString *)ro_stringByObject:(id)object;

/**
 Return rect fit by font
 @param font Font used
 @return Rect fit
 */
- (CGRect)ro_rectByFont:(UIFont *)font;

/**
 Return height fit by font
 @param font Font used
 @param width Max width
 @return Height fit
 */
- (CGFloat)ro_heightByFont:(UIFont *)font atWidth:(CGFloat)width;

/**
 Truncate tail
 @param limit Max characters to show
 @return Runcated string
 */
- (NSString *)ro_truncate:(NSUInteger)limit;

/**
 Clean html tags
 @return Clean string
 */
- (NSString *)ro_stringByStrippingHTML;

/**
 Clean html tags and transform br to \n
 @return Clean string
 */
- (NSString *)ro_cleanHtmlTags;

/**
 @return Url of the first img tag
 */
- (NSString *)ro_firstImgUrl;

/**
 Remove html elements by tag
 @param tag Tag to remove
 @return String without tag
 */
- (NSString *)ro_removeHtmlElementsByTag:(NSString *)tag;

/**
 Remove html elements by tag
 @param tag Tag to replace
 @return String without tag
 */
- (NSString *)ro_replaceHtmlElementsByTag:(NSString *)tag withString:(NSString *)string;

/**
 Remove html elements empty by tag
 @param tag Tag to remove
 @return String without tag
 */
- (NSString *)ro_removeHtmlElementsEmptyByTag:(NSString *)tag;

/**
 Check if string is an url
 @return YES if string is an url
 */
- (BOOL)isUrl;

- (NSString *)ro_md5;

@end
