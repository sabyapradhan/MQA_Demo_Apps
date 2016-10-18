//
//  ROTableViewCell.m
//  IBMMobileAppBuilder
//

#import "ROTableViewCell.h"
#import "ROStyle.h"
#import "ROTextStyle.h"
#import "UILabel+RO.h"

@interface ROTableViewCell ()

@property (nonatomic, assign) BOOL didUpdateConstraints;

@property (nonatomic, strong) NSMutableArray *mainConstraints;

- (void)styleTitle;

- (void)stylePhotoTitle;

- (void)styleTitleDescription;

- (void)stylePhotoTitleDescription;

- (void)stylePhotoTitleBottomDescription;

- (void)styleDetailText;

- (void)styleDetailImage;

- (void)styleDetailHeader;

@end

@implementation ROTableViewCell

- (instancetype)initWithROStyle:(ROTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _cellStyle = style;
        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
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

- (void)updateConstraints {
    
    if (!_didUpdateConstraints) {
        _didUpdateConstraints = YES;
        [self setupConstraints];
    }
    [super updateConstraints];
}

#pragma mark - Properties init

- (UIImageView *)photoImageView {
    
    if (!_photoImageView) {
        _photoImageView = [UIImageView new];
        _photoImageView.clipsToBounds = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _photoImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
    }
    return _detailLabel;
}

- (NSMutableArray *)mainConstraints {
    
    if (!_mainConstraints) {
        _mainConstraints = [NSMutableArray new];
    }
    return _mainConstraints;
}

#pragma mark - Public methods

- (void)setup {
    
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    
    ROTextStyle *textStyle = [ROTextStyle style:ROFontSizeStyleMedium
                                           bold:NO
                                         italic:NO
                                   textAligment:NSTextAlignmentLeft];
    
    switch (self.cellStyle) {
            
        case ROTableViewCellStyleTitleDescription: {

            [self.titleLabel ro_style:textStyle];
            self.titleLabel.numberOfLines = 2;
            [self.contentView addSubview:self.titleLabel];
            
            [self.detailLabel ro_style:textStyle];
            self.detailLabel.numberOfLines = 2;
            [self.contentView addSubview:self.detailLabel];
            break;
        }
        case ROTableViewCellStylePhotoTitle: {
            
            [self.contentView addSubview:self.photoImageView];
            
            [self.titleLabel ro_style:textStyle];
            self.titleLabel.numberOfLines = 2;
            [self.contentView addSubview:self.titleLabel];
            break;
        }
        case ROTableViewCellStyleDetailImage:
            [self.contentView addSubview:self.photoImageView];
            break;
            
        case ROTableViewCellStylePhotoTitleDescription: {
        
            [self.contentView addSubview:self.photoImageView];
            
            [self.titleLabel ro_style:textStyle];
            self.titleLabel.numberOfLines = 2;
            [self.contentView addSubview:self.titleLabel];
            
            [self.detailLabel ro_style:textStyle];
            self.detailLabel.numberOfLines = 2;
            [self.contentView addSubview:self.detailLabel];
            break;
        }
        case ROTableViewCellStylePhotoTitleBottomDescription: {
            
            [self.contentView addSubview:self.photoImageView];
            
            [self.titleLabel ro_style:textStyle];
            self.titleLabel.numberOfLines = 2;
            [self.contentView addSubview:self.titleLabel];
            
            [self.detailLabel ro_style:textStyle];
            self.titleLabel.numberOfLines = 4;
            [self.contentView addSubview:self.detailLabel];
            break;
        }
        case ROTableViewCellStyleDetailText:
        case ROTableViewCellStyleDetailHeader: {
            
            [self.titleLabel ro_style:textStyle];
            self.titleLabel.numberOfLines = 0;
            [self.contentView addSubview:self.titleLabel];
            break;
        }
        case ROTableViewCellStyleTitle:
        default: {
            
            [self.titleLabel ro_style:textStyle];
            self.titleLabel.numberOfLines = 1;
            [self.contentView addSubview:self.titleLabel];
            break;
        }
    }
    
    UIView *selectecedView = [[UIView alloc] init];
    selectecedView.backgroundColor = [[ROStyle sharedInstance] selectedColor];
    self.selectedBackgroundView = selectecedView;
    
    [self updateConstraints];
}

- (void)setupConstraints {
    
    [self.contentView removeConstraints:self.mainConstraints];
    [self.mainConstraints removeAllObjects];
    
    switch (self.cellStyle) {
            
        case ROTableViewCellStyleTitleDescription:
            [self styleTitleDescription];
            break;
            
        case ROTableViewCellStylePhotoTitle:
            [self stylePhotoTitle];
            break;
            
        case ROTableViewCellStyleDetailImage:
            [self styleDetailImage];
            break;
            
        case ROTableViewCellStylePhotoTitleDescription:
            [self stylePhotoTitleDescription];
            break;
            
        case ROTableViewCellStylePhotoTitleBottomDescription:
            [self stylePhotoTitleBottomDescription];
            break;
            
        case ROTableViewCellStyleTitle:
            [self styleTitle];
            break;
            
        case ROTableViewCellStyleDetailText:
            [self styleDetailText];
            break;
            
        case ROTableViewCellStyleDetailHeader:
            [self styleDetailHeader];
            break;
            
        default:
            [self styleTitle];
            break;
    }
}

#pragma mark - Private methods

- (void)styleTitle {
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsBindings = @{
                                    @"titleLabel" : self.titleLabel
                                    };
    
    NSDictionary *metrics = @{
                              @"margin" : @16
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[titleLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[titleLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    [self.contentView addConstraints:self.mainConstraints];
    
}

- (void)stylePhotoTitle {
    
    self.photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsBindings = @{
                                    @"photoImageView" : self.photoImageView,
                                    @"titleLabel"       : self.titleLabel
                                    };
    
    NSDictionary *metrics = @{
                              @"imageSize"  : @32,
                              @"margin"     : @16
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[photoImageView(imageSize)]-margin-[titleLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    // Add priority 999 to fix warnings
    // http://stackoverflow.com/questions/28410309/strange-uiview-encapsulated-layout-height-error
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[photoImageView(imageSize@999)]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.contentView addConstraints:self.mainConstraints];
    
}

- (void)styleTitleDescription {
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsBindings = @{
                                    @"titleLabel"   : self.titleLabel,
                                    @"detailLabel"  : self.detailLabel
                                    };
    
    NSDictionary *metrics = @{
                              @"margin"         : @16,
                              @"marginInter"    : @4
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[titleLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[titleLabel]-marginInter-[detailLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObject:[NSLayoutConstraint constraintWithItem:self.detailLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.mainConstraints addObject:[NSLayoutConstraint constraintWithItem:self.detailLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.contentView addConstraints:self.mainConstraints];
}

- (void)stylePhotoTitleDescription {
    
    self.photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsBindings = @{
                                    @"photoImageView" : _photoImageView,
                                    @"titleLabel"       : _titleLabel,
                                    @"detailLabel"      : _detailLabel
                                    };
    
    NSDictionary *metrics = @{
                              @"imageSize"  : @66,
                              @"margin"     : @16
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[photoImageView(imageSize)]-margin-[titleLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[photoImageView(imageSize@999)]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObject:[NSLayoutConstraint constraintWithItem:self.detailLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.mainConstraints addObject:[NSLayoutConstraint constraintWithItem:self.detailLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    
    [self.mainConstraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.photoImageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.mainConstraints addObject:[NSLayoutConstraint constraintWithItem:self.detailLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.photoImageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.contentView addConstraints:self.mainConstraints];
}

- (void)stylePhotoTitleBottomDescription {
    
    self.photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsBindings = @{
                                    @"photoImageView" : _photoImageView,
                                    @"titleLabel"       : _titleLabel,
                                    @"detailLabel"      : _detailLabel
                                    };
    
    NSDictionary *metrics = @{
                              @"imageSize"      : @66,
                              @"margin"         : @16,
                              @"marginInter"    : @8
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[photoImageView(imageSize)]-margin-[titleLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    // Add priority 999 to fix warnings
    // http://stackoverflow.com/questions/28410309/strange-uiview-encapsulated-layout-height-error
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[photoImageView(imageSize@999)]-marginInter-[detailLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[detailLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.photoImageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.contentView addConstraints:self.mainConstraints];
}

- (void)styleDetailText {
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsBindings = @{
                                    @"titleLabel" : self.titleLabel
                                    };
    
    NSDictionary *metrics = @{
                              @"marginH"        : @16,
                              @"marginVtop"     : @8,
                              @"marginVbottom"  : @8,
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginH-[titleLabel]-marginH-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-marginVtop-[titleLabel]-marginVbottom-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    [self.contentView addConstraints:self.mainConstraints];
}

- (void)styleDetailImage {
    
    self.photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSDictionary *viewsBindings = @{
                                    @"photoImageView" : self.photoImageView
                                    };
    
    NSDictionary *metrics = @{
                              @"margin" : @0
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[photoImageView]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[photoImageView]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    [self.contentView addConstraints:self.mainConstraints];
}

- (void)styleDetailHeader {
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsBindings = @{
                                    @"titleLabel" : self.titleLabel
                                    };
    
    NSDictionary *metrics = @{
                              @"marginH"        : @16,
                              @"marginVtop"     : @8,
                              @"marginVbottom"  : @4,
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginH-[titleLabel]-marginH-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-marginVtop-[titleLabel]-marginVbottom-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    [self.contentView addConstraints:self.mainConstraints];
}

@end
