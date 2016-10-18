//
//  ROUriAction.m
//  IBMMobileAppBuilder
//

#import "ROUriAction.h"
#import "UIAlertView+RO.h"

@implementation ROUriAction

- (id)initWithUri:(NSString *)uri atIcon:(UIImage *)icon
{
    self = [super init];
    if (self) {
        _uri = uri;
        _icon = icon;
        _errorMessage = NSLocalizedString(@"Error on action", nil);
        _actionNotSupportedMessage = NSLocalizedString(@"Action not supported", nil);
    }
    return self;
}

- (void)doAction
{
    if ([self canDoAction] && self.uri) {
        NSURL *url = [NSURL URLWithString:self.uri];
        if (![[UIApplication sharedApplication] openURL:url]) {
            [UIAlertView ro_showWithErrorMessage:self.errorMessage];
        }
    } else {
        [UIAlertView ro_showWithInfoMessage:self.actionNotSupportedMessage];
    }
}

- (BOOL)canDoAction
{
    return self.uri && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.uri]];
}

- (UIImage *)actionIcon
{
    return self.icon;
}

@end
