//  Copyright 2014 Applause. All rights reserved.

#import "APLLogging.h"
#import "MQASettings.h"


typedef enum
{
    MQALogLevelFatal = 16,
    MQALogLevelError = 8,
    MQALogLevelWarning = 4,
    MQALogLevelInfo = 2,
    MQALogLevelVerbose = 0
} MQALogLevel;

/**
* Convinience method to log applications exceptions
*/

void MQAUncaughtExceptionHandler(NSException * _Nullable exception);

/** MQA enabled macro **/
#define MQAEnabled 1

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-zero-variadic-macro-arguments"

/** Logging macros **/

/*
 * Replace all occurences of NSLog with MQALog.
 * Except for working like normal log it will also send message to MQA server.
 */
#define MQALog(nsstring_format, ...)    \
do {                        \
[MQALogger logWithLevel:MQALogLevelInfo \
tag:nil \
line:__LINE__ fileName:[NSString stringWithUTF8String:__FILE__] \
method:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
stacktrace:[NSThread callStackReturnAddresses]\
format:nsstring_format, \
##__VA_ARGS__];\
} while(0)

/*
 * Works as the one above, except it provides additional configuration options
 */
#define MQAExtendedLog(MQALogLevel, nsstring_tag, nsstring_format, ...)    \
do {                        \
[MQALogger logWithLevel:(MQALogLevel) \
tag:(nsstring_tag) \
line:__LINE__ fileName:[NSString stringWithUTF8String:__FILE__] \
method:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
stacktrace:[NSThread callStackReturnAddresses] \
format:nsstring_format, \
##__VA_ARGS__];\
} while(0)


#pragma clang diagnostic pop

/**
* Main Quality 4 Mobile API class
*/
@interface MQALogger : NSObject <APLLogging>

/**
* Default settings:
* - applicationVersionName is equal to CFBundleShortVersionString
* - applicationVersionCode is equal to CFBundleVersion
* - reportOnShakeEnabled is equal to YES
* @return MQASettings object with default values. You can easily change MQA behaviour by simply changing it's properties.
*/
+ (nonnull MQASettings *)settings;

/**
* Calling theese methods is strongly discouraged, since given macros and functions are more convenient way of using Applause.
*/
+ (void)logWithLevel:(MQALogLevel)level tag:(nullable NSString *)tag line:(NSInteger)line fileName:(nullable NSString *)fileName method:(nullable NSString *)method stacktrace:(nullable NSArray *)stacktrace format:(nonnull NSString *)format, ...;
+ (void)logWithLevel:(MQALogLevel)level tag:(nullable NSString *)tag line:(NSInteger)line fileName:(nullable NSString *)fileName method:(nullable NSString *)method stacktrace:(nullable NSArray *)stacktrace writeToConsole:(BOOL)writeToConsole format:(nonnull NSString *)format, ...;
+ (void)logWithLevel:(MQALogLevel)level tag:(nullable NSString *)tag line:(NSInteger)line fileName:(nullable NSString *)fileName method:(nullable NSString *)method stacktrace:(nullable NSArray *)stacktrace writeToConsole:(BOOL)writeToConsole formatedString:(nonnull NSString *)formatedString;

@end

/**
* Macros are not accessible from Swift; the following category is replacement for MQALog and MQAExtendedLog macros.
*/
@interface MQALogger (APLSwiftLoggingSupport)
+ (void)log:(nonnull NSString *)message DEPRECATED_MSG_ATTRIBUTE("Use Swift 'Logger' class instead of this Objective-C method."); //default info log
+ (void)log:(nonnull NSString *)message withLevel:(MQALogLevel)logLevel DEPRECATED_MSG_ATTRIBUTE("Use Swift 'Logger' class instead of this Objective-C method.");
@end

/**
 * Contextual feedback methods
 */

extern NSString * _Nonnull const MQAShowContextualFeedbackNotification;

@interface MQALogger (APLContextualFeedback)

/**
 * This function manually shows feedback screen related to perticular section of the app or an action.
 * @param tags array of tags describing the context of the app the feedback is related to
 */
+ (void)showContextualFeedbackWithTags:(nullable NSArray *)tags;

/**
 * This function manually shows feedback screen related to perticular section of the app or an action.
 * @param feedbackTitle Custom title of presented view controller
 * @param ratingTitle Custom title of rating section of presented view
 * @param feedbackPlaceholder Custom placeholder of the feedback text input
 * @param tags array of tags describing the context of the app the feedback is related to
 */
+ (void)showContextualFeedbackWithTitle:(nullable NSString *)feedbackTitle
                            ratingTitle:(nullable NSString *)ratingTitle
                    feedbackPlaceholder:(nullable NSString *)feedbackPlaceholder
                                   tags:(nullable NSArray *)tags;

@end

/**
* Production feedback methods
*/

@interface MQALogger (APLProductionFeedback)
/**
* ONLY FOR PRODUCTION
* Function to show feedback modal where user can write and send feedback about application.
* You can theme this using Appearance protocol (above iOS 5.0).
* @param title Title of modal header
* @param placeholder Placeholder of text field
*/
+ (void)feedback:(nullable NSString *)title placeholder:(nullable NSString *)placeholder;

/**
* ONLY FOR PRODUCTION
*/
+ (void)feedback:(nullable NSString *)title;

/**
* ONLY FOR PRODUCTION
* Default title is "Feedback".
*/
+ (void)feedback;

/**
* ONLY FOR PRODUCTION
* Function which sends feedback to Applause. It is used by feedback modal.
* @param feedback Text which you want send to Applause.
*/
+ (void)sendFeedback:(nonnull NSString *)feedback;

@end
