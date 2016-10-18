//
//  ROLoginViewController.h
//  IBMMobileAppBuilder
//

#import <UIKit/UIKit.h>
#import "ROViewController.h"
#import "ROLoginService.h"

typedef void (^ROLoginSuccessBlock)();
typedef void (^ROLoginFailureBlock)();

@interface ROLoginViewController : ROViewController

@property(nonatomic, strong) id <ROLoginService> loginService;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *appNameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *emailTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *passTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *loginButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *appIconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *loginView;

/**
 Resets the controller to its initial state
 */
- (void)reset;

/**
 Login button callback
 */
- (IBAction)onLogin:(id)sender;

/**
 Sets the login success or failure callback
 @param success The success block
 @param failure the failure block
 */
- (void)setOnSuccessBlock:(ROLoginSuccessBlock)success onFailureBlock:(ROLoginFailureBlock)failure;

@end
