//
//  ROGeoFieldTableViewCell.h
//  IBMMobileAppBuilder
//

#import <UIKit/UIKit.h>

@interface ROGeoFieldTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UITextField *latitudeField;

@property (nonatomic, strong) UITextField *longitudeField;

@property (nonatomic, strong) UILabel *errorLabel;

@property (nonatomic, strong) UIButton *locationButton;

@end
