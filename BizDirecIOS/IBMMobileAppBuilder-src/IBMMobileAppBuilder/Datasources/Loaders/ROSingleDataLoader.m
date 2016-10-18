//
//  ROSingleDataLoader.m
//  IBMMobileAppBuilder
//

#import "ROSingleDataLoader.h"

@implementation ROSingleDataLoader

- (void)refreshDataSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock
{
    [super refreshDataSuccessBlock:^(NSArray *items) {
        
        if (successBlock) {
            NSObject *dataItem = nil;
            if (items && [items count] != 0) {
                dataItem = items[0];
            }
            successBlock(dataItem);
        }
        
    } failureBlock:failureBlock];
}

- (void)loadDataSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock
{
    [self refreshDataSuccessBlock:successBlock failureBlock:failureBlock];
}

@end
