//
//  Copyright (c) 2015 Applause. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APLCordovaLogging <NSObject>

@property(nonatomic, weak) UIWebView *webView;
@property(nonatomic, strong) id commandDelegate;

- (instancetype)initWithWebView:(UIWebView *)theWebView;

- (void)start:(id)command;

- (void)log:(id)command;

- (void)report:(id)command;

- (void)feedback:(id)command;

- (void)sendFeedback:(id)command;

- (void)crash:(id)command;

@end