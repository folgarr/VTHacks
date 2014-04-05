//
//  ScheduleViewController.h
//  VTHacks
//
//  Created by Vincent Ngo on 3/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
@interface ScheduleViewController : UITableViewController <UIScrollViewDelegate>

@property (nonatomic, weak) MenuViewController *menuController;

//Custom Pull Refresh
@property (nonatomic, strong)NSArray *loadingImgs;
@property (nonatomic, strong)NSArray *drawingImgs;

@end
