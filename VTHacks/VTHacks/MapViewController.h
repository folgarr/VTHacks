//
//  MapViewController.h
//  VTHacks
//
//  Created by Carlos Folgar on 4/5/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MapViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak)MenuViewController *menuController;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
