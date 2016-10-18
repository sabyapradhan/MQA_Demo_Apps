//
//  ROGeoFieldTableViewCell.m
//  IBMMobileAppBuilder
//

#import "ROGeoFieldTableViewCell.h"
#import "ROStyle.h"
#import "UILabel+RO.h"
#import "ROTextStyle.h"
#import "RORestGeoPoint.h"
#import "UIImage+RO.h"

@interface ROGeoFieldTableViewCell ()

@end

@implementation ROGeoFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.latitudeField];
        
        [self.contentView addSubview:self.longitudeField];
        
        [self.contentView addSubview:self.locationButton];
        
        [self.contentView addSubview:self.label];
        
        [self.contentView addSubview:self.errorLabel];
        
        NSDictionary *viewsBindings = @{
                                        @"contentView"      : self.contentView,
                                        @"latitudeField"    : self.latitudeField,
                                        @"longitudeField"   : self.longitudeField,
                                        @"locationButton"   : self.locationButton,
                                        @"label"            : self.label,
                                        @"error"            : self.errorLabel
                                        };
        
        NSDictionary *metrics = @{
                                  @"margin"         : @16,
                                  @"space"          : @4
                                  };
        
        // align view from the left and right
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[latitudeField]-space-[longitudeField(==latitudeField)]-space-[locationButton(==40)]-margin-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:viewsBindings]];
        
        // align view from the left and right
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[label]-[error]-margin-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:viewsBindings]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-<=8-[error]"
                                                                                 options:0
                                                                                 metrics:0
                                                                                   views:viewsBindings]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-<=8-[label]-4-[latitudeField(==30)]-<=8-|"
                                                                                 options:0
                                                                                 metrics:0
                                                                                   views:viewsBindings]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-<=8-[label]-4-[longitudeField(==30)]-<=8-|"
                                                                                 options:0
                                                                                 metrics:0
                                                                                   views:viewsBindings]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-<=8-[label]-0-[locationButton(==40)]|"
                                                                                 options:0
                                                                                 metrics:0
                                                                                   views:viewsBindings]];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.latitudeField.text = nil;
    self.longitudeField.text = nil;
    self.label.text = nil;
}

- (UITextField *)latitudeField {
    
    if (!_latitudeField) {
        _latitudeField = [UITextField new];
        _latitudeField.translatesAutoresizingMaskIntoConstraints = NO;
        _latitudeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _latitudeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _latitudeField.textColor = [[ROStyle sharedInstance] foregroundColor];
        _latitudeField.font = [[ROStyle sharedInstance] font];
    }
    return _latitudeField;
}

- (UITextField *)longitudeField {
    
    if (!_longitudeField) {
        _longitudeField = [UITextField new];
        _longitudeField.translatesAutoresizingMaskIntoConstraints = NO;
        _longitudeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _longitudeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _longitudeField.textColor = [[ROStyle sharedInstance] foregroundColor];
        _longitudeField.font = [[ROStyle sharedInstance] font];
    }
    return _longitudeField;
}

- (UIButton *)locationButton {
    
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.translatesAutoresizingMaskIntoConstraints = NO;
        UIImage *image = [[UIImage ro_imageNamed:@"userLocation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_locationButton setImage:image forState:UIControlStateNormal];
        _locationButton.tintColor = [[ROStyle sharedInstance] foregroundColor];
    }
    return _locationButton;
}

- (UILabel *)label {
    
    if (!_label) {
        _label = [UILabel new];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.textColor = [[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.6f];
        _label.font = [[[ROStyle sharedInstance] font] fontWithSize:[[[ROStyle sharedInstance] fontSizeSmall] floatValue]];
    }
    return _label;
}

- (UILabel *)errorLabel {
    
    if (!_errorLabel) {
        _errorLabel = [UILabel new];
        _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_errorLabel ro_style:[ROTextStyle style:ROFontSizeStyleSmall bold:NO italic:NO textAligment:NSTextAlignmentRight textColor:[UIColor redColor]]];
    }
    return _errorLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
