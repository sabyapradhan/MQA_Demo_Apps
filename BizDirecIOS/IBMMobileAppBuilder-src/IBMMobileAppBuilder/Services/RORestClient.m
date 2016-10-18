//
//  BRestClient.m
//  IBMMobileAppBuilder
//

#import "RORestClient.h"
#import "ROError.h"
#import "NSDictionary+RO.h"
#import "ROModel.h"
#import <AFNetworking/AFURLConnectionOperation.h>
#import <DCKeyValueObjectMapping/DCKeyValueObjectMapping.h>
#import <DCKeyValueObjectMapping/DCParserConfiguration.h>
#import "ROUtils.h"

@interface RORestClient ()

- (NSDictionary *)cleanParams:(NSDictionary *)params;

- (id)objectWithDictionary:(NSDictionary *)dic objectClass:(__unsafe_unretained Class)objectClass;

@end

@implementation RORestClient

- (instancetype)initWithBaseUrlString:(NSString *)baseUrlString timeout:(NSTimeInterval)timeout
{
    self = [super init];
    if (self) {
        _baseUrlString = baseUrlString;
        _timeout = timeout;
    }
    return self;
}

- (NSMutableDictionary *)headerFields
{
    if (!_headerFields) {
        _headerFields = [NSMutableDictionary new];
    }
    return _headerFields;
}

- (NSDictionary *)cleanParams:(NSDictionary *)params
{
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:params];
    for (NSString *key in params) {
        if ([params[key] isKindOfClass:[NSNull class]]) {
            [body removeObjectForKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:body];
}

#pragma mark - Request from manager

- (NSOperation *)operationService:(NSString *)service method:(NSString *)method params:(NSDictionary *)params bodyParams:(NSDictionary *)bodyParams responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self request:method service:service params:params bodyParams:bodyParams failureBlock:failureBlock];
    
    if (request) {
        
        [[[ROUtils sharedInstance] analytics] logRequest:service
                                                  method:method];
        
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = self.manager.responseSerializer;
        __weak typeof (self) weakSelf = self;
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            [[[ROUtils sharedInstance] analytics] logResponse:service
                                                         code:@(operation.response.statusCode)
                                                         body:responseObject];
            
            [weakSelf processSuccess:operation
                      responseObject:responseObject
                       responseClass:responseClass
                        successBlock:successBlock];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [[[ROUtils sharedInstance] analytics] logResponse:service
                                                         code:@(operation.response.statusCode)
                                                         body:error];
            
            [weakSelf processFailure:operation
                               error:error
                        failureBlock:failureBlock];
            
        }];
        return op;
        
    }
    return nil;
}

- (void)service:(NSString *)service method:(NSString *)method params:(NSDictionary *)params bodyParams:(NSDictionary *)bodyParams responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[self operationService:service
                                                                                  method:method
                                                                                  params:params
                                                                              bodyParams:bodyParams
                                                                           responseClass:responseClass
                                                                            successBlock:successBlock
                                                                            failureBlock:failureBlock];
    [self.manager.operationQueue addOperation:operation];
}

#pragma mark - Manager

- (NSOperation *)get:(NSString *)service params:(NSDictionary *)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{

    [[[ROUtils sharedInstance] analytics] logRequest:service
                                              method:@"GET"];
    
    __weak typeof(self) weakSelf = self;
    return [self.manager GET:service
                  parameters:[self cleanParams:params]
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
                         [[[ROUtils sharedInstance] analytics] logResponse:service
                                                                      code:@(operation.response.statusCode)
                                                                      body:responseObject];
                         
                         [weakSelf processSuccess:operation
                                   responseObject:responseObject
                                    responseClass:responseClass
                                     successBlock:successBlock];
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         
                         [[[ROUtils sharedInstance] analytics] logResponse:service
                                                                      code:@(operation.response.statusCode)
                                                                      body:error];
                         
                         [weakSelf processFailure:operation
                                            error:error
                                     failureBlock:failureBlock];
                         
                     }];
}

- (NSOperation *)post:(NSString *)service params:(id)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{

    [[[ROUtils sharedInstance] analytics] logRequest:service
                                              method:@"POST"];
    
    __weak typeof(self) weakSelf = self;
    return [self.manager POST:service
                   parameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          [[[ROUtils sharedInstance] analytics] logResponse:service
                                                                       code:@(operation.response.statusCode)
                                                                       body:responseObject];
                          
                          [weakSelf processSuccess:operation
                                    responseObject:responseObject
                                     responseClass:responseClass
                                      successBlock:successBlock];
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          [[[ROUtils sharedInstance] analytics] logResponse:service
                                                                       code:@(operation.response.statusCode)
                                                                       body:error];
                          
                          [weakSelf processFailure:operation
                                             error:error
                                      failureBlock:failureBlock];
                          
                      }];
}

- (NSOperation *)put:(NSString *)service params:(id)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{

    [[[ROUtils sharedInstance] analytics] logRequest:service
                                              method:@"PUT"];
    
    __weak typeof(self) weakSelf = self;
    return [self.manager PUT:service
                  parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
                         [[[ROUtils sharedInstance] analytics] logResponse:service
                                                                      code:@(operation.response.statusCode)
                                                                      body:responseObject];
                         
                         [weakSelf processSuccess:operation
                                   responseObject:responseObject
                                    responseClass:responseClass
                                     successBlock:successBlock];
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         
                         [[[ROUtils sharedInstance] analytics] logResponse:service
                                                                      code:@(operation.response.statusCode)
                                                                      body:error];
                         
                         [weakSelf processFailure:operation
                                            error:error
                                     failureBlock:failureBlock];
                         
                     }];
}

- (NSOperation *)delete:(NSString *)service params:(NSDictionary *)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{

    [[[ROUtils sharedInstance] analytics] logRequest:service
                                              method:@"DELETE"];
    
    __weak typeof(self) weakSelf = self;
    return [self.manager DELETE:service
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            [[[ROUtils sharedInstance] analytics] logResponse:service
                                                                         code:@(operation.response.statusCode)
                                                                         body:responseObject];
                            
                            [weakSelf processSuccess:operation
                                      responseObject:responseObject
                                       responseClass:responseClass
                                        successBlock:successBlock];
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                            // Fix bug: content type header no json
                            if (operation.response.statusCode > 199 && operation.response.statusCode < 300) {
                                
                                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                                NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                
                                [weakSelf processSuccess:operation
                                          responseObject:response
                                           responseClass:responseClass
                                            successBlock:successBlock];
                                
                            } else {
                                
                                [[[ROUtils sharedInstance] analytics] logResponse:service
                                                                             code:@(operation.response.statusCode)
                                                                             body:error];
                                
                                [weakSelf processFailure:operation
                                                   error:error
                                            failureBlock:failureBlock];
                                
                            }
                            
                        }];
}

#pragma mark - Batch

- (void)batchOfRequestOperations:(NSArray *)operations progress:(ProgressBlock)progressBlock complete:(CompleteBlock)completeBlock waitUntilFinished:(BOOL)wait
{
    NSArray *operationsToProcess = [AFURLConnectionOperation batchOfRequestOperations:operations
                                                                        progressBlock:progressBlock
                                                                      completionBlock:^(NSArray *operationsCompleted) {
                                                                          
                                                                          if (completeBlock) {
                                                                              BOOL isSuccess = YES;
                                                                              for (AFHTTPRequestOperation *op in operationsCompleted) {
                                                                                  if (op.error) {
                                                                                      isSuccess = NO;
                                                                                  }
                                                                              }
                                                                              completeBlock(isSuccess);
                                                                          }
                                                                          
                                                                      }];
    [self.manager.operationQueue addOperations:operationsToProcess waitUntilFinished:wait];
}

#pragma mark - Upload

- (void)post:(NSString *)service params:(NSDictionary *)params data:(NSData *)data name:(NSString *)name mimeType:(NSString *)mimeType responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{

    [[[ROUtils sharedInstance] analytics] logRequest:service
                                              method:@"POST"];
    
    __weak typeof (self) weakSelf = self;
    [self.manager POST:service parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSError *error = nil;
        [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error] name:@"data"];
        
        [formData appendPartWithFileData:data
                                    name:@"data"
                                fileName:@"data"
                                mimeType:mimeType];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[[ROUtils sharedInstance] analytics] logResponse:service
                                                     code:@(operation.response.statusCode)
                                                     body:responseObject];
        
        [weakSelf processSuccess:operation
                  responseObject:responseObject
                   responseClass:responseClass
                    successBlock:successBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[[ROUtils sharedInstance] analytics] logResponse:service
                                                     code:@(operation.response.statusCode)
                                                     body:error];
        
        [weakSelf processFailure:operation
                           error:error
                    failureBlock:failureBlock];
    }];
}

- (void)post:(NSString *)service params:(NSDictionary *)params datas:(NSDictionary *)datas mimeType:(NSString *)mimeType responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    
    [[[ROUtils sharedInstance] analytics] logRequest:service
                                              method:@"POST"];
    
    __weak typeof (self) weakSelf = self;
    [self.manager POST:service parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        
        [dicPost addEntriesFromDictionary:params];
        
        NSArray *keys = [datas allKeys];
        
        for (NSString *key in keys) {
            
            [dicPost setValue:[NSString stringWithFormat:@"cid:%@", key] forKey:key];
        }
        
        NSError *error = nil;
        [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:dicPost options:NSJSONWritingPrettyPrinted error:&error] name:@"data"];
        
        for (NSString *key in keys) {
            
            [formData appendPartWithFileData:[datas objectForKey:key]
                                        name:key
                                    fileName:key
                                    mimeType:mimeType];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[[ROUtils sharedInstance] analytics] logResponse:service
                                                     code:@(operation.response.statusCode)
                                                     body:responseObject];
        
        [weakSelf processSuccess:operation
                  responseObject:responseObject
                   responseClass:responseClass
                    successBlock:successBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[[ROUtils sharedInstance] analytics] logResponse:service
                                                     code:@(operation.response.statusCode)
                                                     body:error];
        
        [weakSelf processFailure:operation
                           error:error
                    failureBlock:failureBlock];
        
        
    }];
}

- (void)put:(NSString *)service params:(NSDictionary *)params datas:(NSDictionary *)datas mimeType:(NSString *)mimeType responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    
    [[[ROUtils sharedInstance] analytics] logRequest:service
                                              method:@"PUT"];
    
    __weak typeof (self) weakSelf = self;
    [self PUT:service parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        
        [dicPost addEntriesFromDictionary:params];
        
        NSArray *keys = [datas allKeys];
        
        for (NSString *key in keys) {
            
            [dicPost setValue:[NSString stringWithFormat:@"cid:%@", key] forKey:key];
        }
        
        NSError *error = nil;
        [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:dicPost options:NSJSONWritingPrettyPrinted error:&error] name:@"data"];
        
        for (NSString *key in keys) {
            
            [formData appendPartWithFileData:[datas objectForKey:key]
                                        name:key
                                    fileName:key
                                    mimeType:mimeType];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[[ROUtils sharedInstance] analytics] logResponse:service
                                                     code:@(operation.response.statusCode)
                                                     body:responseObject];
        
        [weakSelf processSuccess:operation
                  responseObject:responseObject
                   responseClass:responseClass
                    successBlock:successBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[[ROUtils sharedInstance] analytics] logResponse:service
                                                     code:@(operation.response.statusCode)
                                                     body:error];
        
        [weakSelf processFailure:operation
                           error:error
                    failureBlock:failureBlock];
    }];
}

#pragma mark - Helpers

- (NSMutableURLRequest *)request:(NSString *)method service:(NSString *)service params:(NSDictionary *)params bodyParams:(NSDictionary *)bodyParams failureBlock:(FailureBlock)failureBlock
{
    NSString *urlString = [[self.manager.baseURL absoluteString] stringByAppendingString:service];
    NSError *error = nil;
    
    /*
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]
     cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
     timeoutInterval:self.timeout];
     
     [request setHTTPMethod:method];
     
     [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
     */
    
    NSMutableURLRequest *request = [self.manager.requestSerializer requestWithMethod:method
                                                                           URLString:urlString
                                                                          parameters:params
                                                                               error:&error];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if ([self.headerFields count] != 0) {
        for (NSString* key in self.headerFields) {
            NSString *value = [self.headerFields ro_stringForKey:key];
            if (value) {
                [request setValue:value forHTTPHeaderField:key];
            }
        }
    }
    
    if (error) {
        
        [self processFailure:nil error:error failureBlock:failureBlock];
        return nil;
        
    } else if (bodyParams) {
        
        NSError *jsonError = nil;
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:bodyParams
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&jsonError];
        if (jsonError) {
            
            [self processFailure:nil error:jsonError failureBlock:failureBlock];
            return nil;
            
        } else {
            
            NSString *contentJSONString = [[NSString alloc] initWithData:JSONData
                                                                encoding:NSUTF8StringEncoding];
            // Generate an NSData from your NSString (see below for link to more info)
            NSData *postBody = [contentJSONString dataUsingEncoding:NSUTF8StringEncoding];
            
            // Add Content-Length header if your server needs it
            unsigned long long postLength = postBody.length;
            NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
            [request setValue:contentLength forHTTPHeaderField:@"Content-Length"];
            
            // This should all look familiar...
            [request setHTTPBody:postBody];
        }
        
    }
    return request;
}

- (void)processSuccess:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock
{
    if (successBlock) {
        if (responseClass) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSMutableArray *objects = [NSMutableArray new];
                for (id obj in responseObject) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        [objects addObject:[self objectWithDictionary:obj objectClass:responseClass]];
                    }
                }
                successBlock(objects);
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                successBlock([self objectWithDictionary:responseObject objectClass:responseClass]);
                
            } else {
                successBlock(responseObject);
            }
        } else {
            successBlock(responseObject);
        }
    }
}

- (id)objectWithDictionary:(NSDictionary *)dic objectClass:(__unsafe_unretained Class)objectClass
{
    id object = [objectClass new];
    if ([object conformsToProtocol:@protocol(ROModelDelegate)]) {
        
        [object updateWithDictionary:dic];
        
    } else {
        
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        config.datePattern = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:objectClass
                                                                 andConfiguration:config];
        object = [parser parseDictionary:dic];
        
    }
    return object;
}

- (void)processFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error failureBlock:(FailureBlock)failureBlock
{
    ROError *roError = [ROError errorWithFn:__PRETTY_FUNCTION__
                                      error:error
                                  operation:operation];
    
    if (error && error.userInfo) {
        NSData *data= error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString *failureResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        roError.body = failureResponse;
    }
    
#ifdef DEBUG
    [roError log];
#endif
    if (failureBlock) {
        failureBlock(roError);
    }
}

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrlString]];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        
        // setup http basic auth
        [_manager.requestSerializer clearAuthorizationHeader];
        [_manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [_manager.requestSerializer setTimeoutInterval:self.timeout];
        
        /*
         NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:_manager.responseSerializer.acceptableContentTypes];
         [contentTypes addObject:@"text/html"];
         _manager.responseSerializer.acceptableContentTypes = contentTypes;
         */
        
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    if (self.headerFields) {
        for (NSString* key in self.headerFields) {
            NSString *value = [self.headerFields ro_stringForKey:key];
            [_manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    return _manager;
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(id)parameters
      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.manager.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.manager.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.manager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    AFHTTPRequestOperation *operation = [self.manager HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    [self.manager.operationQueue addOperation:operation];
    
    return operation;
}

@end
