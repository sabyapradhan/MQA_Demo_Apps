//
//  ROItemsDatasource.m
//  IBMMobileAppBuilder
//

#import "ROListDataLoader.h"
#import "ROPagination.h"
#import "ROOptionsFilter.h"
#import "ROError.h"

@interface ROListDataLoader ()

@property (nonatomic, weak) id<ROPagination> dsPag;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) NSArray *items;

- (void)loadSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock;

- (ROError *)errorInFunction:(const char *)fn error:(NSError *)error response:(NSHTTPURLResponse *)response;

@end

@implementation ROListDataLoader

- (instancetype)initWithDatasource:(NSObject<RODatasource> *)datasource optionsFilter:(ROOptionsFilter *)optionsFilter
{
    self = [super init];
    if (self) {
        _datasource = datasource;
        _optionsFilter = optionsFilter;
    }
    return self;
}

- (void)dealloc
{
    if (_items) {
        _items = nil;
    }
    if (_optionsFilter) {
        _optionsFilter = nil;
    }
}

- (NSArray *)items
{
    if (!_items) {
        _items = [NSArray new];
    }
    return _items;
}

- (ROOptionsFilter *)optionsFilter {
    if (!_optionsFilter) {
        _optionsFilter = [ROOptionsFilter new];
    }
    return _optionsFilter;
}

- (id<ROPagination>)dsPag
{
    if (!_dsPag) {
        if (_datasource && [_datasource conformsToProtocol:@protocol(ROPagination)]) {
            _dsPag = (id<ROPagination>)_datasource;
        }
    }
    return _dsPag;
}

- (void)refreshDataSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock
{
    __weak typeof(self) weakSelf = self;
    if (weakSelf.dsPag) {
        
        _pageNum = 0;
        [weakSelf.dsPag loadPageNum:_pageNum withOptionsFilter:self.optionsFilter onSuccess:^(NSArray *objects) {
            
            weakSelf.items = objects;
            _pageNum++;
            if (successBlock) {
                successBlock(weakSelf.items);
            }
            
        } onFailure:^(NSError *error, NSHTTPURLResponse *response) {
            
            if (failureBlock) {
                ROError *roError = [self errorInFunction:__PRETTY_FUNCTION__
                                                   error:error
                                                response:response];
                failureBlock(roError);
            }
            
        }];
        
    } else if (weakSelf.datasource) {
        
        [weakSelf loadSuccessBlock:successBlock failureBlock:failureBlock];;
        
    }
}

- (void)loadDataSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock
{
    __weak typeof(self) weakSelf = self;
    if (weakSelf.dsPag) {
        
        [weakSelf.dsPag loadPageNum:_pageNum withOptionsFilter:self.optionsFilter onSuccess:^(NSArray *objects) {
            
            if (objects && [objects count] != 0) {
                NSArray *newItems = [weakSelf.items arrayByAddingObjectsFromArray:objects];
                weakSelf.items = newItems;
                _pageNum++;
            }
            if (successBlock) {
                successBlock(weakSelf.items);
            }
            
        } onFailure:^(NSError *error, NSHTTPURLResponse *response) {
            
            if (failureBlock) {
                ROError *roError = [self errorInFunction:__PRETTY_FUNCTION__
                                                   error:error
                                                response:response];
                failureBlock(roError);
            }
            
        }];
        
    } else if (weakSelf.datasource) {
        
        [weakSelf loadSuccessBlock:successBlock failureBlock:failureBlock];
    }
}

- (void)loadSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock
{
    __weak typeof(self) weakSelf = self;
    [weakSelf.datasource loadWithOptionsFilter:self.optionsFilter onSuccess:^(NSArray *objects) {
        
        weakSelf.items = objects;
        if (successBlock) {
            successBlock(weakSelf.items);
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response) {
        
        if (failureBlock) {
            ROError *roError = [self errorInFunction:__PRETTY_FUNCTION__
                                               error:error
                                            response:response];
            failureBlock(roError);
        }
        
    }];
}

- (ROError *)errorInFunction:(const char *)fn error:(NSError *)error response:(NSHTTPURLResponse *)response
{
    ROError *roError = [[ROError alloc] initWithFn:fn error:error];
    NSString *msg = NSLocalizedString(@"There was a problem retrieving data", nil);
    if (response && response.statusCode == 401) {
        msg = NSLocalizedString(@"Authorization required", nil);
    }
    roError.message = msg;
    return roError;
}

@end
