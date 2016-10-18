//
//  ROPhotoCollectionViewCell.m
//  IBMMobileAppBuilder
//

#import "ROPhotoCollectionViewCell.h"
#import "ROStyle.h"
#import "UIImage+RO.h"

@interface ROPhotoCollectionViewCell ()

@property (nonatomic, assign) BOOL didUpdateConstraints;

@property (nonatomic, strong) NSMutableArray *mainConstraints;

@end

@implementation ROPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    
    id view = [self superview];
    
    while (view && [view isKindOfClass:[UICollectionView class]] == NO) {
        view = [view superview];
    }
    
    UICollectionView *collection = (UICollectionView *)view;
    
    [super setSelected:selected];
    
    [self setUserInteractionEnabled:YES];
    
    if ([collection allowsMultipleSelection]) {
        
        self.selectedImageView.hidden = !selected;
    }
}

#pragma mark - Private methods

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

- (UIImageView *)selectedImageView {

    if (!_selectedImageView) {
    
        _selectedImageView = [[UIImageView alloc] initWithImage:[[UIImage ro_imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        _selectedImageView.hidden = YES;
        _selectedImageView.clipsToBounds = YES;
        _selectedImageView.contentMode = UIViewContentModeCenter;
        _selectedImageView.layer.cornerRadius = 10;
        _selectedImageView.tintColor = [[ROStyle sharedInstance] applicationBarTextColor];
        _selectedImageView.backgroundColor = [[ROStyle sharedInstance] applicationBarBackgroundColor];
    }
    return _selectedImageView;
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
    self.selectedImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsBindings = @{
                                    @"photoImageView"       : self.photoImageView,
                                    @"selectedImageView"    : self.selectedImageView
                                    };
    
    NSDictionary *metrics = @{
                              @"margin"         : @0,
                              @"marginSelected" : @8,
                              @"checkSize"      : @20
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[photoImageView]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[photoImageView]-margin-|"
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
