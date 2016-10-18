//
//  RODatasourceParams.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

/**
 Options filter to datasource
 */
@interface ROOptionsFilter : NSObject

/**
 Search text
 */
@property (nonatomic, strong) NSString *searchText;

/**
 Sort column
 */
@property (nonatomic, strong) NSString *sortColumn;

/**
 Sort ascending
 */
@property (nonatomic, assign) BOOL sortAscending;

/**
 Page size
 */
@property (nonatomic, strong) NSNumber *pageSize;

/**
 Extra options
 */
@property (nonatomic, strong) NSMutableDictionary *extra;

/**
 Filters
 */
@property (nonatomic, strong) NSMutableArray *filters;

/**
 Filters fixes
 */
@property (nonatomic, strong) NSMutableArray *baseFilters;

@end
