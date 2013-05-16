//
//  AppDelegate.m
//  PointTracker
//
//  Created by Andrew Scott on 4/16/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "AppDelegate.h"
#import "TableListViewController.h"
#import "LogViewController.h"
#import "GraphpickerViewController.h"
#import "MyLogInViewController.h"
#import "WeekPickerViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"nudxR7T6WonMVuXtp7R7Hao2B0VURfTHqa8gPWyk"
                  clientKey:@"eG3RuQZQiiu8spXM1uBdlIloPE7EZY1udg8WD9aL"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Set Up Controller for the List Tab
    TableListViewController *listViewController =  [[TableListViewController alloc] init];
    UINavigationController *listNavController = [[UINavigationController alloc] initWithRootViewController:listViewController];
    
    // Set Up Controller for the Statistics Tab
    UIViewController *graphPickerViewController = [[GraphpickerViewController alloc] init];
    UINavigationController *graphPickerNavController = [[UINavigationController alloc] initWithRootViewController:graphPickerViewController];
    
    // Set Up Controller for the Log Tab
    UIViewController *logViewController = [[LogViewController alloc] init];
    UINavigationController *logNavController = [[UINavigationController alloc] initWithRootViewController:logViewController];
    
    // Set Up Controller for the Schedule Tab
    WeekPickerViewController *scheduleViewController = [[WeekPickerViewController alloc] init];
    UINavigationController *scheduleNavController = [[UINavigationController alloc] initWithRootViewController:scheduleViewController];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[listNavController, scheduleNavController, graphPickerNavController, logNavController];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
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

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
