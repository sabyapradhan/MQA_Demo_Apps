//
//  MainNavigationManager.h
//  BizDirec
//
//  This App has been generated using IBM Mobile App Builder
//

#import "CategoriesViewController.h"
#import "ROBlockAction.h"
#import "ROLoginManager.h"
#import "ROBasicAuthLoginService.h"
#import "ROLoginViewController.h"
#import "ROStyle.h"
#import "UIViewController+RO.h"
#import "MainMenuViewController.h"
#import "ECSlidingViewController.h"
#import "MainNavigationManager.h"

@interface MainNavigationManager ()

@property (nonatomic, strong) ECSlidingViewController *slidingViewController;

@property (nonatomic, strong) ROLoginViewController *loginViewController;

@property (nonatomic, assign) BOOL loginEnabled;

@end

@implementation MainNavigationManager

+ (instancetype)sharedInstance {

    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init {

    self = [super init];
    if (self) {

        _loginEnabled = NO;
    }

    return self;
}

- (UIViewController *)mainViewController {

    if (!_mainViewController) {

        // Change this controller if you change the main view controller

        // Navigation based in sliding controller
        _mainViewController = self.slidingViewController;

        // Navigation based in navigation controller
        // MainMenuViewController *mainMenuViewController = [MainMenuViewController new];
        // _mainViewController = [[UINavigationController alloc] initWithRootViewController:mainMenuViewController];
    }

    return _mainViewController;
}

- (UIViewController *)rootViewController {

    UIViewController *viewController;

    if (self.loginEnabled) {

        viewController = self.loginViewController;

    } else {

        viewController = self.mainViewController;
    }

    return viewController;
}

- (ECSlidingViewController *)slidingViewController {

    if (!_slidingViewController) {

        UIViewController *rootViewController = [CategoriesViewController new];

        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

        [rootViewController ro_addLeftSlidingButton];

        navigationController.view.layer.shadowOpacity = 0.75f;
        navigationController.view.layer.shadowRadius = 10.0f;
        navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;

        navigationController.view.backgroundColor = [[ROStyle sharedInstance] backgroundColor];

        _slidingViewController = [[ECSlidingViewController alloc] initWithTopViewController:navigationController];

        [navigationController.view addGestureRecognizer:_slidingViewController.panGesture];

        MainMenuViewController *mainMenuViewController = [MainMenuViewController new];

        UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:mainMenuViewController];

        menuNavigationController.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft;

        _slidingViewController.underLeftViewController = menuNavigationController;

        _slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesturePanning|ECSlidingViewControllerAnchoredGestureTapping;
    }

    return _slidingViewController;
}

- (ROLoginViewController *)loginViewController {

    if (!_loginViewController && self.loginEnabled) {

        _loginViewController = [ROLoginViewController new];

        _loginViewController.loginService = [[ROBasicAuthLoginService alloc] initWithBaseUrl:@"https://appbuilder.ibmcloud.com/api/app"
                                                                                       appId:@"a7bbe244-427b-45b3-8df8-b35d5e6c4e85"];
        __weak typeof(self) weakSelf = self;
        [_loginViewController setOnSuccessBlock:^{

            UIViewController *presentViewController = weakSelf.mainViewController;
            presentViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf.loginViewController presentViewController:presentViewController
                                                       animated:NO
                                                     completion:nil];


        } onFailureBlock:^{

        }];

    }

    return _loginViewController;
}

- (void)enterBackground {

    // save last active state
    if ([self loginEnabled]) {

        [[ROLoginManager sharedInstance] saveLastSuspendDate];
    }
}

- (void)enterForeground {

    // check login status and redirect if needed
    if ([self loginEnabled]) {

        __weak typeof(self) weakSelf = self;
        [[ROLoginManager sharedInstance] checkLoginStateAndRedirect:^{

            [weakSelf.loginViewController reset];
            [weakSelf.loginViewController ro_dismissAllControllers];

        }];
    }
}

- (void)terminate {

    if ([self loginEnabled]) {

        [[ROLoginManager sharedInstance] resetLoginState];
    }
}

- (void)logout {

    if ([self loginEnabled]) {

        [self.loginViewController reset];
    }
}

- (id<ROAction>)logoutAction {

    ROBlockAction *action = [ROBlockAction actionWithBlock:^{

        [self logout];
        [self.mainViewController dismissViewControllerAnimated:YES
                                                    completion:nil];
        self.slidingViewController = nil;
        self.mainViewController = nil;

    }];

    return action;
}

@end
