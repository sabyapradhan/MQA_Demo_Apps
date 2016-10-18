//
//  DatasourceManager.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import <Foundation/Foundation.h>

@class Screen0DS;
@class RestaurantsDS;
@class LawyersScreen1DS;
@class GymsScreen1DS;

@interface DatasourceManager : NSObject

@property (nonatomic, strong) Screen0DS *screen0DS;

@property (nonatomic, strong) RestaurantsDS *restaurantsDS;

@property (nonatomic, strong) LawyersScreen1DS *lawyersScreen1DS;

@property (nonatomic, strong) GymsScreen1DS *gymsScreen1DS;

/**
 Singleton
 @return Class instance
 */
+ (instancetype)sharedInstance;

/**
 Synchronize all datasource
 */
- (void)sync;

@end
