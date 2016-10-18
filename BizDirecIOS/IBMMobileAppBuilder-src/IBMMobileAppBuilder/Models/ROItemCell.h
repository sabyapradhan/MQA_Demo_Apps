//
//  ROItemCell.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROAction.h"

/**
 Model for the cell.
 Displays the contents of the cell regardless of the type of object that is.
 */
@interface ROItemCell : NSObject

/**
 Item text1
 */
@property (nonatomic, strong) NSString *text1;

/**
 Item text2
 */
@property (nonatomic, strong) NSString *text2;

/**
 Image resource name
 */
@property (nonatomic, strong) NSString *imageResource;

/**
 Image resource url
 */
@property (nonatomic, strong) NSString *imageUrl;

/**
 Action to do
 */
@property (nonatomic, strong) NSObject<ROAction> *action;

/**
 Constructor with text1
 @param text1 Item text1
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1;

/**
 Constructor with text1
 @param text1 Item 
 @param aciton Action to do
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atAction:(NSObject<ROAction> *)action;

/**
 Constructor with text1 and text2
 @param text1 Item text1
 @param text2 Item text2
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2;

/**
 Constructor with text1, text2 and action
 @param text1 Item text1
 @param text2 Item text2
 @param action Action to do
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atAction:(NSObject<ROAction> *)action;

/**
 Constructor with text1 and image resource name
 @param text1 Item text1
 @param imageResource Image resource name
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atImageResource:(NSString *)imageResource;

/**
 Constructor with text1, image resource name and action
 @param text1 Item text1
 @param imageResource Image resource name
 @param action Action to do
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atImageResource:(NSString *)imageResource atAction:(NSObject<ROAction> *)action;

/**
 Constructor with image resource name
 @param imageResource Image resource name
 @return Class instance
 */
- (id)initWithImageResource:(NSString *)imageResource;

/**
 Constructor with image resource name and action
 @param imageResource Image resource name
 @param action Action to do
 @return Class instance
 */
- (id)initWithImageResource:(NSString *)imageResource atAction:(NSObject<ROAction> *)action;

/**
 Constructor with text1, text2 and image resource name
 @param text1 Item text1
 @param text2 Item text2
 @param imageResource Image resource name
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageResource:(NSString *)imageResource;

/**
 Constructor with text1, text2, image resource name and action
 @param text1 Item text1
 @param text2 Item text2
 @param imageResource Image resource name
 @param action Action to do
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageResource:(NSString *)imageResource atAction:(NSObject<ROAction> *)action;

/**
 Constructor with text1, text2 and image resource name
 @param text1 Item text1
 @param text2 Item text2
 @param imageUrl Image resource url
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageUrl:(NSString *)imageUrl;

/**
 Constructor with text1, text2, image resource name and action
 @param text1 Item text1
 @param text2 Item text2
 @param imageResource Image resource url
 @param action Action to do
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageUrl:(NSString *)imageUrl atAction:(NSObject<ROAction> *)action;

/**
 Constructor with text1, text2, image resource name and image resource url
 @param text1 Item text1
 @param text2 Item text2
 @param imageResource Image resource name
 @param imageResource Image resource url
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageResource:(NSString *)imageResource atImageUrl:(NSString *)imageUrl;

/**
 Constructor with image resource url and action
 @param imageResource Image resource url
 @param action Action to do
 @return Class instance
 */
- (id)initWithImageUrl:(NSString *)imageUrl atAction:(NSObject<ROAction> *)action;

/**
 Constructor with image resource url
 @param imageResource Image resource url
 @return Class instance
 */
- (id)initWithImageUrl:(NSString *)imageUrl;


/**
 Constructor with text1, text2, image resource name, image resource url and action
 @param text1 Item text 1
 @param text2 Item text 2
 @param imageResource Image resource name
 @param imageResource Image resource url
 @param action Action to do
 @return Class instance
 */
- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageResource:(NSString *)imageResource atImageUrl:(NSString *)imageUrl atAction:(NSObject<ROAction> *)action;

/**
 Check if item is empty
 @return YES if item is empty.
 */
- (BOOL)isEmpty;

@end
