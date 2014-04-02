//
//  VVNTransparentView.h
//  TransparentMenu
//
//  Created by Vincent Ngo on 3/7/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "VVNTransparentView.h"

//Constants
#define kDefaultBackgroundColor [UIColor colorWithWhite:0.0 alpha:0.9];
#define kDurationToOpenView 0.3
#define kDurationToCloseView 0.3

@interface VVNTransparentView()

@end

@implementation VVNTransparentView

#pragma mark - Init methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        //Need to set opaque to no to become transparent.
        self.opaque = NO;
        self.backgroundColor = kDefaultBackgroundColor;
    }
    return self;
}


#pragma mark - Method Transitions

//Open the transparent view.
- (void)showView
{
    [self createCloseButton];
    [self fadeInView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

//Close the transparent view.
- (void)closeView
{
    [self fadeOutView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    //Remove View.
    [self removeFromSuperview];
}


#pragma mark - Creating UI Components

- (void)createCloseButton
{
    // Close button
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.center = self.center;
    [close addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:close];
    
    close.contentMode = UIViewContentModeScaleAspectFit;
    [close setImage:[UIImage imageNamed:@"exitIcon"] forState:UIControlStateNormal];
    close.frame = CGRectMake(0, 0, 50, 50);
    close.center = self.center;
    CGRect frame = close.frame;
    frame.origin.y = self.frame.size.height - 100;
    [close setFrame:frame];

    //TODO: Autolayout Autoresizing abilities.
}

#pragma mark - View Transition Animations

- (void)fadeInView
{
    //Reference to the main window.
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    //Check to see if window is nil for sanity.
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    CATransition *fadeIn = [CATransition animation];
    [fadeIn setDuration:kDurationToOpenView];
    [fadeIn setType:kCATransitionReveal];
    [fadeIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[self layer] addAnimation:fadeIn forKey:kCATransitionReveal];
    
    //We want to place this view at the very front.
    [[[window subviews] objectAtIndex:0] addSubview:self];
}

- (void)fadeOutView
{
    // Animation
    CATransition *fadeOut = [CATransition animation];
    
    [fadeOut setDuration:kDurationToCloseView];
    [fadeOut setType:kCATransitionFade];
    [fadeOut setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.superview layer] addAnimation:fadeOut forKey:kCATransitionFade];
}


@end
