//
//  RODatasourceParams.m
//  IBMMobileAppBuilder
//

#import "ROOptionsFilter.h"

@implementation ROOptionsFilter

- (NSMutableDictionary *)extra {
    
    if (!_extra) {
        _extra = [NSMutableDictionary new];
    }
    return _extra;
}

- (NSMutableArray *)filters {
    
    if(!_filters) {
        _filters = [NSMutableArray new];
    }
    return _filters;
}

- (NSMutableArray *)baseFilters {
    
    if(!_baseFilters) {
        _baseFilters = [NSMutableArray new];
    }
    return _baseFilters;
}

@end
