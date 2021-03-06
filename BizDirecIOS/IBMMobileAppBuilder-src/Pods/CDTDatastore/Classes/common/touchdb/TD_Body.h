//
//  TD_Body.h
//  TouchDB
//
//  Created by Jens Alfke on 6/19/10.
//  Copyright (c) 2011 Couchbase, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A request/response/document body, stored as either JSON or an NSDictionary. */
@interface TD_Body : NSObject {
   @private
    NSData* _json;
    NSDictionary* _object;
    BOOL _error;
}

- (id)initWithProperties:(NSDictionary*)properties;
- (id)initWithArray:(NSArray*)array;
- (id)initWithJSON:(NSData*)json;

+ (TD_Body*)bodyWithProperties:(id)properties;
+ (TD_Body*)bodyWithJSON:(NSData*)json;

@property (readonly) BOOL isValidJSON;
@property (readonly) NSData* asJSON;
@property (readonly) NSData* asPrettyJSON;
@property (readonly) NSString* asJSONString;
@property (readonly) id asObject;
@property (readonly) BOOL error;

@property (readonly) NSDictionary* properties;
- (id)objectForKeyedSubscript:(NSString*)key;  // enables subscript access in Xcode 4.4+

@end
