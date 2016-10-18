//
//  ROImageCrudTableViewCell.m
//  IBMMobileAppBuilder
//

#import "ROImageCrudTableViewCell.h"
#import "ROStyle.h"
#import "UILabel+RO.h"
#import "ROTextStyle.h"

@implementation ROImageCrudTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.label.font = [[ROStyle sharedInstance] font];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.photoImageView];
        
        [self.contentView addSubview:self.label];
        
        [self.contentView addSubview:self.errorLabel];

        NSDictionary *viewsBindings = @{
                                        @"contentView"  : self.contentView,
                                        @"label"        : self.label,
                                        @"image"        : self.photoImageView,
                                        @"error"        : self.errorLabel
                                        };
        
        NSDictionary *metrics = @{
                                  @"margin" : @10,
                                  @"marginImage" : @5,
                                  @"marginLeftImage" : @15,
                                  @"marginRightError" : @16
                                  };

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginLeftImage-[image(80)]-margin-[label]-[error]-marginRightError-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:viewsBindings]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-<=8-[error]"
                                                                                 options:0
                                                                                 metrics:0
                                                                                   views:viewsBindings]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                                 options:0
                                                                                 metrics:0
                                                                                   views:viewsBindings]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-marginImage-[image]-marginImage-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:viewsBindings]];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)label {
    
    if (!_label) {
        _label = [UILabel new];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.font = [[ROStyle sharedInstance] font];
        _label.textColor = [[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.6f];
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

- (UIImageView *)photoImageView {
    
    if (!_photoImageView) {
        _photoImageView = [UIImageView new];
        [_photoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_photoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_photoImageView setClipsToBounds:YES];
    }
    return _photoImageView;
}

@end
