//
//  ROFormFieldDecimal.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldDecimal.h"
#import "ROTextFieldTableViewCell.h"
#import "NSNumber+RO.h"
#import "NSDecimalNumber+RO.h"

static NSString *const kDecimalFieldIdentifier  = @"decimalFieldIdentifier";

@implementation ROFormFieldDecimal

- (NSString *)fieldValue
{
    if ([self.value isKindOfClass:[NSNumber class]]) {
        return [self.value ro_stringValue];
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
        
        return [NSDecimalNumber ro_decimalNumberWithString:self.value];
    }
    return [NSNull null];
}

- (ROTextFieldTableViewCell *)fieldCell
{
    ROTextFieldTableViewCell *cell = [[ROTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:kDecimalFieldIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    cell.textField.delegate = self;
    cell.textField.returnKeyType = UIReturnKeyDefault;
    self.textField = cell.textField;
    return cell;
}

- (BOOL)valid
{
    BOOL valid = [super valid];
    if (valid) {
        if ([self.value isKindOfClass:[NSString class]] && [self.value length] != 0) {
            NSScanner *scanner = [NSScanner scannerWithString:self.value];
            BOOL isNumeric = [scanner scanDouble:NULL] && [scanner isAtEnd];
            valid = isNumeric;
            if (!isNumeric) {
                self.cell.errorLabel.text = NSLocalizedString(@"Invalid decimal", nil);
            }
        }
    }
    return valid;
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
