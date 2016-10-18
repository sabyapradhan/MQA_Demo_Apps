//
//  ROFormField.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@protocol ROFormFieldDelegate <NSObject>

- (NSString *)name;

- (id)value;

- (void)setValue:(id)value;

- (id)jsonValue;

- (BOOL)valid;

- (void)reset;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
