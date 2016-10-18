//
//  ROFormFieldImage.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>
#import "ROFormFieldDelegate.h"
#import "ROImageCrudTableViewCell.h"

@interface ROFormFieldImage : NSObject <ROFormFieldDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id value;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) UIImage *theNewImage;
@property (nonatomic, strong) ROImageCrudTableViewCell *cell;
@property (nonatomic, strong) NSString *urlBasePhoto;
@property (nonatomic, strong) UIViewController *viewController;

- (instancetype)initWithLabel:(NSString *)label
                         name:(NSString *)name
               viewController:(UIViewController *)viewController
                          url:(NSString *)url
                     required:(BOOL)required;

+ (instancetype)fieldWithLabel:(NSString *)label
                          name:(NSString *)name
                viewController:(UIViewController *)viewController
                           url:(NSString *)url
                      required:(BOOL)required;

- (instancetype)initWithLabel:(NSString *)label
                         name:(NSString *)name
               viewController:(UIViewController *)viewController
                     required:(BOOL)required;

+ (instancetype)fieldWithLabel:(NSString *)label
                          name:(NSString *)name
                viewController:(UIViewController *)viewController
                      required:(BOOL)required;

@end
