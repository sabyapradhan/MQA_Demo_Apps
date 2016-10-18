//
//  ROSwitchTableViewCell.m
//  IBMMobileAppBuilder
//

#import "ROSwitchTableViewCell.h"
#import "ROStyle.h"

@implementation ROSwitchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.label.font = [[ROStyle sharedInstance] font];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.label];
        
        [self.contentView addSubview:self.check];
        
        NSDictionary *viewsBindings = @{
                                        @"contentView"  : self.contentView,
                                        @"label"        : self.label,
                                        @"check"        : self.check
                                        };
        
        NSDictionary *metrics = @{
                                  @"margin" : @16,
                                  @"marginCheck" : @6
                                  };
        
        // align view from the left and right
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[label]-margin-[check]-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:viewsBindings]];
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                                 options:0
                                                                                 metrics:0
                                                                                   views:viewsBindings]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-marginCheck-[check]-marginCheck-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:viewsBindings]];
        
    }
    return self;
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

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel new];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.font = [[ROStyle sharedInstance] font];
        _label.textColor = [[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.6f];
    }
    return _label;
}

- (UISwitch *)check
{
    if (!_check) {
        _check = [UISwitch new];
        _check.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _check;
}

@end
