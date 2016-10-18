//
//  ROTextFieldTableViewCell.m
//  IBMMobileAppBuilder
//

#import "ROTextFieldTableViewCell.h"
#import "ROStyle.h"
#import "UILabel+RO.h"
#import "ROTextStyle.h"

@implementation ROTextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.textField];
        
        [self.contentView addSubview:self.label];
        
        [self.contentView addSubview:self.errorLabel];
        
        NSDictionary *viewsBindings = @{
                                        @"contentView"  : self.contentView,
                                        @"textField"    : self.textField,
                                        @"label"        : self.label,
                                        @"error"        : self.errorLabel
                                        };
        
        NSDictionary *metrics = @{
                                  @"margin"         : @16
                                  };
        
        // align view from the left and right
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[textField]-margin-|"
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
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-<=8-[label]-4-[textField(==30)]-<=8-|"
                                                                                 options:0
                                                                                 metrics:0
                                                                                   views:viewsBindings]];

    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textField.text = nil;
    self.label.text = nil;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [[ROStyle sharedInstance] foregroundColor];
        _textField.font = [[ROStyle sharedInstance] font];
    }
    return _textField;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel new];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.textColor = [[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.6f];
        _label.font = [[[ROStyle sharedInstance] font] fontWithSize:[[[ROStyle sharedInstance] fontSizeSmall] floatValue]];
    }
    return _label;
}

- (UILabel *)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [UILabel new];
        _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_errorLabel ro_style:[ROTextStyle style:ROFontSizeStyleSmall bold:NO italic:NO textAligment:NSTextAlignmentRight textColor:[UIColor redColor]]];
    }
    return _errorLabel;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
