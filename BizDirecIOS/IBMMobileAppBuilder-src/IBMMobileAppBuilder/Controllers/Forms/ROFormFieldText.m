//
//  ROFormFieldText.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldText.h"
#import "ROTextFieldTableViewCell.h"

static NSString *const kTextFieldIdentifier     = @"textFieldIdentifier";

@interface ROFormFieldText ()

@end

@implementation ROFormFieldText

- (instancetype)initWithLabel:(NSString *)label name:(NSString *)name required:(BOOL)required
{
    self = [super init];
    if (self) {
        _label = label;
        _name = name;
        _required = required;
    }
    return self;
}

+ (instancetype)fieldWithLabel:(NSString *)label name:(NSString *)name required:(BOOL)required
{
    return [[self alloc] initWithLabel:label name:name required:required];
}

- (void)dealloc
{
    if (_label) {
        _label = nil;
    }
    if (_name) {
        _name = nil;
    }
    if (_value) {
        _value = nil;
    }
    if (_placeHolder) {
        _placeHolder = nil;
    }
    if (_textField) {
        _textField = nil;
    }
}

- (NSString *)fieldValue
{
    return [self.value description];
}

- (id)jsonValue
{
    if (self.value) {
        return [self.value description];
    }
    return [NSNull null];
}

- (UITextField *)textField
{
    return self.cell ? self.cell.textField : nil;
}

- (ROTextFieldTableViewCell *)cell
{
    if (!_cell) {
        _cell = [self fieldCell];
    }
    return _cell;
}

- (ROTextFieldTableViewCell *)fieldCell
{
    ROTextFieldTableViewCell *cell = [[ROTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:kTextFieldIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    cell.textField.delegate = self;
    cell.textField.returnKeyType = UIReturnKeyDefault;
    self.textField = cell.textField;
    return cell;
}

- (BOOL)valid
{    
    BOOL isValid = YES;
    self.cell.errorLabel.text = nil;
    if (self.required) {
        if (self.value == nil) {
            isValid = NO;
        } else if ([self.value isKindOfClass:[NSString class]]) {
            if ([self.value length] == 0) {
                isValid = NO;
            }
        }
    }
    if (!isValid) {
        self.cell.errorLabel.text = NSLocalizedString(@"Required", nil);
    }
    return isValid;
}

- (void)reset
{
    self.value = nil;
    self.textField.text = nil;
    self.cell.errorLabel.text = nil;
}

#pragma mark - Text field

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.value = textField.text;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.value = nil;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textField becomeFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}

@end
