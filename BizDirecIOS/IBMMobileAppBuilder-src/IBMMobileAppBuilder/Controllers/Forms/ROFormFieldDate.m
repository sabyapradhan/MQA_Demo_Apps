//
//  ROFormFieldDate.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldDate.h"
#import "ROTextFieldTableViewCell.h"

static NSString *const kDateFieldIdentifier     = @"dateFieldIdentifier";

static NSString *const kDateFormat_ISO8601      = @"yyyy-MM-dd'T'HH:mm:ss.sss'Z'";

@implementation ROFormFieldDate

- (instancetype)initWithLabel:(NSString *)label name:(NSString *)name required:(BOOL)required
{
    self = [super initWithLabel:label name:name required:required];
    if (self) {
        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        self.datePicker = [UIDatePicker new];
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (NSString *)jsonDateFormat
{
    if (!_jsonDateFormat) {
        _jsonDateFormat = kDateFormat_ISO8601;
    }
    return _jsonDateFormat;
}

- (NSString *)fieldValue
{
    if ([self.value isKindOfClass:[NSDate class]]) {
        return  [self.dateFormatter stringFromDate:self.value];
    }
    return nil;
}

- (id)jsonValue
{
    if ([self.value isKindOfClass:[NSDate class]]) {
        NSDateFormatter *jsonDateFormatter = [NSDateFormatter new];
        [jsonDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [jsonDateFormatter setDateFormat:self.jsonDateFormat];
        return [jsonDateFormatter stringFromDate:self.value];
    }
    return [NSNull null];
}

- (ROTextFieldTableViewCell *)fieldCell
{
    ROTextFieldTableViewCell *cell = [[ROTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:kDateFieldIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.delegate = self;
    cell.textField.inputView = self.datePicker;    
    self.textField = cell.textField;
    return cell;
}

- (void)dateChanged:(UIDatePicker *)datePicker
{
    self.value = datePicker.date;
    self.textField.text = [self fieldValue];
}

#pragma mark - Text field

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.value = self.datePicker.date;
    self.textField.text = [self fieldValue];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

#pragma mark - UI

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ROTextFieldTableViewCell *cell = self.cell;
    self.datePicker.date = self.value ? : [NSDate date];
    cell.label.text = self.label;
    cell.textField.placeholder = self.placeHolder ? : self.label;
    cell.textField.text = [self fieldValue];
    cell.textField.tag = indexPath.row;
    return cell;
}

@end
