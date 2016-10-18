//
//  ROViewController.m
//  IBMMobileAppBuilder
//

#import "ROViewController.h"
#import "UIView+RO.h"
#import "ROStyle.h"
#import "ROBehavior.h"
#import "ROOptionsFilter.h"

@interface ROViewController ()

@end

@implementation ROViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Configure status bar
    UIColor *constrainsColor = [[ROStyle sharedInstance] backgroundColor];
    if (self.navigationController) {
        constrainsColor = [[ROStyle sharedInstance] applicationBarBackgroundColor];
    }
    if ([[ROStyle sharedInstance] useStyleLightForColor:constrainsColor]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ROViewController

- (NSMutableArray *)behaviors
{
    if (!_behaviors) {
        _behaviors = [NSMutableArray new];
    }
    return _behaviors;
}

/**
 Default implementation that colors the background with the bg color and image
 */
- (void)configureView
{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    // Do any additional setup after loading the view.
    [self.view ro_setBackgroundColor:[[ROStyle sharedInstance] backgroundColor]];
    UIImage *backgroundImage = [[ROStyle sharedInstance] backgroundImage];
    if (backgroundImage) {
        //self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view ro_setBackgroundImage:backgroundImage];
    }
}

@end
