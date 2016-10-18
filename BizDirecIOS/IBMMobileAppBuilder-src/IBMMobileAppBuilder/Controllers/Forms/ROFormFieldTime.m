//
//  ROFormFieldTime.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldTime.h"
#import "ROTextFieldTableViewCell.h"

static NSString *const kTimeFieldIdentifier     = @"timeFieldIdentifier";

@implementation ROFormFieldTime

- (instancetype)initWithLabel:(NSString *)label name:(NSString *)name required:(BOOL)required
{
    self = [super initWithLabel:label name:name required:required];
    if (self) {
        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        self.datePicker = [UIDatePicker new];
        [self.datePicker setDatePickerMode:UIDatePickerModeTime];
        [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (ROTextFieldTableViewCell *)fieldCell
{
    ROTextFieldTableViewCell *cell = [[ROTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:kTimeFieldIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.inputView = self.datePicker;
    cell.textField.delegate = self;
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
