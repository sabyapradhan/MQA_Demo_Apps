//
//  LawyersScreen1DS.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "LawyersScreen1DS.h"
#import "ROUtils.h"
#import "NSString+RO.h"
#import "LawyersScreen1DSItem.h"

@implementation LawyersScreen1DS

static NSString *const kUrl             = @"https://ibm-pods.buildup.io";
static NSString *const kApiKey          = @"8QRnDwNp";
static NSString *const kResourceId      = @"/app/57fd125484d1a30300ca2c24/r/lawyersScreen1DS";

- (instancetype)init {

    self = [super initWithUrlString:kUrl 
                             apiKey:kApiKey 
                         resourceId:kResourceId 
                       objectsClass:[LawyersScreen1DSItem class]];
    if (self) {
    
        self.delegate = self;
    }
    return self;
}

- (NSString *)imagePath:(NSString *)path {
  
    if ([path isUrl]) {
        return path;
    }

    return [NSString stringWithFormat:@"https://ibm-pods.buildup.io/app/57fd125484d1a30300ca2c24%@?apikey=%@", path, self.apiKey];
}

#pragma mark - <ROSearchable>

- (NSArray *)searchableFields {

    return @[kLawyersScreen1DSItemName, kLawyersScreen1DSItemDescription, kLawyersScreen1DSItemPhone, kLawyersScreen1DSItemAddress, kLawyersScreen1DSItemRating, kLawyersScreen1DSItemId];
}

#pragma mark - <ROCRUDServiceDelegate>

- (void)itemsWithParams:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {

    [self.restClient get:self.resourceId 
                  params:params 
           responseClass:self.objectsClass
            successBlock:successBlock 
            failureBlock:failureBlock];
}

- (void)itemWithIdentifier:(NSString *)identifier successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {

    NSString *service = [NSString stringWithFormat:@"%@/%@", self.resourceId, identifier];
    [self.restClient get:service 
                  params:nil 
           responseClass:self.objectsClass 
            successBlock:^(id response) {
              
                [[[ROUtils sharedInstance] analytics] logAction:@"read"
                                                         entity:@"LawyersScreen1DSItem"
                                                     identifier:identifier];
                if (successBlock) {
                    
                    successBlock(response);
                }
                
            } failureBlock:failureBlock];
}

- (void)createItemWithParams:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {

    NSMutableDictionary *dicNoImages = [NSMutableDictionary new];
    NSMutableDictionary *dicImages = [NSMutableDictionary new];
    
    NSArray *keys = [params allKeys];
    
    for (NSString *key in keys) {
        
        if ([[params valueForKey:key] isKindOfClass:[NSData class]]) {
            
            [dicImages setValue:[params valueForKey:key] forKey:key];

        } else {
            
            [dicNoImages setValue:[params valueForKey:key] forKey:key];
        }
    }
    
    [self.restClient post:self.resourceId 
                   params:dicNoImages 
                    datas:dicImages 
                 mimeType:@"image/jpeg"
            responseClass:self.objectsClass 
             successBlock:^(id response) {
                 
                 [[[ROUtils sharedInstance] analytics] logAction:@"created"
                                                          entity:@"LawyersScreen1DSItem"];
                 if (successBlock) {
                     
                     successBlock(response);
                 }
                 
             } failureBlock:failureBlock];
}

- (void)updateItemWithIdentifier:(NSString *)identifier params:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {

    NSString *service = [NSString stringWithFormat:@"%@/%@", self.resourceId, identifier];
    NSMutableDictionary *dicNoImages = [NSMutableDictionary new];
    NSMutableDictionary *dicImages = [NSMutableDictionary new];
    
    NSArray *keys = [params allKeys];
    
    for (NSString *key in keys) {
        
        if ([[params valueForKey:key] isKindOfClass:[NSData class]]) {
            
            [dicImages setValue:[params valueForKey:key] forKey:key];
            
        } else {
            
            [dicNoImages setValue:[params valueForKey:key] forKey:key];
        }
    }
    
    [self.restClient put:service 
                   params:dicNoImages 
                    datas:dicImages 
                 mimeType:@"image/jpeg"
            responseClass:self.objectsClass 
             successBlock:^(id response) {
                
                [[[ROUtils sharedInstance] analytics] logAction:@"updated"
                                                         entity:@"LawyersScreen1DSItem"
                                                     identifier:identifier];
                if (successBlock) {
                    
                    successBlock(response);
                }
                
            } failureBlock:failureBlock];
    
}

- (void)deleteItemWithIdentifier:(NSString *)identifier successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {

    NSString *service = [NSString stringWithFormat:@"%@/%@", self.resourceId, identifier];
    [self.restClient delete:service 
                     params:nil 
              responseClass:nil 
               successBlock:^(id response) {
                   
                   [[[ROUtils sharedInstance] analytics] logAction:@"deleted"
                                                            entity:@"LawyersScreen1DSItem"
                                                        identifier:identifier];
                   if (successBlock) {
                       
                       successBlock(response);
                   }
                   
               } failureBlock:failureBlock];
}

- (void)deleteItemsWithIdentifiers:(NSArray *)identifiers successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {

    NSString *service = [NSString stringWithFormat:@"%@/deleteByIds", self.resourceId];
    [self.restClient post:service
                   params:identifiers 
            responseClass:nil
             successBlock:^(id response) {
                 
                 [[[ROUtils sharedInstance] analytics] logAction:@"deleted"
                                                          entity:@"LawyersScreen1DSItem"
                                                      identifier:[identifiers componentsJoinedByString:@", "]];
                 if (successBlock) {
                     
                     successBlock(response);
                 }
                 
             } failureBlock:failureBlock];
}

@end
