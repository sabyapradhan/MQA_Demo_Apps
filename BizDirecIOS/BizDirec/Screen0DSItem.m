//
//  Screen0DSItem.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "Screen0DSItem.h"
#import "NSDictionary+RO.h"

@implementation Screen0DSItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {

	self = [super init];
	if (self) {
		[self updateWithDictionary:dictionary];
	}
	return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    
    self.name = [dictionary ro_stringForKey:kScreen0DSItemName];
    
    self.descriptionProp = [dictionary ro_stringForKey:kScreen0DSItemDescription];
    
    self.picture = [dictionary ro_stringForKey:kScreen0DSItemPicture];
    
    self.phone = [dictionary ro_stringForKey:kScreen0DSItemPhone];
    
    id location = [dictionary objectForKey:kScreen0DSItemLocation];
    if ([location isKindOfClass:[NSDictionary class]]) {
    	self.location = [[RORestGeoPoint alloc] initWithDictionary:location];
    }
    
    self.address = [dictionary ro_stringForKey:kScreen0DSItemAddress];
    
    self.rating = [dictionary ro_stringForKey:kScreen0DSItemRating];
    
    self.idProp = [dictionary ro_stringForKey:kScreen0DSItemId];
}

- (id)identifier {
	
	return self.idProp;
}

@end
