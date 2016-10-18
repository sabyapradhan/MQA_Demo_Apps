//
//  ROFormFieldDatetime.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldDatetime.h"
#import "ROTextFieldTableViewCell.h"

static NSString *const kDatetimeFieldIdentifier = @"datetimeFieldIdentifier";

@implementation ROFormFieldDatetime

- (instancetype)initWithLabel:(NSString *)label name:(NSString *)name required:(BOOL)required
{
    self = [super initWithLabel:label name:name required:required];
    if (self) {
        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        self.datePicker = [UIDatePicker new];
        [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (ROTextFieldTableViewCell *)fieldCell
{
    ROTextFieldTableViewCell *cell = [[ROTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:kDatetimeFieldIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.delegate = self;
    cell.textField.inputView = self.datePicker;
    self.textField = cell.textField;
    return cell;
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
