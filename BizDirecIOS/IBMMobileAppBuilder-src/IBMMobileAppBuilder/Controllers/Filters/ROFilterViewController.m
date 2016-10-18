//
//  ROFormViewController.m
//  IBMMobileAppBuilder
//

#import "ROFilterViewController.h"
#import "NSBundle+RO.h"
#import "ROFilterField.h"
#import "NSBundle+RO.h"
#import "ROStyle.h"
#import "ActionSheetDatePicker.h"
#import "UIImage+RO.h"
#import "ROOptionsFilter.h"
#import "ROViewController.h"
#import "RODataLoader.h"
#import "ROUtils.h"

@interface ROFilterViewController ()

@property (nonatomic, strong) NSMutableDictionary *fieldValues;

@property (nonatomic, assign) BOOL didUpdateConstraints;

@property (nonatomic, strong) NSMutableArray *mainConstraints;

@end

@implementation ROFilterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Configure navigation bar
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    UIBarButtonItem *resetItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", nil) style:UIBarButtonItemStylePlain target:self action:@selector(reset)];
    
    self.navigationItem.rightBarButtonItem = resetItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Add views
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)dealloc {
    
    if (_tableView) {
        
        if (_tableView.superview) {
            
            [_tableView removeFromSuperview];
        }
        _tableView = nil;
    }
}

- (void)updateViewConstraints {
    
    if (!_didUpdateConstraints) {
        
        [self setupConstraints];
        _didUpdateConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - Properties initialization

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.tintColor = [[ROStyle sharedInstance] accentColor];
        _tableView.separatorColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.5f];
    }
    return _tableView;
}

- (UIButton *)submitButton {
    
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:NSLocalizedString(@"Apply", nil) forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [[ROStyle sharedInstance] font];
        _submitButton.tintColor = [[ROStyle sharedInstance] applicationBarTextColor];
        _submitButton.backgroundColor = [[ROStyle sharedInstance] applicationBarBackgroundColor];
        [_submitButton setTitleColor:[[ROStyle sharedInstance] applicationBarTextColor] forState:UIControlStateNormal];
        [_submitButton setTitleColor:[[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.1f] forState:UIControlStateHighlighted];
        [_submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (NSMutableArray *)filters {
    
    if (!_filters) {
        _filters = [NSMutableArray new];
    }
    return _filters;
}

- (void)setFields:(NSArray *)fields {
    
    _fields = fields;
    
    // Save init values
    self.fieldValues = [NSMutableDictionary new];
    for (id<ROFilterField>formField in self.fields) {
        
        // Save values
        NSString *value = [formField fieldValue];
        if (value) {
            [self.fieldValues setObject:value forKey:[formField fieldName]];
        }
        
    }
}

- (NSMutableArray *)mainConstraints {
    
    if (!_mainConstraints) {
        
        _mainConstraints = [NSMutableArray new];
    }
    return _mainConstraints;
}

#pragma mark - Public methods

+ (instancetype)form {
    
    return [self new];
}

- (IBAction)submitButtonAction:(id)sender {
    
    [self submit];
}

- (void)cancel {
    
    for (id<ROFilterField> formField in self.fields) {
        
        NSString *value = self.fieldValues[[formField fieldName]];
        [formField setFieldValue:value];
    }
    [self close];
}

- (void)close {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submit {
    
    [self.filters removeAllObjects];
    
    [self.fieldValues removeAllObjects];
    
    for (id<ROFilterField> formField in self.fields) {
        
        // Create filters
        id <ROFilter> filter = [formField filter];
        if (filter) {
            
            [self.filters addObject:filter];
        }
        
        // Save values
        NSString *value = [formField fieldValue];
        if (value) {
            
            [self.fieldValues setObject:value forKey:[formField fieldName]];
        }
        
    }
    
    if ([self.fieldValues count] != 0) {
    
        NSString *datasourceName = NSStringFromClass([self.dataLoader.datasource class]);
        [[[ROUtils sharedInstance] analytics] logAction:@"filter"
                                                 target:nil
                                         datasourceName:datasourceName];
    }
    
    [self close];
    if (_formDelegate && [_formDelegate conformsToProtocol:@protocol(ROFilterDelegate)]) {
        
        [_formDelegate formSubmitted];
    }
}

- (void)reset {
    
    for (id<ROFilterField> formField in self.fields) {
        [formField setFieldValue:nil];
    }
    [self.tableView reloadData];
}

- (void)setupConstraints {
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view removeConstraints:self.mainConstraints];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_tableView, _submitButton);
    
    // align view from the left and right
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|"
                                                                                      options:0
                                                                                      metrics:0
                                                                                        views:viewsBindings]];
    
    // align view from the top and bottom
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_submitButton]-0-|"
                                                                                      options:0
                                                                                      metrics:0
                                                                                        views:viewsBindings]];
    
    // align view from the top and bottom
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-[_submitButton(==44)]-0-|"
                                                                                      options:0
                                                                                      metrics:0
                                                                                        views:viewsBindings]];
    [self.view addConstraints:self.mainConstraints];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.fields count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id<ROFilterField> formField = self.fields[section];
    return [formField numberOfRows];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.fields[section] fieldLabel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<ROFilterField> formField = self.fields[indexPath.section];
    return [formField tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<ROFilterField> formField = self.fields[(NSUInteger)indexPath.section];
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
