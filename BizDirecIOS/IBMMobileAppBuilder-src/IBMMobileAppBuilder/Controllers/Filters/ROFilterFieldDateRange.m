//
//  ROFormFieldRange.m
//  IBMMobileAppBuilder
//

#import "ROFilterFieldDateRange.h"
#import "ROStyle.h"
#import "ActionSheetDatePicker.h"
#import "RODateRangeFilter.h"
#import "ROFilterViewController.h"
#import "NSDate+RO.h"

static NSString *const kCellIdentifier  = @"fieldDateRangeCell";

static NSString *const kMin             = @"min";
static NSString *const kMax             = @"max";

@interface ROFilterFieldDateRange ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ROFilterFieldDateRange

- (instancetype)initWithFieldLabel:(NSString *)fieldLabel
                         fieldName:(NSString *)fieldName
                    formController:(ROFilterViewController *)formController
{
    self = [super init];
    if (self) {
        _fieldLabel = fieldLabel;
        _fieldName = fieldName;
        _formController = formController;
        _required = NO;
    }
    return self;
}

+ (instancetype)fieldLabel:(NSString *)fieldLabel
                 fieldName:(NSString *)fieldName
            formController:(ROFilterViewController *)formController
{
    return [[self alloc] initWithFieldLabel:fieldLabel fieldName:fieldName formController:formController];
}

- (NSString *)placeholder
{
    if (!_placeholder) {
        _placeholder = NSLocalizedString(@"Select a date", nil);
    }
    return _placeholder;
}

- (NSString *)fieldValue
{
    NSMutableDictionary *res = [NSMutableDictionary new];
    if (self.minDate) {
        [res setObject:[_dateFormatter stringFromDate:self.minDate] forKey:kMin];
    }
    if (self.maxDate) {
        [res setObject:[_dateFormatter stringFromDate:self.maxDate] forKey:kMax];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:res
                                                       options:kNilOptions
                                                         error:&error];
    
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)setFieldValue:(NSString *)fieldValue
{
    self.minDate = nil;
    self.maxDate = nil;
    if (fieldValue) {
        NSData *jsonData = [fieldValue dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        if (json) {
            self.minDate = [_dateFormatter dateFromString:json[kMin]];
            self.maxDate = [_dateFormatter dateFromString:json[kMax]];
        }
    }
}

- (id)value
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (self.minDate) {
        [dic setObject:self.minDate forKey:kMin];
    }
    if (self.maxDate) {
        [dic setObject:self.maxDate forKey:kMax];
    }
    return dic;
}

- (id<ROFilter>)filter
{
    if (self.minDate || self.maxDate) {
        return [RODateRangeFilter create:self.fieldName minDate:self.minDate maxDate:self.maxDate];
    }
    return nil;
}

- (NSString *)minLabel
{
    if (!_minLabel) {
        _minLabel = NSLocalizedString(@"Starts", nil);
    }
    return _minLabel;
}

- (NSString *)maxLabel
{
    if (!_maxLabel) {
        _maxLabel = NSLocalizedString(@"Ends", nil);
    }
    return _maxLabel;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        //[_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return _dateFormatter;
}

- (void)reset
{
    self.minDate = nil;
    self.maxDate = nil;
}

#pragma mark - UI

- (NSInteger)numberOfRows
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.fieldLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier];
        
        UIView *selectecedView = [[UIView alloc] init];
        selectecedView.backgroundColor = [[ROStyle sharedInstance] selectedColor];
        cell.selectedBackgroundView = selectecedView;
        
        cell.backgroundColor = [[[ROStyle sharedInstance] backgroundColor] colorWithAlphaComponent:0.5f];
        cell.textLabel.font = [[ROStyle sharedInstance] font];
        cell.textLabel.textColor = [[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.8f];
        cell.detailTextLabel.font = [[ROStyle sharedInstance] font];
        cell.detailTextLabel.textColor = [[ROStyle sharedInstance] foregroundColor];
    }
    NSString *label = nil;
    NSString *value = nil;
    if (indexPath.row == 0) {
        label = self.minLabel;
        value = self.minDate ? [self.dateFormatter stringFromDate:self.minDate] : self.placeholder;
    } else if (indexPath.row == 1) {
        label = self.maxLabel;
        value = self.maxDate ? [self.dateFormatter stringFromDate:self.maxDate] : self.placeholder;
    }
    cell.textLabel.text = label;
    cell.detailTextLabel.text = value;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date;
    if (indexPath.row == 0) {
        date = self.minDate;
    } else if (indexPath.row == 1) {
        date = self.maxDate;
    }
    if (!date) {
        date = [NSDate date];
    }
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:date doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        
        if (selectedDate) {
            
            NSDate *dateSel = [selectedDate dateWithoutTime];
            
            if (indexPath.row == 0) {
                self.minDate = dateSel;
            } else if (indexPath.row == 1) {
                self.maxDate = dateSel;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView endUpdates];
                
            });
        }
        
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
        
        
    } origin:self.formController.view];
    
    [datePicker showActionSheetPicker];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
}

@end
