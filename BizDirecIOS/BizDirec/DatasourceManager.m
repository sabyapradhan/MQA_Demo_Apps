//
//  DatasourceManager.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "DatasourceManager.h"
#import "Screen0DS.h"
#import "RestaurantsDS.h"
#import "LawyersScreen1DS.h"
#import "GymsScreen1DS.h"

@implementation DatasourceManager

+ (instancetype)sharedInstance {

    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Properties init

- (Screen0DS *)screen0DS {

    if (!_screen0DS) {

        _screen0DS = [Screen0DS new];
    }
    return _screen0DS;
}

- (RestaurantsDS *)restaurantsDS {

    if (!_restaurantsDS) {

        _restaurantsDS = [RestaurantsDS new];
    }
    return _restaurantsDS;
}

- (LawyersScreen1DS *)lawyersScreen1DS {

    if (!_lawyersScreen1DS) {

        _lawyersScreen1DS = [LawyersScreen1DS new];
    }
    return _lawyersScreen1DS;
}

- (GymsScreen1DS *)gymsScreen1DS {

    if (!_gymsScreen1DS) {

        _gymsScreen1DS = [GymsScreen1DS new];
    }
    return _gymsScreen1DS;
}

#pragma mark - Public methods

- (void)sync {

    
}

@end
