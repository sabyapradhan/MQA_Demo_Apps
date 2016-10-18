//
//  CDTURLSessionFilterContext.h
//  
//
//  Created by Rhys Short on 17/08/2015.
//  Copyright (c) 2015 IBM Corp.
//
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//

#import <Foundation/Foundation.h>
#import "CDTMacros.h"

@interface CDTHTTPInterceptorContext : NSObject

@property (nonnull, readwrite, nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic) BOOL shouldRetry;
@property (nullable, readwrite, nonatomic, strong) NSHTTPURLResponse *response;

/**
 *  Unavaiable, use -initWithRequest
 *
 *  Calling this method from your code will result in
 *  an exception being thrown.
 **/
- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;

/**
 *  Initalizes a CDTURLSessionInterceptorContext
 *
 *  @param request the request this context should represent
 **/
- (nullable instancetype)initWithRequest:(nonnull NSMutableURLRequest *)request
    NS_DESIGNATED_INITIALIZER;

@end


