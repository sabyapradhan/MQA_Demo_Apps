//
//  ROHeaderCellDescriptor.m
//  IBMMobileAppBuilder
//

#import "ROHeaderCellDescriptor.h"
#import "ROTableViewCell.h"
#import "NSString+RO.h"
#import "ROTextStyle.h"
#import "UILabel+RO.h"
#import "ROStyle.h"

static NSString *const kCellIdentifier = @"headerCellIdentifier";

@implementation ROHeaderCellDescriptor

- (instancetype)initWithText:(NSString *)text textStyle:(ROTextStyle *)textStyle {
    
    self = [super self];
    if (self) {
        self.text = text;
        self.textStyle = textStyle ? : [ROTextStyle style:ROFontSizeStyleSmall
                                                     bold:NO
                                                   italic:NO
                                             textAligment:NSTextAlignmentLeft
                                                textColor:[[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.5f]];
    }
    return self;
}

+ (instancetype)text:(NSString *)text textStyle:(ROTextStyle *)textStyle {
    
    return [[self alloc] initWithText:text textStyle:textStyle];
}

- (instancetype)initWithText:(NSString *)text {
    
    return [self initWithText:text textStyle:nil];
}

+ (instancetype)text:(NSString *)text {
    
    return [[self alloc] initWithText:text];
}

- (void)dealloc {
    
    [self receiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ROTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        
        cell = [[ROTableViewCell alloc] initWithROStyle:ROTableViewCellStyleDetailHeader
                                        reuseIdentifier:kCellIdentifier];
        
        cell.userInteractionEnabled = NO;
        [cell.titleLabel ro_style:self.textStyle];
    }
    cell.backgroundColor = [UIColor clearColor];  // Adding this fixes the issue for iPad
    [self configureCell:cell];
    return cell;
}

- (void)receiveMemoryWarning {

}

- (void)configureCell:(ROTableViewCell *)cell {
    
    cell.titleLabel.text = self.text;
}

- (BOOL)isEmpty {
    
    return !(self.text && [[self.text ro_trim] length] != 0);
}

@end
