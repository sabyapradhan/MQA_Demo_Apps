//
//  ROFormFieldSelectionMultiple.m
//  IBMMobileAppBuilder
//

#import "ROFilterFieldSelection.h"
#import "ROStringListFilter.h"
#import "ROStyle.h"
#import "ROOptionsViewController.h"
#import "NSBundle+RO.h"
#import "ROFilterViewController.h"

static NSString *const kCellIdentifier  = @"fieldSelectionMultipleCell";

static NSString *const kSeparatorValue  = @", ";

@interface ROFilterFieldSelection ()

@end

@implementation ROFilterFieldSelection

- (instancetype)initWithFieldLabel:(NSString *)fieldLabel
                         fieldName:(NSString *)fieldName
                    formController:(ROFilterViewController *)formController
                            single:(BOOL)single
{
    self = [super init];
    if (self) {
        _fieldLabel = fieldLabel;
        _fieldName = fieldName;
        _formController = formController;
        _single = single;
        _required = NO;
    }
    return self;
}

+ (instancetype)fieldLabel:(NSString *)fieldLabel
                 fieldName:(NSString *)fieldName
            formController:(ROFilterViewController *)formController
                    single:(BOOL)single
{
    return [[self alloc] initWithFieldLabel:fieldLabel
                                  fieldName:fieldName
                             formController:formController
                                     single:single];
}

- (NSString *)placeholder
{
    if (!_placeholder) {
        _placeholder = NSLocalizedString(@"Select option", nil);
    }
    return _placeholder;
}

- (NSString *)fieldValue
{
    if (self.optionsSelected && [self.optionsSelected count] != 0) {
        return [self.optionsSelected componentsJoinedByString:kSeparatorValue];
    }
    return nil;
}

- (id<RODatasource>)datasource {
    
    if (!_datasource) {
        _datasource = self.formController.dataLoader.datasource;
    }
    return _datasource;
}

- (void)setFieldValue:(NSString *)fieldValue
{
    if (fieldValue) {
        self.optionsSelected = [[fieldValue componentsSeparatedByString:kSeparatorValue] mutableCopy];
    } else {
        [self.optionsSelected removeAllObjects];
        self.optionsSelected = nil;
    }
}

- (id<ROFilter>)filter
{
    if (self.optionsSelected && [self.optionsSelected count] != 0) {
        return [ROStringListFilter create:self.fieldName values:self.optionsSelected];
    }
    return nil;
}

- (void)reset
{
    [self.optionsSelected removeAllObjects];
    self.optionsSelected = nil;
}

- (id)value
{
    return self.optionsSelected;
}

#pragma mark - UI

- (NSInteger)numberOfRows
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.fieldLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        
        UIView *selectecedView = [[UIView alloc] init];
        selectecedView.backgroundColor = [[ROStyle sharedInstance] selectedColor];
        cell.selectedBackgroundView = selectecedView;
        
        cell.backgroundColor = [[[ROStyle sharedInstance] backgroundColor] colorWithAlphaComponent:0.5f];
        cell.textLabel.font = [[ROStyle sharedInstance] font];
        cell.textLabel.textColor = [[ROStyle sharedInstance] foregroundColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.optionsSelected ? [self.optionsSelected componentsJoinedByString:kSeparatorValue] : self.placeholder;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ROOptionsViewController *optionsViewController = [ROOptionsViewController new];
    optionsViewController.formFieldSelection = self;
    optionsViewController.dataLoader = self.formController.dataLoader;
    [self.formController.navigationController pushViewController:optionsViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
}

@end
