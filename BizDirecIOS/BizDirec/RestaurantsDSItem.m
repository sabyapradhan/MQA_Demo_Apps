//
//  RestaurantsDSItem.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "RestaurantsDSItem.h"
#import "NSDictionary+RO.h"

@implementation RestaurantsDSItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {

	self = [super init];
	if (self) {
		[self updateWithDictionary:dictionary];
	}
	return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    
    self.name = [dictionary ro_stringForKey:kRestaurantsDSItemName];
    
    self.descriptionProp = [dictionary ro_stringForKey:kRestaurantsDSItemDescription];
    
    self.picture = [dictionary ro_stringForKey:kRestaurantsDSItemPicture];
    
    self.phone = [dictionary ro_stringForKey:kRestaurantsDSItemPhone];
    
    id location = [dictionary objectForKey:kRestaurantsDSItemLocation];
    if ([location isKindOfClass:[NSDictionary class]]) {
    	self.location = [[RORestGeoPoint alloc] initWithDictionary:location];
    }
    
    self.address = [dictionary ro_stringForKey:kRestaurantsDSItemAddress];
    
    self.rating = [dictionary ro_stringForKey:kRestaurantsDSItemRating];
    
    self.idProp = [dictionary ro_stringForKey:kRestaurantsDSItemId];
}

- (id)identifier {
	
	return self.idProp;
}

@end
