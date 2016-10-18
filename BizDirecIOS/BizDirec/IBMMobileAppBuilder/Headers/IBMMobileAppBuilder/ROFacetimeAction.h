//
//  ROFacetimeAction.h
//  IBMMobileAppBuilder
//

#import "ROUriAction.h"
#import "ROAction.h"

/**
 Call by facetime
 */
@interface ROFacetimeAction : ROUriAction<ROAction>

/**
 Facetime identifier
 */
@property (nonatomic, strong) NSString *facetimeId;

/**
 Constructor with facetime identifier
 @param facetimeId Facetime identifier
 @return Class instance
 */
- (id)initWithValue:(NSString *)facetimeId;

@end
