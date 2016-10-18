//
//  GymsScreen1DSItem.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import <Foundation/Foundation.h>
#import "ROModel.h"
#import "RORestGeoPoint.h"
#import "GymsScreen1DSItemKeys.h"

@interface GymsScreen1DSItem : NSObject <ROModelDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *descriptionProp;

@property (nonatomic, strong) NSString *picture;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) RORestGeoPoint *location;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *rating;

@property (nonatomic, strong) NSString *idProp;

@end
