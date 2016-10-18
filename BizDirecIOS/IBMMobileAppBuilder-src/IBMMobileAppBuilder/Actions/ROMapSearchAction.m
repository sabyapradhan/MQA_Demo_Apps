//
//  ROMapSearchAction.m
//  IBMMobileAppBuilder
//

#import "ROMapSearchAction.h"
#import "ROUtils.h"

@implementation ROMapSearchAction

- (id)initWithValue:(NSString *)location {
    
    NSMutableString *uri = [[NSMutableString alloc] initWithString:@"q="];
    if (location) {
        [uri appendString:location];
    }
    self = [super initWithValue:uri];
    if (self) {
        _location = location;
    }
    return self;
}

- (void)doAction {
    
    [super doAction];
    
    [[[ROUtils sharedInstance] analytics] logAction:@"Find on map"
                                             target:self.location];
}

@end
