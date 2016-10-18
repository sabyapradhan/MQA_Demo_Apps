//
//  RORestClient.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

@class ROError;

@interface RORestClient : NSObject

typedef void (^SuccessBlock)(id response);

typedef void (^FailureBlock)(ROError *error);

typedef void (^CompleteBlock)(BOOL success);

typedef void (^ProgressBlock)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations);

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) NSString *baseUrlString;

@property (nonatomic, assign) NSTimeInterval timeout;

@property (nonatomic, strong) NSMutableDictionary *headerFields;

- (instancetype)initWithBaseUrlString:(NSString *)baseUrlString timeout:(NSTimeInterval)timeout;

#pragma mark - Request from manager

- (NSOperation *)operationService:(NSString *)service method:(NSString *)method params:(NSDictionary *)params bodyParams:(NSDictionary *)bodyParams responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

- (void)service:(NSString *)service method:(NSString *)method params:(NSDictionary *)params bodyParams:(NSDictionary *)bodyParams responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - Manager

- (NSOperation *)get:(NSString *)service params:(NSDictionary *)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

- (NSOperation *)post:(NSString *)service params:(id)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

- (NSOperation *)put:(NSString *)service params:(id)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

- (NSOperation *)delete:(NSString *)service params:(NSDictionary *)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - Batch

- (void)batchOfRequestOperations:(NSArray *)operations progress:(ProgressBlock)progressBlock complete:(CompleteBlock)completeBlock waitUntilFinished:(BOOL)wait;

#pragma mark - Upload

- (void)post:(NSString *)service params:(NSDictionary *)params data:(NSData *)data name:(NSString *)name mimeType:(NSString *)mimeType responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

- (void)post:(NSString *)service params:(NSDictionary *)params datas:(NSDictionary *)datas mimeType:(NSString *)mimeType responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

- (void)put:(NSString *)service params:(NSDictionary *)params datas:(NSDictionary *)datas mimeType:(NSString *)mimeType responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - Helpers

- (NSMutableURLRequest *)request:(NSString *)method service:(NSString *)service params:(NSDictionary *)params bodyParams:(NSDictionary *)bodyParams failureBlock:(FailureBlock)failureBlock;

- (void)processSuccess:(NSOperation *)operation responseObject:(id)responseObject responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock;

- (void)processFailure:(NSOperation *)operation error:(NSError *)error failureBlock:(FailureBlock)failureBlock;

@end
