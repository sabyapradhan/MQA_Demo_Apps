//
//  ROCellDescriptor.h
//  IBMMobileAppBuilder
//

#import <Foundation/Foundation.h>

@protocol ROCellDescriptor <NSObject>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)receiveMemoryWarning;

- (BOOL)isEmpty;

@optional

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
