//
//  ROModel.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@protocol ROModelDelegate <NSObject>

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

@optional

- (id)identifier;

@end