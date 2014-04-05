//
//  ContactsViewController.h
//  VTHacks
//
//  Created by Vincent Ngo on 4/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) MenuViewController *menuController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
