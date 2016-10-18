//
//  ROYoutubeAction.h
//  IBMMobileAppBuilder
//

#import "ROUriAction.h"
#import "ROAction.h"

/**
 Open video in youtube app
 */
@interface ROYoutubeAction : ROUriAction<ROAction>

/**
 Video identifier
 */
@property (nonatomic, strong) NSString *videoId;

/**
 Url video
 */
@property (nonatomic, strong) NSString *videoUrl;

/**
 Constructor with video identifier
 @param videoID Video identifier
 @return Class instance
 */
- (id)initWithVideoId:(NSString *)videoId;

/**
 Constructor with video url
 @param videoUrl Video url
 @return Class instance
 */
- (id)initWithValue:(NSString *)videoUrl;

@end
