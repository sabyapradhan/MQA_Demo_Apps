//
//  ROLoginViewController.m
//  IBMMobileAppBuilder
//

#import "ROLoginViewController.h"
#import "NSUserDefaults+AESEncryptor.h"
#import "ROStyle.h"
#import "SVProgressHUD.h"
#import "ROBasicAuthLoginService.h"
#import "UIAlertView+RO.h"
#import "UIImage+RO.h"
#import "NSBundle+RO.h"
#import "ROLoginManager.h"

@interface ROLoginViewController ()

@property (nonatomic, strong) NSURL *baseUrl;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *lastDateStr;
@property (nonatomic, strong) NSString *lastUserEmail;
@property (nonatomic, strong) ROLoginSuccessBlock successBlock;
@property (nonatomic, strong) ROLoginFailureBlock failureBlock;
@property (nonatomic, assign) CGRect loginFrame;
@property (nonatomic, assign) CGRect loginFrameWithKeyboard;

-(void) keyboardDidShow;
-(void) keyboardDidHide;

@end

@implementation ROLoginViewController

- (id)init {
    
    self = [self initWithNibName:@"ROLoginViewController" bundle:[NSBundle ro_resourcesBundle]];
    
    if (self){

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loginFrame = self.loginView.frame;
    _loginFrameWithKeyboard = _loginFrame;
    _loginFrameWithKeyboard.origin.y -= 80.0f;
    
    // show last activity date in login form
    NSString *suspendDateStr = [[ROLoginManager sharedInstance] suspendDateString];
    if(suspendDateStr){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeStyle:NSDateFormatterShortStyle];
        [dateFormat setDateStyle:NSDateFormatterShortStyle];
        [dateFormat setLocale:[NSLocale currentLocale]];
        
        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[suspendDateStr doubleValue]];
        _lastDateStr = [dateFormat stringFromDate:lastDate];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _lastUserEmail = [[NSUserDefaults standardUserDefaults] decryptedValueForKey:@"UserEmail"];
    _emailTextField.text = _lastUserEmail;
    // register for keyboard notifications
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[ROLoginManager sharedInstance] isLogged]) {
    
        if (_successBlock) {
            _successBlock();
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)configureView {
    
    // set colors
    [self.view setBackgroundColor:[[ROStyle sharedInstance] backgroundColor]];
    
    [self.appNameLabel setTextColor:[[ROStyle sharedInstance] foregroundColor]];
    [self.appNameLabel setText: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    
    UIImage *logo = [UIImage ro_imageNamed:@"logoROapp"];
    if (logo) {
        [self.appIconImageView setHidden:NO];
        [self.appIconImageView setImage:logo];
    } else {
        [self.appIconImageView setHidden:YES];
    }
    [self.emailTextField setText:_lastUserEmail];
    
    [self.loginButton setTintColor:[[ROStyle sharedInstance] foregroundColor]];
    self.loginButton.layer.borderColor = [[[ROStyle sharedInstance] foregroundColor] CGColor];
    
    [UIView animateWithDuration:1 animations:^{
        [self.appIconImageView setAlpha:1.0f];
    }];
}

- (void)reset {
    
    // empty password
    [self.passTextField setText:[NSString string]];

    // reset expiration time
    [[ROLoginManager sharedInstance] resetLoginState];

    [self.emailTextField setText:_lastUserEmail];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOnSuccessBlock:(ROLoginSuccessBlock)success onFailureBlock:(ROLoginFailureBlock)failure {
    
    _successBlock = success;
    _failureBlock = failure;
}

- (IBAction)onLogin:(id)sender {
    
    // validate user input
    NSString *email = self.emailTextField.text;
    NSString *pwd = self.passTextField.text;
    
    if(email.length == 0 || pwd.length == 0){
        [UIAlertView ro_showWithErrorMessage:NSLocalizedString(@"Both email and password are required", nil)];
        return;
    }
    
    // login
    if (self.loginService) {
        [SVProgressHUD show];
        
        // if success, continue to next viewcontroller
        [self.loginService loginUser:email withPassword:pwd success:^(ROLoginResponse *loginResponse) {
            
            [SVProgressHUD dismiss];
#ifdef DEBUG
            NSLog(@"Login succeeded: %@", loginResponse);
#endif
            [self storeLoginInfo:email response:loginResponse];
            
            // inform caller
            if(_successBlock) {
                _successBlock();
            }
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            [SVProgressHUD dismiss];
            
            NSString *msg = NSLocalizedString(@"There was a problem retrieving data", nil);
            if (response && response.statusCode == 401) {
                msg = NSLocalizedString(@"Invalid Email or Password", nil);
            }
            [UIAlertView ro_showWithErrorMessage:msg];
            
            // inform caller
            if(_failureBlock) {
                _failureBlock();
            }
        }];

    }
}

-(void)storeLoginInfo:(NSString *)email response:(ROLoginResponse *)loginResponse {
    
    [[NSUserDefaults standardUserDefaults] encryptValue:email withKey:@"UserEmail"];
    
    [[ROLoginManager sharedInstance] updateUserToken:loginResponse.token
                                expirationTimeString:[[NSNumber numberWithDouble:loginResponse.expirationTime] stringValue]];
}

- (void)keyboardDidShow {
    
    _loginView.frame = _loginFrameWithKeyboard;
}

- (void)keyboardDidHide {
    
    _loginView.frame = _loginFrame;
}

@end
