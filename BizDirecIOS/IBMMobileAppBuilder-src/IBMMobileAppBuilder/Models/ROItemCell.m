//
//  ROItemCell.m
//  IBMMobileAppBuilder
//

#import "ROItemCell.h"

@implementation ROItemCell

- (id)initWithText1:(NSString *)text1
{
    self = [self initWithText1:text1 atText2:nil atImageResource:nil atImageUrl:nil];
    if (self) {

    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atAction:(NSObject<ROAction> *)action
{
    self = [self initWithText1:text1 atText2:nil atImageResource:nil atImageUrl:nil atAction:action];
    if (self) {
        
    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2
{
    self = [self initWithText1:text1 atText2:text2 atImageResource:nil atImageUrl:nil];
    if (self) {

    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atAction:(NSObject<ROAction> *)action
{
    self = [self initWithText1:text1 atText2:text2 atImageResource:nil atImageUrl:nil atAction:action];
    if (self) {
        
    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atImageResource:(NSString *)imageResource
{
    self = [self initWithText1:text1 atText2:nil atImageResource:imageResource atImageUrl:nil];
    if (self) {

    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atImageResource:(NSString *)imageResource atAction:(NSObject<ROAction> *)action
{
    self = [self initWithText1:text1 atText2:nil atImageResource:imageResource atImageUrl:nil atAction:action];
    if (self) {
        
    }
    return self;
}

- (id)initWithImageResource:(NSString *)imageResource
{
    self = [self initWithText1:nil atText2:nil atImageResource:imageResource atImageUrl:nil atAction:nil];
    if (self) {
        
    }
    return self;
}

- (id)initWithImageResource:(NSString *)imageResource atAction:(NSObject<ROAction> *)action
{
    self = [self initWithText1:nil atText2:nil atImageResource:imageResource atImageUrl:nil atAction:action];
    if (self) {
        
    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageResource:(NSString *)imageResource
{
    self = [self initWithText1:text1 atText2:text2 atImageResource:imageResource atImageUrl:nil];
    if (self) {
        
    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageResource:(NSString *)imageResource atAction:(NSObject<ROAction> *)action
{
    self = [self initWithText1:text1 atText2:text2 atImageResource:imageResource atImageUrl:nil atAction:action];
    if (self) {
        
    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageUrl:(NSString *)imageUrl
{
    self = [self initWithText1:text1 atText2:text2 atImageResource:nil atImageUrl:imageUrl];
    if (self) {

    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageUrl:(NSString *)imageUrl atAction:(NSObject<ROAction> *)action
{
    self = [self initWithText1:text1 atText2:text2 atImageResource:nil atImageUrl:imageUrl atAction:action];
    if (self) {
        
    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageResource:(NSString *)imageResource atImageUrl:(NSString *)imageUrl
{
    self = [self initWithText1:text1 atText2:text2 atImageResource:imageResource atImageUrl:imageUrl atAction:nil];
    if (self) {

    }
    return self;
}

- (id)initWithImageUrl:(NSString *)imageUrl atAction:(NSObject<ROAction> *)action
{
    self = [self initWithText1:nil atText2:nil atImageResource:nil atImageUrl:imageUrl atAction:action];
    if (self) {
        
    }
    return self;
}

- (id)initWithImageUrl:(NSString *)imageUrl
{
    self = [self initWithText1:nil atText2:nil atImageResource:nil atImageUrl:imageUrl atAction:nil];
    if (self) {
        
    }
    return self;
}

- (id)initWithText1:(NSString *)text1 atText2:(NSString *)text2 atImageResource:(NSString *)imageResource atImageUrl:(NSString *)imageUrl atAction:(NSObject<ROAction> *)action
{
    self = [self init];
    if (self) {
        _text1 = text1;
        _text2 = text2;
        _imageResource = imageResource;
        _imageUrl = imageUrl;
        _action = action;
    }
    return self;
}

- (BOOL)isEmpty
{
    return !(_text1 || _text2 || _imageResource || _imageUrl);
}

@end
