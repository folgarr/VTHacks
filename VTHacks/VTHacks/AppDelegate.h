//
//  AppDelegate.h
//  VTHacks
//
//  Created by Vincent Ngo on 3/1/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSRuntime/AWSRuntime.h>
#import <AWSSQS/AWSSQS.h>
#import <AWSSNS/AWSSNS.h>
#import "AnnoucementViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AnnoucementViewController *announceVC;
@property (strong, nonatomic) NSDictionary *notificationsDict;

@end
