//
//  ROMailAction.m
//  IBMMobileAppBuilder
//

#import "ROMailAction.h"
#import "UIImage+RO.h"
#import "ROUtils.h"

@implementation ROMailAction

- (id)initWithRecipient:(NSString *)recipient atSubject:(NSString *)subject atBody:(NSString *)body {
    
    NSMutableString *actionUrl = [[NSMutableString alloc] initWithString:@"mailto:"];
    if (recipient) {
        [actionUrl appendFormat:@"%@?", [recipient stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if (subject) {
        [actionUrl appendFormat:@"subject=%@&", [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if (body) {
        [actionUrl appendFormat:@"body=%@", [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    self = [super initWithUri:actionUrl atIcon:[UIImage ro_imageNamed:@"email"]];
    if (self) {
        _recipient = recipient;
        _subject = subject;
        _body = body;
    }
    return self;
}

- (id)initWithValue:(NSString *)recipient {
    
    return [self initWithRecipient:recipient atSubject:nil atBody:nil];
}

- (void)doAction {

    [super doAction];
    
    [[[ROUtils sharedInstance] analytics] logAction:@"Send email"
                                             target:self.recipient];
}

@end
