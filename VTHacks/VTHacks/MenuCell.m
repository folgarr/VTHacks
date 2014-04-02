//
//  MenuCell.m
//  VTHacks
//
//  Created by Vincent Ngo on 4/1/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)animateCellWithStyle: (CCAnimationStyle)style completion:(void (^)(BOOL finished))completed
{
    switch (style) {
        case CCAnimationStyleRubberBand:
        {
            [self performCCAnimationRubberbandWithCompletion:^(BOOL finished) {
                completed(YES);
            }];
            break;
        }
        case CCAnnimationStyleScale:
        {
            [self performCCAnimationScaleWithCompletion:^(BOOL finished) {
                completed(YES);
            }];
            break;
        }
    }
}

#pragma mark - CCAnimationStyle animation completion blocks.

- (void)performCCAnimationScaleWithCompletion:(void (^)(BOOL finished))completed
{
    [UIView animateWithDuration:0.2 animations:^{
        self.iconLabel.transform = CGAffineTransformMakeScale(1.5,1.5);
        self.titleLabel.transform = CGAffineTransformMakeScale(1.5,1.5);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconLabel.transform = CGAffineTransformMakeScale(1.0,1.0);
            self.titleLabel.transform = CGAffineTransformMakeScale(1.0,1.0);
            
        } completion:^(BOOL finished) {
            completed(YES);
        }];
    }];
    
}

- (void)performCCAnimationRubberbandWithCompletion:(void (^)(BOOL finished))completed
{
    //http://stackoverflow.com/questions/10548307/animatewithduration-completes-immediately
    //Instead of changing frame.origin.x
    CGPoint originalCenter = self.titleLabel.center;
    CGPoint iconCenter = self.iconLabel.center;
    
    CGPoint titleSlideAwayCenter = originalCenter;
    titleSlideAwayCenter.x += self.frame.size.height;
    CGPoint iconSlideAwayCenter = iconCenter;
    iconSlideAwayCenter.x -= self.frame.size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.titleLabel.center = titleSlideAwayCenter;
        self.iconLabel.center = iconSlideAwayCenter;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.titleLabel.center = originalCenter;
            self.iconLabel.center = iconCenter;
        } completion:^(BOOL finished) {
            completed(YES);
        }];
    }];
}


@end
