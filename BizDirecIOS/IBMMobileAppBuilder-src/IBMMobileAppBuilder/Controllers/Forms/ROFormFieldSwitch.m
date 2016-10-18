//
//  ROFormFieldSwitch.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldSwitch.h"
#import "ROSwitchTableViewCell.h"
#import "ROStyle.h"

static NSString *const kSwitchIdentifier = @"switchIdentifier";

@interface ROFormFieldSwitch ()

@property (nonatomic, strong) ROSwitchTableViewCell *cell;

@end

@implementation ROFormFieldSwitch

- (instancetype)initWithLabel:(NSString *)label name:(NSString *)name
{
    self = [super init];
    if (self) {
        _label = label;
        _name = name;
        _value = [NSNumber numberWithBool:NO];
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

- (UISwitch *)check
{
    if (!_check) {
        _check = self.cell.check;
    }
    return _check;
}

- (ROSwitchTableViewCell *)cell
{
    if (!_cell) {
        _cell = [self fieldCell];
    }
    return _cell;
}

- (id)jsonValue
{
    if ([self.value isKindOfClass:[NSNumber class]]) {
        if ([self.value boolValue]) {
            return @YES;
        }
    }
    return @NO;
}

- (BOOL)fieldValue
{
    if ([self.value isKindOfClass:[NSNumber class]]) {
        return [self.value boolValue];
    }
    return NO;
}

- (void)changeSwitch:(id)sender
{
    self.value = [NSNumber numberWithBool:[sender isOn]];
}

- (ROSwitchTableViewCell *)fieldCell
{
    ROSwitchTableViewCell *cell = [[ROSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:kSwitchIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.check addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    self.check = cell.check;
    
    return cell;
}

- (void)reset
{
    self.value = [NSNumber numberWithBool:NO];
    [self.cell.check setOn:NO];
}

#pragma mark - UI

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ROSwitchTableViewCell *cell = self.cell;
    cell.label.text = self.label;
    
    [cell.check setOn:[self fieldValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
}

@end
