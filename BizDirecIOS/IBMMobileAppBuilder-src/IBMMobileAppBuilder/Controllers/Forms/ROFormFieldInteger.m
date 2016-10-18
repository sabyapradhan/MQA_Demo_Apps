//
//  ROFormFieldInteger.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldInteger.h"
#import "ROTextFieldTableViewCell.h"

static NSString *const kIntegerFieldIdentifier  = @"integerFieldIdentifier";

@implementation ROFormFieldInteger

- (NSString *)fieldValue
{
    if ([self.value isKindOfClass:[NSNumber class]]) {
        return [self.value stringValue];
    } else if ([self.value isKindOfClass:[NSString class]]) {
        return self.value;
    }
    return nil;
}

- (id)jsonValue
{
    if ([self.value isKindOfClass:[NSNumber class]]) {
        
        return self.value;
        
    } else if ([self.value isKindOfClass:[NSString class]]) {
        
        return @([self.value integerValue]);
    }
    return [NSNull null];
}

- (BOOL)valid
{
    BOOL isValid = [super valid];
    if (isValid) {
        if ([self.value isKindOfClass:[NSString class]] && [self.value length] != 0) {
            NSScanner *scanner = [NSScanner scannerWithString:self.value];
            BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
            isValid = isNumeric;
            if (!isNumeric) {
                self.cell.errorLabel.text = NSLocalizedString(@"Invalid integer", nil);
            }
        }
    }
    return isValid;
}

- (ROTextFieldTableViewCell *)fieldCell
{
    ROTextFieldTableViewCell *cell = [[ROTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:kIntegerFieldIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
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
