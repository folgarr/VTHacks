//
//  AnnoucementViewController.h
//  VTHacks
//
//  Created by Vincent Ngo on 3/1/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "MessageBoard.h"

@interface AnnoucementViewController : UIViewController <UIActionSheetDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
-(void) announceWithSubject:(NSString *)subject andBody:(NSString *)body;
+(void) setSubject:(NSString *)subj andBody:(NSString *)body;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) MenuViewController *menuController;
@property (nonatomic, strong) NSMutableArray *announcementDictionaries;
-(void) reloadAnnouncementsWithInstance:(MessageBoard *)instance;
+(void) setAnnouncementsCache:(NSMutableArray*)dict;
@end
