//  Copyright 2014 Applause. All rights reserved.

#import "APLSetting.h"


typedef NS_ENUM(NSInteger, MQAMode)
{
    MQAModeQA,
    MQAModeSilent DEPRECATED_MSG_ATTRIBUTE("Silent Mode is equal to Market Mode"),
    MQAModeMarket
};

/**
* Anonymous login name - you can set it as defaultUser parameter.
*/
FOUNDATION_EXPORT NSString *const MQAAnonymousUser;

@interface MQASettings : NSObject <APLSetting>

/**
 * Choose the working mode between QA (pre-production) and Market (production). QA mode is enabled by default.
 */
@property(nonatomic) MQAMode mode;

/**
 * Enable this flag to alter framework screen capturing method. When set to True, framework will use system screenshots (stored in the device's gallery)
 * In order to report bugs in such a mode, system screenshot needs to be created first.
 * It is disabled by default.
 */
@property(nonatomic) BOOL screenShotsFromGallery DEPRECATED_MSG_ATTRIBUTE("\"screenShotsFromGallery\" flag was deprecated and changing it does not make any change in the SDK.");

@end
