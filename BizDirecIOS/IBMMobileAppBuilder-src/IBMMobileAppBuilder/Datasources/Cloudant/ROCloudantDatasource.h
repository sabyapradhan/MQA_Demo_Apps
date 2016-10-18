//
//  ROCloudantDatasource.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "RODataDelegate.h"
#import "ROPagination.h"
#import "ROSynchronize.h"

@protocol ROSearchable;

@class ROCloudantManager;

@interface ROCloudantDatasource : NSObject <RODatasource, ROPagination, ROSynchronize>

@property (nonatomic, strong) ROCloudantManager *cloudantManager;

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, assign) Class objectsClass;

@property (nonatomic, strong) NSString *datastoreName;

@property (nonatomic, weak) id<ROSearchable> delegate;

- (instancetype)initWithUrlString:(NSString *)urlString datastoreName:(NSString *)datastoreName objectsClass:(__unsafe_unretained Class)objectsClass;

+ (instancetype)datasourceWithUrlString:(NSString *)urlString datastoreName:(NSString *)datastoreName objectsClass:(__unsafe_unretained Class)objectsClass;

@end
