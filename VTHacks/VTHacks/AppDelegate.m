//
//  AppDelegate.m
//  VTHacks
//
//  Created by Vincent Ngo on 3/1/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "AppDelegate.h"
#import <AWSRuntime/AWSRuntime.h>
#import "Constants.h"
#import "MessageBoard.h"
#import "AnnoucementViewController.h"
#import "ScheduleViewController.h"
#import "AnnoucementViewController.h"
#import "ContactsViewController.h"
#import "SocialViewController.h"
#import "AwardsViewController.h"

#import <MessageUI/MessageUI.h>
@implementation AppDelegate


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    NSLog(@"finally! didRegisterForRemoteNotificationsWithDeviceToken");
    //Convert deviceToken to String Type
    const char* data = [deviceToken bytes];
    NSMutableString* tokenString = [NSMutableString string];
    for (int i = 0; i < [deviceToken length]; i++) {
        [tokenString appendFormat:@"%02.2hhX", data[i]];
    }
    NSLog(@"deviceToken String: %@", tokenString);
    
    [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"myDeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // call getannouncements with pulltorefresh:no
    
    
    /*
        On construct of first instance of MessageBoard object:
            1. all the clients are initialized
            2. the app creates its own endpoint and subscribes to sns topic
     */
    [MessageBoard instance];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
	NSLog(@"Failed to register with error : %@", error);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"called didFinishLaunchingWithOPtions!");
    //Register for push notification
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    if(launchOptions != nil)
//    {
//        NSString *msg = [NSString stringWithFormat:@"%@", launchOptions];
//        NSLog(@"%@",msg);
//        
//        NSString *rawBody = launchOptions[@"aps"][@"alert"];
//        if (rawBody != nil && [rawBody length] > 0)
//        {
//            NSArray *components = [rawBody componentsSeparatedByString:@"|"];
//            if (components && [components count] > 1)
//            {
//                
//                if (self.announceVC)
//                    [self.announceVC announceWithSubject: components[0] andBody: components[1]];
//                else
//                {
//                    [AnnoucementViewController setSubject:components[0] andBody:components[1]];
//                }
//                [[Constants universalAlertsWithTitle:components[0] andMessage:components[1]] show];
//            }
//        }
//        else
//            NSLog(@"Invalid body in the message of this notification");
//    }


    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController.navigationController;
    AnnoucementViewController *result;
    
    //check to see if navbar "get" worked
    if (navigationController.viewControllers)
        
        //look for the nav controller in tab bar views
        for (UINavigationController *view in navigationController.viewControllers)
        {
            
            //when found, do the same thing to find the MasterViewController under the nav controller
            if ([view isKindOfClass:[UINavigationController class]])
                for (UIViewController *view2 in view.viewControllers)
                    if ([view2 isKindOfClass:[AnnoucementViewController class]])
                        result = (AnnoucementViewController *) view2;
        }
    
    // Override point for customization after application launch.

    return YES;
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    self.notificationsDict = userInfo;
    NSLog(@"HERE IS THE USER INFO: %@", userInfo);
    application.applicationIconBadgeNumber = 0;
    NSString *rawBody = userInfo[@"aps"][@"alert"];
    if (rawBody != nil && [rawBody length] > 0)
    {
        NSArray *components = [rawBody componentsSeparatedByString:@"|"];
        if (components && [components count] > 1)
        {
            [self.announceVC announceWithSubject: components[0] andBody: components[1]];
            [[Constants universalAlertsWithTitle:components[0] andMessage:components[1]] show];
        }
    }
    else
        NSLog(@"Invalid body in the message of this notification");
}


- (void)subscribeDevice:(id)sender {
    
#if TARGET_IPHONE_SIMULATOR
    [[Constants universalAlertsWithTitle:@"Unable to Subscribe Device" andMessage:@"Push notifications are not supported in the simulator."] show];
    return;
#endif
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        if ([[MessageBoard instance] subscribeDevice]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Subscription succeeded!");
                //[[Constants universalAlertsWithTitle:@"Subscription succeed" andMessage:nil] show];
            });
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSString *)extractMessageFromJson:(NSString *)json
{
    AWS_SBJsonParser *parser = [AWS_SBJsonParser new];
    NSDictionary *jsonDic = [parser objectWithString:json];
    
    return [jsonDic objectForKey:@"Message"];
}



@end
