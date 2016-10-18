//
//  ROFormFieldPassword.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldPassword.h"
#import "ROTextFieldTableViewCell.h"

static NSString *const kPasswordFieldIdentifier = @"passwordFieldIdentifier";

@implementation ROFormFieldPassword

- (ROTextFieldTableViewCell *)fieldCell
{
    ROTextFieldTableViewCell *cell = [[ROTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:kPasswordFieldIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    cell.textField.secureTextEntry = YES;
    cell.textField.delegate = self;
    cell.textField.returnKeyType = UIReturnKeyDefault;
    self.textField = cell.textField;    
    return cell;
}

#pragma mark - UI

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ROTextFieldTableViewCell *cell = self.cell;
    cell.label.text = self.label;
    cell.textField.placeholder = self.placeHolder ? : self.label;
    cell.textField.text = [self fieldValue];
    cell.textField.tag = indexPath.row;
    return cell;
}

@end
