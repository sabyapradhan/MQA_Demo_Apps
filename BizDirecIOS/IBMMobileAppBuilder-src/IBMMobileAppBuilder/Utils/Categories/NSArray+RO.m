//
//  NSArray+RO.m
//  IBMMobileAppBuilder
//

#import "NSArray+RO.h"

@implementation NSArray (RO)

- (NSArray *)ro_subarrayWithRange:(NSRange)range
{
    NSArray *subarray = [NSArray array];
    if (range.location < self.count) {
        NSRange rangeAux = NSMakeRange(range.location, MIN(self.count - range.location, range.length));
        subarray = [self subarrayWithRange:rangeAux];
    }
    return subarray;
}

- (NSArray *)ro_shuffled
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self count]];
    
    for (id anObject in self)
    {
        NSUInteger randomPos = arc4random()%([tmpArray count]+1);
        [tmpArray insertObject:anObject atIndex:randomPos];
    }
    
    return [NSArray arrayWithArray:tmpArray];
}

@end
