//
//  ROPhotoTitleCollectionViewCell.m
//  IBMMobileAppBuilder
//

#import "ROPhotoTitleCollectionViewCell.h"
#import "ROTextStyle.h"
#import "ROStyle.h"
#import "UILabel+RO.h"

@interface ROPhotoTitleCollectionViewCell ()

@property (nonatomic, strong) NSMutableArray *mainConstraints;

@end

@implementation ROPhotoTitleCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Properties init

- (UILabel *)titleLabel {

    if (!_titleLabel) {
    
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
        [_titleLabel ro_style:[ROTextStyle style:ROFontSizeStyleSmall
                                            bold:NO
                                          italic:NO
                                    textAligment:NSTextAlignmentCenter]];
    }
    return _titleLabel;
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
    [self.contentView addSubview:self.photoImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectedImageView];
    
    UIView *selectecedView = [[UIView alloc] init];
    selectecedView.backgroundColor = [[ROStyle sharedInstance] selectedColor];
    self.selectedBackgroundView = selectecedView;
    
    [self updateConstraints];
}

- (void)setupConstraints {
    
    [self.contentView removeConstraints:self.mainConstraints];
    [self.mainConstraints removeAllObjects];
    
    self.photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectedImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsBindings = @{
                                    @"photoImageView"       : self.photoImageView,
                                    @"titleLabel"           : self.titleLabel,
                                    @"selectedImageView"    : self.selectedImageView
                                    };
    
    NSDictionary *metrics = @{
                              @"marginH"        : @18,
                              @"marginV"        : @0,
                              @"titleHeight"    : @35,
                              @"marginSelected" : @8,
                              @"checkSize"      : @20
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginH-[photoImageView]-marginH-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];

    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginH-[titleLabel]-marginH-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-marginV-[photoImageView]-marginV-[titleLabel(titleHeight)]-marginV-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectedImageView(checkSize)]-marginSelected-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[selectedImageView(checkSize)]-marginSelected-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.contentView addConstraints:self.mainConstraints];
}

@end
