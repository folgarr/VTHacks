//
//  MenuViewController.h
//  VTHacks
//
//  Created by Vincent Ngo on 4/1/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>



@end

#pragma mark - UIViewController(SWRevealViewController) Category
// We add a category of UIViewController to let childViewControllers easily access their parent SWRevealViewController
@interface UIViewController(SWRevealViewController)

- (MenuViewController*)menuViewController;

@end
