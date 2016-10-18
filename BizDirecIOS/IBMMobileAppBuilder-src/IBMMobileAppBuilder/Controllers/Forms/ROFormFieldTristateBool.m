//
//  ROFormFieldBoolNullable.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldTristateBool.h"
#import "ROStyle.h"
#import "ActionSheetStringPicker.h"

static NSString *const kBoolNullableIdentifier = @"boolNullableIdentifier";

@interface ROFormFieldTristateBool ()

@property (nonatomic, strong) NSArray *options;

@end

@implementation ROFormFieldTristateBool

- (instancetype)initWithLabel:(NSString *)label name:(NSString *)name
{
    self = [super init];
    if (self) {
        _label = label;
        _name = name;
        _options = [NSArray arrayWithObjects:
                    NSLocalizedString(@"No", nil),
                    NSLocalizedString(@"Yes", nil),
                    NSLocalizedString(@"Not set", nil),
                    nil];
    }
    return self;
}

+ (instancetype)fieldWithLabel:(NSString *)label name:(NSString *)name
{
    return [[self alloc] initWithLabel:label name:name];
}

- (BOOL)valid
{
    return YES;
}

- (id)jsonValue
{
    if ([self.value isKindOfClass:[NSNumber class]]) {
        if ([self.value boolValue]) {
            return @YES;
        }
        return @NO;
    }
    return [NSNull null];
}

- (NSString *)fieldValue
{
    NSString *stringValue;
    if (self.value != nil && self.value != [NSNull null]) {
        stringValue = self.options[[self.value integerValue]];
    } else {
        stringValue = self.options[2];
    }
    return stringValue;
}

- (UITableViewCell *)fieldCell
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                    reuseIdentifier:kBoolNullableIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectecedView = [[UIView alloc] init];
    selectecedView.backgroundColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.1f];
    cell.selectedBackgroundView = selectecedView;
    cell.textLabel.font = [[ROStyle sharedInstance] font];
    cell.detailTextLabel.font = [[ROStyle sharedInstance] font];
    cell.textLabel.textColor = [[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.6f];
    cell.detailTextLabel.textColor = [[ROStyle sharedInstance] foregroundColor];
    return cell;
}

- (void)reset
{
    self.value = [NSNull null];
}

- (UITableViewCell *)cell
{
    if (!_cell) {
        _cell = [self fieldCell];
    }
    return _cell;
}

#pragma mark - UI

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cell;
    cell.textLabel.text = self.label;
    cell.detailTextLabel.text = [self fieldValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView endEditing:YES];
    
    [ActionSheetStringPicker showPickerWithTitle:nil
                                            rows:self.options
                                initialSelection: self.value != nil && self.value != [NSNull null] ? [self.value integerValue] : 2
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           if (selectedIndex == 2) {
                                               self.value = [NSNull null];
                                           } else {
                                               self.value = [NSNumber numberWithInteger:selectedIndex];
                                           }
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                               
                                           });
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         
                                     }
                                          origin:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
}

@end
