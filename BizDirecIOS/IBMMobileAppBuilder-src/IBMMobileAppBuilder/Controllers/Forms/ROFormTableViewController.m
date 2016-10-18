//
//  ROFormTableViewController.m
//  IBMMobileAppBuilder
//

#import "ROFormTableViewController.h"
#import "ROStyle.h"
#import "ROFormFieldText.h"
#import "ROFormFieldGeo.h"
#import "RORestGeoPoint.h"
#import "NSNumber+RO.h"

static NSString *const kDateFormat_ISO8601      = @"yyyy-MM-dd'T'HH:mm:ss.sss'Z'";

@interface ROFormTableViewController ()

@property (nonatomic, strong) NSIndexPath *editingIndexPath;

- (void)prevResponderAction:(id)sender;

- (void)nextResponderAction:(id)sender;

- (void)keyboardToolbarDoneAction:(id)sender;

@end

@implementation ROFormTableViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.tableViewStyle = UITableViewStylePlain;
        
        self.hiddenValues = [NSMutableDictionary new];
        
        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [self.dateFormatter setDateFormat:kDateFormat_ISO8601];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
    }

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    [self configureFormView];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.responders == nil) {
        self.responders = [NSMutableArray new];
        for (id<ROFormFieldDelegate> field in self.fields) {
            if ([field isKindOfClass:[ROFormFieldText class]]) {
                ROFormFieldText *fieldText = (ROFormFieldText *)field;
                fieldText.textField.inputAccessoryView = self.keyboardToolbar;
                [self.responders addObject:fieldText.textField];
            } else if ([field isKindOfClass:[ROFormFieldGeo class]]) {
                ROFormFieldGeo *fieldGeo = (ROFormFieldGeo *)field;
                fieldGeo.latitudeField.inputAccessoryView = self.keyboardToolbar;
                fieldGeo.longitudeField.inputAccessoryView = self.keyboardToolbar;
                [self.responders addObject:fieldGeo.latitudeField];
                [self.responders addObject:fieldGeo.longitudeField];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_tableView) {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    if (_fields) {
        [_fields removeAllObjects];
        _fields = nil;
    }
    if (_keyboardToolbar) {
        [_keyboardToolbar removeFromSuperview];
        _keyboardToolbar = nil;
    }
    if (_responders) {
        [_responders removeAllObjects];
        _responders = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.tintColor = [[ROStyle sharedInstance] accentColor];
        _tableView.separatorColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.5f];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (UIToolbar *)keyboardToolbar {
    if (!_keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectZero];
        
        UIBarButtonItem *prevBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"< Prev", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(prevResponderAction:)];
        
        UIBarButtonItem *nextBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next >", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(nextResponderAction:)];
        
        UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(keyboardToolbarDoneAction:)];
        
        _keyboardToolbar.items = [NSArray arrayWithObjects:
                                  prevBarButtonItem,
                                  nextBarButtonItem,
                                  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                  doneBarButtonItem,
                                  nil];

        [_keyboardToolbar sizeToFit];
    }
    return _keyboardToolbar;
}

- (void)configureFormView
{
    [self.view addSubview:self.tableView];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_tableView);
    
    // align view from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                      options:0
                                                                      metrics:0
                                                                        views:viewsBindings]];
    
    // align view from the top and bottom
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|"
                                                                      options:0
                                                                      metrics:0
                                                                        views:viewsBindings]];
    
}

- (BOOL)validate
{
    NSMutableArray *errors = [NSMutableArray new];
    NSInteger i = 0;
    for (id<ROFormFieldDelegate> field in self.fields) {
        if (![field valid]) {
            [errors addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        i++;
    }
    if ([errors count] != 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.tableView scrollToRowAtIndexPath:errors[0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            
        } completion:^(BOOL finished){
            
        }];
        
        return NO;
        
    } else {
        
        return YES;
    }
}

- (NSMutableDictionary *)jsonValues
{
    NSMutableDictionary *jsonHiddenValues = [NSMutableDictionary new];
    for (NSString *key in self.hiddenValues) {
        id obj = [self.hiddenValues objectForKey:key];
        if ([obj isKindOfClass:[NSDate class]]) {
            [jsonHiddenValues setObject:[self.dateFormatter stringFromDate:obj] forKey:key];
        } else if ([obj isKindOfClass:[RORestGeoPoint class]]) {
            [jsonHiddenValues setObject:[obj jsonValue] forKey:key];
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            [jsonHiddenValues setObject:[obj ro_stringValue] forKey:key];
        } else {
            [jsonHiddenValues setObject:obj forKey:key];
        }
    }
    NSMutableDictionary *values = [NSMutableDictionary dictionaryWithDictionary:jsonHiddenValues];
    for (id<ROFormFieldDelegate> field in self.fields) {
        if ([field jsonValue] != nil) {
            [values setObject:[field jsonValue] forKey:[field name]];
        }
    }
    return values;
}

- (id<ROFormFieldDelegate>)fieldAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self.fields objectAtIndex:(NSInteger)indexPath.row];
    }
    return [self.buttons objectAtIndex:(NSInteger)indexPath.row];
}

#pragma mark - Keyboard events

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    CGFloat margin = self.keyboardToolbar.frame.size.height;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        margin = keyboardSize.height + margin;
    } else {
        margin = keyboardSize.width + margin;
    }
    UIEdgeInsets contentInsets = self.tableView.contentInset;
    contentInsets.bottom = margin;
    
    [UIView animateWithDuration:rate.floatValue animations:^{
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.editingIndexPath = nil;
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        contentInsets.top = self.topLayoutGuide.length;
        
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)prevResponderAction:(id)sender
{
    id prevField = nil;
    for (NSInteger i=0; i!=[self.responders count];i++) {
        id field = self.responders[i];
        if ([field isEditing]) {
            if (i == 0) {
                prevField = self.responders[[self.responders count]-1];
            } else {
                prevField = self.responders[i-1];
            }
            break;
        }
    }
    if (prevField) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.1 animations:^{
                
                self.editingIndexPath = [NSIndexPath indexPathForRow:[prevField tag] inSection:0];
                
                [self.tableView scrollToRowAtIndexPath:self.editingIndexPath
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:NO];
                
            } completion:^(BOOL finished){
                
                [prevField becomeFirstResponder];
                
            }];
            
        });
    }
}

- (void)nextResponderAction:(id)sender
{
    id nextField = nil;
    for (NSInteger i=0; i!=[self.responders count];i++) {
        id field = self.responders[i];
        if ([field isEditing]) {
            if (i+1 == [self.responders count]) {
                nextField = self.responders[0];
            } else {
                nextField = self.responders[i+1];
            }
            break;
        }
    }
    if (nextField) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.1 animations:^{
                
                self.editingIndexPath = [NSIndexPath indexPathForRow:[nextField tag] inSection:0];
                
                [self.tableView scrollToRowAtIndexPath:self.editingIndexPath
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:NO];
                
            } completion:^(BOOL finished){
                
                [nextField becomeFirstResponder];
                
            }];
            
        });
        
    }
}

- (void)keyboardToolbarDoneAction:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger n = 0;
    if (self.fields && [self.fields count] != 0) {
        n += 1;
    }
    if (self.buttons && [self.buttons count] != 0) {
        n += 1;
    }
    return n;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.fields count];
    }
    return [self.buttons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<ROFormFieldDelegate> formField = [self fieldAtIndexPath:indexPath];
    return [formField tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<ROFormFieldDelegate> formField = [self fieldAtIndexPath:indexPath];
    return [formField tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<ROFormFieldDelegate> formField = [self fieldAtIndexPath:indexPath];
    [formField tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

@end
