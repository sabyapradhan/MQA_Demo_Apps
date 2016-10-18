//
//  ROSynchronize.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@protocol ROSynchronize <NSObject>

- (void)sync;

- (BOOL)synchronized;

- (void)setSynchronized:(BOOL)synchronized;

@end
