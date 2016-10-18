//
//  Filter.h
//  IBMMobileAppBuilder
//

#ifndef IBMMobileAppBuilder_Filter_h
#define IBMMobileAppBuilder_Filter_h

@protocol ROFilter <NSObject>

// Returns the field this filter is associated to
- (NSString *)fieldName;

// Returns the field value
- (id)fieldValue;

// Returns the query string for querying remote datasources. IT CAN BE NULL
- (NSString *)getQueryString;

// Apply this filter to the provided value
- (BOOL)applyFilter:(NSObject *)fieldValue;

@end

#endif
