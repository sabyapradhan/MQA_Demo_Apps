//
//  LawyersScreen1DSItem.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "LawyersScreen1DSItem.h"
#import "NSDictionary+RO.h"

@implementation LawyersScreen1DSItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {

	self = [super init];
	if (self) {
		[self updateWithDictionary:dictionary];
	}
	return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    
    self.name = [dictionary ro_stringForKey:kLawyersScreen1DSItemName];
    
    self.descriptionProp = [dictionary ro_stringForKey:kLawyersScreen1DSItemDescription];
    
    self.picture = [dictionary ro_stringForKey:kLawyersScreen1DSItemPicture];
    
    self.phone = [dictionary ro_stringForKey:kLawyersScreen1DSItemPhone];
    
    id location = [dictionary objectForKey:kLawyersScreen1DSItemLocation];
    if ([location isKindOfClass:[NSDictionary class]]) {
    	self.location = [[RORestGeoPoint alloc] initWithDictionary:location];
    }
    
    self.address = [dictionary ro_stringForKey:kLawyersScreen1DSItemAddress];
    
    self.rating = [dictionary ro_stringForKey:kLawyersScreen1DSItemRating];
    
    self.idProp = [dictionary ro_stringForKey:kLawyersScreen1DSItemId];
}

- (id)identifier {
	
	return self.idProp;
}

@end
