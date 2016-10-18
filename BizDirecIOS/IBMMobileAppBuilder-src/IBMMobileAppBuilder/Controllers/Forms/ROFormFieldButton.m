//
//  ROFormFieldButton.m
//  IBMMobileAppBuilder
//

#import "ROFormFieldButton.h"
#import "ROStyle.h"

static NSString *const kButtonIdentifier = @"buttonIdentifier";

@implementation ROFormFieldButton

- (instancetype)initWithLabel:(NSString *)label tapBlock:(ROFormFieldButtonTap)tapBlock
{
    self = [super init];
    if (self) {
        _label = label;
        _tapBlock = tapBlock;
    }
    return self;
}

+ (instancetype)fieldWithLabel:(NSString *)label tapBlock:(ROFormFieldButtonTap)tapBlock
{
    return [[self alloc] initWithLabel:label tapBlock:tapBlock];
}

- (BOOL)valid
{
    return YES;
}

- (id)jsonValue
{
    return nil;
}

- (void)reset
{

}

#pragma mark - UI


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kButtonIdentifier];

        UIView *selectecedView = [[UIView alloc] init];
        selectecedView.backgroundColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.1f];
        cell.selectedBackgroundView = selectecedView;
        
        cell.backgroundColor = [[[ROStyle sharedInstance] backgroundColor] colorWithAlphaComponent:0.5f];
        
        cell.textLabel.font = [[ROStyle sharedInstance] font];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = self.label;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tapBlock) {
        self.tapBlock(indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
}


@end
