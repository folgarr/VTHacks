//
//  ContactsViewController.h
//  VTHacks
//
//  Created by Vincent Ngo on 4/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) MenuViewController *menuController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
