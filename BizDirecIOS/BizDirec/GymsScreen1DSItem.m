//
//  GymsScreen1DSItem.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "GymsScreen1DSItem.h"
#import "NSDictionary+RO.h"

@implementation GymsScreen1DSItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {

	self = [super init];
	if (self) {
		[self updateWithDictionary:dictionary];
	}
	return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    
    self.name = [dictionary ro_stringForKey:kGymsScreen1DSItemName];
    
    self.descriptionProp = [dictionary ro_stringForKey:kGymsScreen1DSItemDescription];
    
    self.picture = [dictionary ro_stringForKey:kGymsScreen1DSItemPicture];
    
    self.phone = [dictionary ro_stringForKey:kGymsScreen1DSItemPhone];
    
    id location = [dictionary objectForKey:kGymsScreen1DSItemLocation];
    if ([location isKindOfClass:[NSDictionary class]]) {
    	self.location = [[RORestGeoPoint alloc] initWithDictionary:location];
    }
    
    self.address = [dictionary ro_stringForKey:kGymsScreen1DSItemAddress];
    
    self.rating = [dictionary ro_stringForKey:kGymsScreen1DSItemRating];
    
    self.idProp = [dictionary ro_stringForKey:kGymsScreen1DSItemId];
}

- (id)identifier {
	
	return self.idProp;
}

@end
