//
//  AppDelegate.m
//  PointTracker
//
//  Created by Andrew Moore on 4/16/13.
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
    // Magic string for connecting to Parse servers
    [Parse setApplicationId:@"nudxR7T6WonMVuXtp7R7Hao2B0VURfTHqa8gPWyk"
                  clientKey:@"eG3RuQZQiiu8spXM1uBdlIloPE7EZY1udg8WD9aL"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // List Tab
    TableListViewController *listViewController =  [[TableListViewController alloc] init];
    UINavigationController *listNavController = [[UINavigationController alloc] initWithRootViewController:listViewController];
    
    // Statistics Tab
    UIViewController *graphPickerViewController = [[GraphpickerViewController alloc] init];
    UINavigationController *graphPickerNavController = [[UINavigationController alloc] initWithRootViewController:graphPickerViewController];
    
    // Log Tab
    UIViewController *logViewController = [[LogViewController alloc] init];
    UINavigationController *logNavController = [[UINavigationController alloc] initWithRootViewController:logViewController];
    
    // Schedule Tab
    WeekPickerViewController *scheduleViewController = [[WeekPickerViewController alloc] init];
    UINavigationController *scheduleNavController = [[UINavigationController alloc] initWithRootViewController:scheduleViewController];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[listNavController, scheduleNavController, graphPickerNavController, logNavController];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application { }

- (void)applicationDidEnterBackground:(UIApplication *)application { }

- (void)applicationWillEnterForeground:(UIApplication *)application { }

- (void)applicationDidBecomeActive:(UIApplication *)application { }

- (void)applicationWillTerminate:(UIApplication *)application { }

@end