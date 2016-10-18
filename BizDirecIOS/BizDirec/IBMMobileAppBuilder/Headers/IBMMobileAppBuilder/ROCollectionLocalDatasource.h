//
//  ROCollectionLocalDatasource.h
//  IBMMobileAppBuilder
//

#import "ROObject.h"
#import "RODatasource.h"
#import "ROPagination.h"

@interface ROCollectionLocalDatasource : ROObject<RODatasource,ROPagination>

@property (nonatomic, assign) Class objectsClass;
@property (nonatomic, strong) NSArray *objects;

- (id)initWithObjectsClass:(Class)objectsClass;

@end
