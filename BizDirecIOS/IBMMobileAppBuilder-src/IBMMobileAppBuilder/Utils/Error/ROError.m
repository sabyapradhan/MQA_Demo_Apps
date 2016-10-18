//
//  ROError.m
//  IBMMobileAppBuilder
//

#import "ROError.h"

@implementation ROError

- (instancetype)initWithFn:(const char *)fn error:(NSError *)error operation:(NSOperation *)operation
{
    self = [super init];
    if (self) {
        _fn = [NSString stringWithUTF8String:fn];
        _error = error;
        _operation = operation;
    }
    return self;
}

- (instancetype)initWithFn:(const char *)fn error:(NSError *)error
{
    return [self initWithFn:fn error:error operation:nil];
}

+ (instancetype)errorWithFn:(const char *)fn error:(NSError *)error operation:(NSOperation *)operation
{
    return [[self alloc] initWithFn:fn error:error operation:operation];
}

+ (instancetype)errorWithFn:(const char *)fn error:(NSError *)error
{
    return [[self alloc] initWithFn:fn error:error];
}

- (NSString *)description
{
    NSMutableString *errorString = [NSMutableString new];
    if (_fn) {
        [errorString appendFormat:@"\n%@\n", _fn];
    }
    if (_title) {
        [errorString appendFormat:@"Title:\n%@", _title];
    }
    if (_message) {
        [errorString appendFormat:@"Message:\n%@", _message];
    }
    if (_body) {
        [errorString appendFormat:@"Body:\n%@", _body];
    }
    if (_operation) {
        [errorString appendFormat:@"Operation:\n%@", _operation];
    }
    if (_error) {
        if ([_error localizedDescription]) {
            [errorString appendFormat:@"Error:\n%@\n", [_error localizedDescription]];
        }
    }
    return errorString;
}

- (void)log
{
    NSLog(@"%@", [self description]);
}

- (NSString *)stringValue
{
    if (self.error && self.error.localizedDescription) {
        return self.error.localizedDescription;
    }
    return @"";
}

- (void)show
{
    dispatch_async (dispatch_get_main_queue(), ^{
        
        NSString *msg = self.message;
        if (msg == nil && _error && [_error localizedDescription]) {
            msg = [_error localizedDescription];
        }
        NSString *title = self.title;
        if (title == nil) {
            title = NSLocalizedString(@"Error", nil);
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                       message:msg
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                             otherButtonTitles:nil];
        
        [alert show];
        
    });
}

@end
