//
//  AnnoucementViewController.h
//  VTHacks
//
//  Created by Vincent Ngo on 3/1/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface AnnoucementViewController : UITableViewController <UIActionSheetDelegate>
-(void) announceWithSubject:(NSString *)subject andBody:(NSString *)body;
+(void) setSubject:(NSString *)subj andBody:(NSString *)body;

@property (nonatomic, strong) MenuViewController *menuController;

@end
