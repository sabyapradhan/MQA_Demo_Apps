//
//  RONotificationView.m
//  IBMMobileAppBuilder
//

#import "RONotificationView.h"

@interface RONotificationView ()

@property (nonatomic, strong) NSMutableArray *mainConstraints;

@property (nonatomic, assign) BOOL didUpdateConstraints;

- (void)setup;

- (void)setupConstraints;

@end

@implementation RONotificationView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (void)updateConstraints {
    
    if (!_didUpdateConstraints) {
        
        [self setupConstraints];
        _didUpdateConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - Private methods

- (void)setup {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    [self addSubview:self.detailTextLabel];
    
    [self updateConstraints];
}

- (void)setupConstraints {
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self removeConstraints:self.mainConstraints];
    
    [self.mainConstraints removeAllObjects];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_imageView, _textLabel, _detailTextLabel);
    
    NSDictionary *metrics = @{
                              @"margin"     : @8,
                              @"marginV"    : @4,
                              @"imageSize"  : @25
                              };
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_imageView(imageSize)]-margin-[_textLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_imageView]-margin-[_detailTextLabel]-margin-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_imageView(imageSize)]"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    
    [self.mainConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-marginV-[_textLabel]-marginV-[_detailTextLabel]-(>=marginV)-|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:metrics
                                                                                        views:viewsBindings]];
    [self addConstraints:self.mainConstraints];
}

#pragma mark - Properties init

- (NSMutableArray *)mainConstraints {

    if (!_mainConstraints) {
    
        _mainConstraints = [NSMutableArray new];
    }
    return _mainConstraints;
}

- (UIImageView *)imageView {

    if (!_imageView) {
    
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 4.0f;
    }
    return _imageView;
}

- (UILabel *)textLabel {

    if (!_textLabel) {
    
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont boldSystemFontOfSize:12];
        _textLabel.textColor = [UIColor whiteColor];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel {

    if (!_detailTextLabel) {
    
        _detailTextLabel = [UILabel new];
        _detailTextLabel.font = [UIFont systemFontOfSize:12];
        _detailTextLabel.numberOfLines = 0;
        _detailTextLabel.textColor = [UIColor whiteColor];
    }
    return _detailTextLabel;
}

@end
