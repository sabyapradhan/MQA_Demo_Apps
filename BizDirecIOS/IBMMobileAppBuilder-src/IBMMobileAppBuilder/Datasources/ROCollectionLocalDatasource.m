//
//  ROCollectionLocalDatasource.m
//  IBMMobileAppBuilder
//

#import "ROCollectionLocalDatasource.h"
#import <DCKeyValueObjectMapping/DCKeyValueObjectMapping.h>
#import <DCKeyValueObjectMapping/DCParserConfiguration.h>
#import "NSArray+RO.h"
#import "ROOptionsFilter.h"
#import "ROFilter.h"
#import "ROModel.h"

static NSInteger const kLocalDataPageSize        = 20;
static NSString *const kLocalDataParamPageStart  = @"offset";
static NSString *const kLocalDataParamPageSize   = @"blockSize";

@interface ROCollectionLocalDatasource ()

- (id)objectWithDictionary:(NSDictionary *)dic;

- (NSArray *)objects:(NSArray *)objects filters:(NSArray *)filters;

@end

@implementation ROCollectionLocalDatasource

- (id)initWithObjectsClass:(Class)objectsClass
{
    self = [super initWithDefaultResource];
    if (self) {
        _objectsClass = objectsClass;
    }
    return self;
}

- (NSString *)imagePath:(NSString *)path {
    return path;
}

- (void)loadOnSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    [self loadWithOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadWithOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    if (successBlock) {
        NSArray *results = [NSArray arrayWithArray:self.objects];
        if (results && [results count] != 0) {
            if (optionsFilter) {
                
                // design filters
                results = [self objects:results filters:optionsFilter.baseFilters];
                
                // runtime filters
                results = [self objects:results filters:optionsFilter.filters];
                
                // second: search text
                if (optionsFilter.searchText) {
                    NSArray *keys = [[results objectAtIndex:0] allKeys];
                    NSMutableArray *subpredicates = [NSMutableArray array];
                    for (NSString *key in keys) {
                        NSString *keyString = [key stringByAppendingString:@".description"];
                        NSPredicate *subpredicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", keyString, optionsFilter.searchText];
                        [subpredicates addObject:subpredicate];
                    }
                    NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
                    results = [results filteredArrayUsingPredicate:filter];
                }
                
                // third: sorting
                if (optionsFilter.sortColumn) {
                    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:optionsFilter.sortColumn ascending:optionsFilter.sortAscending];
                    results = [results sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
                }
                
                // extra options
                if (optionsFilter.extra) {
                    if ([optionsFilter.extra objectForKey:kLocalDataParamPageStart] && [optionsFilter.extra objectForKey:kLocalDataParamPageSize]) {
                        NSInteger offset = [[optionsFilter.extra objectForKey:kLocalDataParamPageStart] integerValue];
                        NSInteger blockSize = [[optionsFilter.extra objectForKey:kLocalDataParamPageSize] integerValue];
                        NSRange range = NSMakeRange(offset * blockSize, blockSize);
                        results = [results ro_subarrayWithRange:range];
                    }
                }
            }
        }
        NSMutableArray *objectsTmp = [[NSMutableArray alloc] initWithCapacity:[results count]];
        for (NSInteger i=0; i!= [results count]; i++) {
            if ([[results objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *objDic = (NSDictionary *)[results objectAtIndex:i];
                [objectsTmp addObject:[self objectWithDictionary:objDic]];
            } else if ([[results objectAtIndex:i] isKindOfClass:_objectsClass]) {
                [objectsTmp addObject:[results objectAtIndex:i]];
            }
        }
        successBlock([objectsTmp copy]);
    }
}

- (id)objectWithDictionary:(NSDictionary *)dic
{
    NSObject<ROModelDelegate> *obj = nil;
    
    if (self.objectsClass) {
        
        id object = [[self.objectsClass alloc] init];
        
        if ([object conformsToProtocol:@protocol(ROModelDelegate)]) {
            
            obj = object;
            [obj updateWithDictionary:dic];
            
        } else if ([self.objectsClass respondsToSelector:@selector(objectWithAttributes:)]) {
            
            obj = [self.objectsClass objectWithAttributes:dic];
            
        } else {
            
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            config.datePattern = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:self.objectsClass andConfiguration:config];
            obj = [parser parseDictionary:dic];
        }
        
    }
    
    return obj;
}

- (void)distinctValues:(NSString *)columnName filters:(NSArray *)filters onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock{
    
    NSArray *results = [self objects:self.objects filters:filters];
    
    NSMutableArray *res = [NSMutableArray new];
    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = [obj objectForKey:columnName];
        if(value && ![res containsObject:value]){
            [res addObject:value];
        }
    }];
    
    successBlock(res);
}

- (NSArray *)objects:(NSArray *)objects filters:(NSArray *)filters {

    NSArray *results;
    if(filters && [filters count] != 0){
        NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            for (NSObject<ROFilter> *f in filters) {
                NSString *filteredField = [f fieldName];
                id o = [evaluatedObject objectForKey:filteredField];
                if (o != nil) {
                    if(![f applyFilter:o])
                        return NO;
                }
            }
            return YES;  // all filters have passed, or there are no filters at all
        }];
        results = [objects filteredArrayUsingPredicate:filterPredicate];
    
    } else {
        
        results = [NSArray arrayWithArray:objects];
    }
    
    return results;
}

#pragma mark - ROPagination

- (NSInteger)pageSize
{
    return kLocalDataPageSize;
}

- (void)loadPageNum:(NSInteger)pageNum onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    [self loadPageNum:pageNum withOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadPageNum:(NSInteger)pageNum withOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    if (!optionsFilter) {
        optionsFilter = [ROOptionsFilter new];
    }
    NSInteger size = optionsFilter.pageSize ? [optionsFilter.pageSize integerValue] : [self pageSize];
    [optionsFilter.extra setObject:[@(pageNum) stringValue] forKey:kLocalDataParamPageStart];
    [optionsFilter.extra setObject:[@(size) stringValue] forKey:kLocalDataParamPageSize];
    [self loadWithOptionsFilter:optionsFilter onSuccess:successBlock onFailure:failureBlock];
}


@end
